// ==================== SETUP INSTRUCTIONS ====================
/*
1. Add to pubspec.yaml:
dependencies:
  supabase_flutter: ^2.0.0
  google_sign_in: ^6.1.5

2. Initialize Supabase in main.dart:
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);

3. Setup Google Cloud Console (console.cloud.google.com):
   A. Create OAuth 2.0 Client IDs for:
      * Web application → Get Web Client ID
      * Android → Get Android Client ID
      * iOS (with Bundle ID) → Get iOS Client ID

   B. For Android Client ID:
      - Get SHA-1 fingerprint (see step 5 below)
      - Package name: com.yourcompany.yourapp (from AndroidManifest.xml)

4. Setup Supabase Dashboard:
   - Go to Authentication → Providers → Google
   - Enable Google
   - Paste your Web Client ID
   - Paste your Web Client Secret
   - For iOS: Check "Skip nonce checks for iOS client"
   - Save

5. Get SHA-1 Fingerprint for Android:
   Open terminal in your project and run:
   
   For Debug:
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   
   For Release:
   keytool -list -v -keystore /path/to/your/release.keystore -alias your-alias-name
   
   Copy the SHA-1 and add to Google Console → Android OAuth Client

6. Android Setup:
   
   A. android/app/build.gradle:
      - Ensure minSdkVersion is at least 21
      
      android {
          defaultConfig {
              minSdkVersion 21
              // ... other configs
          }
      }
   
   B. android/app/src/main/AndroidManifest.xml:
      Add inside <application> tag:
      
      <meta-data
          android:name="com.google.android.gms.version"
          android:value="@integer/google_play_services_version" />

7. iOS Setup (ios/Runner/Info.plist):
   Add before </dict>:
   
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleTypeRole</key>
       <string>Editor</string>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>YOUR_REVERSED_CLIENT_ID</string>
       </array>
     </dict>
   </array>
   
   <key>GIDClientID</key>
   <string>YOUR_IOS_CLIENT_ID.apps.googleusercontent.com</string>
   
   Note: Reversed Client ID format: com.googleusercontent.apps.123456789

8. IMPORTANT - Client IDs Explained:
   - Web Client ID: Used for serverClientId parameter
   - Android Client ID: Auto-detected by package name + SHA-1
   - iOS Client ID: Used for clientId parameter
   - All three must be from the SAME Google Cloud project!
*/

// ==================== AUTH SERVICE ====================
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:spicy_eats/features/authentication/auth_config.dart';
// ==================== FACEBOOK SETUP INSTRUCTIONS ====================
/*
1. Add to pubspec.yaml:
dependencies:
  supabase_flutter: ^2.0.0
  flutter_facebook_auth: ^6.0.0

2. Setup Facebook Developers (developers.facebook.com):
   
   A. Create a Facebook App:
      - Go to developers.facebook.com
      - Click "Create App" → Choose "Consumer" type
      - Enter App Name and Contact Email
      - Create App ID

   B. Add Facebook Login Product:
      - In left sidebar → Click "Add Product"
      - Find "Facebook Login" → Click "Set Up"
      - Choose "Native" or "Web" platform

   C. Configure OAuth Redirect URIs:
      - Settings → Basic → Get your App ID and App Secret
      - Facebook Login → Settings
      - Add Valid OAuth Redirect URIs:
        https://YOUR_PROJECT_REF.supabase.co/auth/v1/callback
      - Save Changes

3. Setup Supabase Dashboard:
   - Go to Authentication → Providers → Facebook
   - Enable Facebook
   - Enter Facebook App ID
   - Enter Facebook App Secret
   - Save

4. ANDROID Setup (android/app/src/main/AndroidManifest.xml):
   Add inside <application> tag:

   <meta-data 
       android:name="com.facebook.sdk.ApplicationId" 
       android:value="@string/facebook_app_id"/>
   
   <meta-data 
       android:name="com.facebook.sdk.ClientToken" 
       android:value="@string/facebook_client_token"/>
   
   <activity 
       android:name="com.facebook.FacebookActivity"
       android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation"
       android:label="@string/app_name" />
   
   <activity
       android:name="com.facebook.CustomTabActivity"
       android:exported="true">
       <intent-filter>
           <action android:name="android.intent.action.VIEW" />
           <category android:name="android.intent.category.DEFAULT" />
           <category android:name="android.intent.category.BROWSABLE" />
           <data android:scheme="@string/fb_login_protocol_scheme" />
       </intent-filter>
   </activity>

   Create: android/app/src/main/res/values/strings.xml:
   
   <?xml version="1.0" encoding="utf-8"?>
   <resources>
       <string name="app_name">Your App Name</string>
       <string name="facebook_app_id">YOUR_FACEBOOK_APP_ID</string>
       <string name="facebook_client_token">YOUR_FACEBOOK_CLIENT_TOKEN</string>
       <string name="fb_login_protocol_scheme">fbYOUR_FACEBOOK_APP_ID</string>
   </resources>

5. iOS Setup (ios/Runner/Info.plist):
   Add before </dict>:

   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>fbYOUR_FACEBOOK_APP_ID</string>
       </array>
     </dict>
   </array>
   
   <key>FacebookAppID</key>
   <string>YOUR_FACEBOOK_APP_ID</string>
   
   <key>FacebookClientToken</key>
   <string>YOUR_FACEBOOK_CLIENT_TOKEN</string>
   
   <key>FacebookDisplayName</key>
   <string>Your App Name</string>
   
   <key>LSApplicationQueriesSchemes</key>
   <array>
     <string>fbapi</string>
     <string>fb-messenger-share-api</string>
   </array>

6. Get Facebook Client Token:
   - Go to Facebook App Dashboard
   - Settings → Advanced
   - Scroll to "Security" section
   - Copy Client Token

7. Testing:
   - Add test users in Facebook App Dashboard → Roles → Test Users
   - Or make app live: App Review → Request Advanced Access
*/

// ==================== ENHANCED AUTH SERVICE ====================

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  // Get current user
  User? get currentUser => _supabase.auth.currentUser;
  
  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;
  
  // Auth state stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // ==================== EMAIL SIGN UP ====================
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone': phone,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // ==================== EMAIL SIGN IN ====================
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // ==================== GOOGLE SIGN IN ====================
  // NOTE: `GoogleSignIn.clientId` is only valid on iOS/macOS. On Android the
  // plugin resolves the OAuth client from android/app/google-services.json, so
  // passing an iOS client id there breaks the native flow. Previously this
  // method always passed the literal placeholder 'YOUR_IOS_CLIENT_ID...', which
  // made the native SDK throw and took the whole app down.
  Future<AuthResponse?> signInWithGoogle() async {
    final bool isApplePlatform =
        defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS;

    if (!AuthConfig.isGoogleWebConfigured) {
      throw const SocialSignInNotConfiguredException(
        'Google Sign-In is not set up yet. Add the Web OAuth client id to '
        'lib/features/authentication/auth_config.dart.',
      );
    }

    if (isApplePlatform && !AuthConfig.isGoogleIosConfigured) {
      throw const SocialSignInNotConfiguredException(
        'Google Sign-In is not set up for iOS/macOS yet. Add the iOS OAuth '
        'client id to lib/features/authentication/auth_config.dart and the '
        'reversed client id to ios/Runner/Info.plist.',
      );
    }

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: isApplePlatform ? AuthConfig.googleIosClientId : null,
      serverClientId: AuthConfig.googleWebClientId,
      scopes: const ['email', 'profile'],
    );

    try {
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();

      // User dismissed the Google sheet - not an error.
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw const SocialSignInNotConfiguredException(
          'Google did not return an id token. Check that the Web client id in '
          'auth_config.dart matches the Google provider configured in Supabase.',
        );
      }

      // `signInWithIdToken` is still flagged experimental by supabase_flutter
      // but is the documented way to exchange native provider tokens.
      // ignore: experimental_member_use
      return await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } on SocialSignInNotConfiguredException {
      rethrow;
    } on AuthException {
      rethrow;
    } on PlatformException catch (e) {
      // Native Google Sign-In failures (missing google-services.json, wrong
      // bundle id / SHA-1, user-closed sheet on some OEMs, ...).
      throw SocialSignInNotConfiguredException(
        'Google Sign-In failed (${e.code})'
        '${e.message == null ? '' : ': ${e.message}'}',
      );
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      throw SocialSignInNotConfiguredException('Google Sign-In failed: $e');
    }
  }

  // ==================== FACEBOOK SIGN IN (NATIVE) ====================
  Future<AuthResponse?> signInWithFacebook() async {
    try {
      // Trigger Facebook Login
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      // Check login status
      if (result.status == LoginStatus.success) {
        // Get access token
        final accessToken = result.accessToken;
        
        if (accessToken == null) {
          throw 'Failed to get Facebook access token';
        }

        // Sign in to Supabase with Facebook credentials
        // `signInWithIdToken` is still flagged experimental by supabase_flutter
        // but is the documented way to exchange native provider tokens.
        // ignore: experimental_member_use
        final response = await _supabase.auth.signInWithIdToken(
          provider: OAuthProvider.facebook,
          idToken: accessToken.token,
        );

        return response;
      } else if (result.status == LoginStatus.cancelled) {
        // User cancelled the login
        return null;
      } else {
        // Login failed
        throw 'Facebook login failed: ${result.message}';
      }
    } catch (e) {
      debugPrint('Error signing in with Facebook: $e');
      rethrow;
    }
  }

  // ==================== FACEBOOK SIGN IN (WEB REDIRECT) ====================
  // Alternative method - simpler but uses web redirect
  Future<bool> signInWithFacebookRedirect() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: 'io.supabase.flutterdemo://login-callback/',
      );
      return true;
    } catch (e) {
      debugPrint('Error with Facebook redirect: $e');
      return false;
    }
  }

  // ==================== GET FACEBOOK USER DATA ====================
  Future<Map<String, dynamic>?> getFacebookUserData() async {
    try {
      final userData = await FacebookAuth.instance.getUserData(
        fields: "name,email,picture.width(200)",
      );
      return userData;
    } catch (e) {
      debugPrint('Error getting Facebook user data: $e');
      return null;
    }
  }

  // ==================== SIGN OUT ====================
  Future<void> signOut() async {
    // Every provider is shut down independently: on platforms without a Google
    // / Facebook implementation (macOS, desktop, ...) the plugin throws, and
    // previously that aborted the whole sign-out so the Supabase session was
    // never cleared.
    try {
      await GoogleSignIn().signOut();
    } catch (e) {
      debugPrint('Google sign out skipped: $e');
    }

    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      debugPrint('Facebook sign out skipped: $e');
    }

    await _supabase.auth.signOut();
  }

  // ==================== PASSWORD RESET ====================
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  // ==================== UPDATE USER ====================
  Future<UserResponse> updateUser({
    String? fullName,
    String? phone,
  }) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(
          data: {
            if (fullName != null) 'full_name': fullName,
            if (phone != null) 'phone': phone,
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
