import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/commons/mysnackbar.dart';
import 'package:spicy_eats/features/Home/screens/Home.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/features/authentication/authServices.dart';
import 'package:spicy_eats/features/authentication/auth_config.dart';
import 'package:spicy_eats/features/authentication/passwordless_signup.dart';
import 'package:spicy_eats/features/authentication/signinscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authenticationRepositoryProvider = Provider((ref) =>
    AuthenticationRepository(supabaseClient: Supabase.instance.client));

class AuthenticationRepository {
  final SupabaseClient supabaseClient;
  AuthenticationRepository({required this.supabaseClient});

  /// Splits a display name like "John Doe Smith" into first/last parts.
  static List<String> splitName(String fullName) {
    final parts =
        fullName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return const ['', ''];
    if (parts.length == 1) return [parts.first, ''];
    return [parts.first, parts.skip(1).join(' ')];
  }

  /// Best-effort insert of the app-level `users` row after an auth sign-up.
  ///
  /// Uses `res.user` (NOT `currentSession`) because with "Confirm email"
  /// enabled there is no session yet. Missing email confirmation returns
  /// false so callers show the "check your inbox" message instead of pushing
  /// Home; failures are swallowed because ProfileRepo self-heals the row on
  /// next fetch.
  Future<bool> _ensureUserRow({
    required User? user,
    required String email,
    String fullName = '',
    String? phone,
  }) async {
    if (user == null) return false;
    try {
      final name = splitName(fullName);
      await supabaseClient.from('users').upsert({
        'id': user.id,
        'email': email,
        'firstname': name[0],
        'lastname': name[1],
        if (phone != null && phone.trim().isNotEmpty)
          'contactno': phone.trim(),
      });
    } catch (_) {
      // Self-healed later by ProfileRepo._createMissingUserRow — not fatal.
    }
    return true;
  }

  Future<void> signInWithMagicLink(
      {required BuildContext context, required String email}) async {
    try {
      // if (!await userExists(email)) {
      //   await supabaseClient.from('users').insert({
      //     'id': supabaseClient.auth.currentSession?.user.id,
      //     'email': supabaseClient.auth.currentSession?.user.email,
      //   });
      // }

      await supabaseClient.auth.signInWithOtp(
          email: email,
          emailRedirectTo: 'io.supabase.spicyeats://login-callback/');
    } on AuthException catch (e) {
      mysnackbar(context: context, text: e.toString());
    } catch (e) {
      mysnackbar(context: context, text: e.toString());
    }
  }

//sign up with email and password
  /// Returns true when a session exists and Home was pushed, false when the
  /// user must confirm their email first.
  Future<bool> signup(
      {required BuildContext context,
      required String email,
      required String password,
      String fullName = '',
      String? phone}) async {
    try {
      final res = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          if (phone != null && phone.trim().isNotEmpty)
            'phone': phone.trim(),
        },
        emailRedirectTo: AuthConfig.supabaseRedirectUrl,
      );

      // Email confirmation ON (default): no session yet. Tell the user to
      // check their inbox instead of navigating anywhere.
      if (res.session == null || res.user == null) {
        await _ensureUserRow(
            user: res.user, email: email, fullName: fullName, phone: phone);
        if (context.mounted) {
          mysnackbar(
              context: context,
              text:
                  'Account created! Please check your email to confirm, then sign in.');
          Navigator.pushNamedAndRemoveUntil(
              context, SignInScreen.routeName, (route) => false);
        }
        return false;
      }

      await _ensureUserRow(
          user: res.user, email: email, fullName: fullName, phone: phone);
      if (context.mounted) {
        mysnackbar(context: context, text: 'Account created. Welcome!');
        Navigator.pushNamedAndRemoveUntil(
            context, Home.routename, (route) => false);
      }
      return true;
    } on AuthException catch (e) {
      if (context.mounted) {
        mysnackbar(context: context, text: e.message);
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        mysnackbar(context: context, text: 'Sign up failed: $e');
      }
      return false;
    }
  }

//signin with email and password
  Future<bool> login(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session == null || response.user == null) {
        if (context.mounted) {
          mysnackbar(
              context: context,
              text: 'Sign in failed. Please confirm your email first.');
        }
        return false;
      }
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.routename, (route) => false);
      }
      return true;
    } on AuthException catch (e) {
      if (context.mounted) {
        mysnackbar(context: context, text: e.message);
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        mysnackbar(context: context, text: e.toString());
      }
      return false;
    }
  }

  Future<bool> userExists(String email) async {
    var value;
    final PostgrestList response;
    // print('value ${value!}');

    try {
      response = await supabaseClient
          .from('auth.users')
          .select('id')
          .eq('email', email);
      if (response != null) {
        print('error ${response}');
      }

      final data = response;
      value = data.isNotEmpty;
    } catch (e) {
      print('error2 ${e.toString()}');
      return false;
    }
    return value;
  }

  void logoutUser(context, WidgetRef ref) async {
    try {
      await supabaseClient.auth.signOut();

      Navigator.pushNamedAndRemoveUntil(
          context, SignInScreen.routeName, (route) => false,
          arguments: ref);
    } catch (e) {
      throw Exception(e);
    }
  }
}
