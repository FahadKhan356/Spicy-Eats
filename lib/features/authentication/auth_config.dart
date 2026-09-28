/// Central place for the social sign-in configuration.
///
/// How to fill this in:
/// 1. Google Cloud Console -> APIs & Services -> Credentials. Create THREE
///    OAuth 2.0 client IDs inside the SAME Google Cloud project:
///      a. "Web application"      -> [googleWebClientId]
///      b. "iOS" (Bundle ID must match ios/Runner) -> [googleIosClientId]
///      c. "Android" (package name + SHA-1)        -> not needed here, the
///         plugin picks it up from android/app/google-services.json
/// 2. Supabase Dashboard -> Authentication -> Providers -> Google: enable it and
///    paste the *Web* client ID and its secret.
/// 3. Put the reversed iOS client ID (com.googleusercontent.apps.XXXX) into
///    ios/Runner/Info.plist under CFBundleURLTypes / GIDClientID.
class AuthConfig {
  AuthConfig._();

  /// Value that must be replaced before the matching platform can be used.
  static const String _placeholder = 'REPLACE_WITH';

  /// OAuth 2.0 client of type "Web application".
  /// Used as `serverClientId` on Android/iOS and inside Supabase.
  static const String googleWebClientId =
      '1018000999497-f8j2q1fg4gu1i95d33apej6v42mq9km0.apps.googleusercontent.com';

  /// OAuth 2.0 client of type "iOS".
  /// Only used on iOS/macOS, where `GoogleSignIn.clientId` is required.
  static const String googleIosClientId =
      'REPLACE_WITH_IOS_CLIENT_ID.apps.googleusercontent.com';

  /// Reverse-DNS form of [googleIosClientId], i.e.
  /// `com.googleusercontent.apps.<the numeric part>`. Must also be present in
  /// ios/Runner/Info.plist -> CFBundleURLTypes -> CFBundleURLSchemes.
  static const String googleIosReversedClientId =
      'com.googleusercontent.apps.REPLACE_WITH_IOS_CLIENT_ID';

  /// Deep link that Supabase redirects back to (magic link / OAuth).
  /// Must stay in sync with AndroidManifest.xml and Info.plist.
  static const String supabaseRedirectUrl = 'io.supabase.spicyeats://login-callback/';

  /// Scheme part of [supabaseRedirectUrl].
  static const String supabaseRedirectScheme = 'io.supabase.spicyeats';

  static bool isPlaceholder(String value) =>
      value.trim().isEmpty || value.contains(_placeholder);

  /// True when the web client ID (needed on every platform) is filled in.
  static bool get isGoogleWebConfigured =>
      !isPlaceholder(googleWebClientId);

  /// True when the iOS client ID + reversed client ID are filled in.
  static bool get isGoogleIosConfigured =>
      !isPlaceholder(googleIosClientId) &&
      !isPlaceholder(googleIosReversedClientId);
}

/// Thrown when a social provider cannot be used because the project still has
/// placeholder credentials in [AuthConfig] or missing platform config.
/// Screens catch this and show a readable message instead of crashing.
class SocialSignInNotConfiguredException implements Exception {
  const SocialSignInNotConfiguredException(this.message);

  final String message;

  @override
  String toString() => message;
}
