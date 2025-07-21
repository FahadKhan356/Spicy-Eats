import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/commons/mysnackbar.dart';
import 'package:spicy_eats/features/Home/screens/Home.dart';
import 'package:spicy_eats/features/authentication/passwordless_signup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authenticationRepositoryProvider = Provider((ref) =>
    AuthenticationRepository(supabaseClient: Supabase.instance.client));

class AuthenticationRepository {
  final SupabaseClient supabaseClient;
  AuthenticationRepository({required this.supabaseClient});

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
  Future<void> signup(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      final res = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        // emailRedirectTo: 'io.supabase.spicyeats://login-callback/'
      );
      await supabaseClient.from('users').insert({
        'id': supabaseClient.auth.currentSession?.user.id,
        'email': supabaseClient.auth.currentSession?.user.id,
      });
      if (res.user != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, Home.routename, (route) => false);
      }

      mysnackbar(context: context, text: 'Authentication failed');
    } on AuthException catch (e) {
      mysnackbar(context: context, text: 'please enter email ${e.toString()}');
    } catch (e) {
      mysnackbar(context: context, text: 'error message in sign up $e');
    }
  }

//signin with email and password
  Future<void> login(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      supabaseClient.from('users').insert({
        'id': response.session!.user.id,
        'email': response.session!.user.email,
      });
    } on AuthException catch (e) {
      print(' what is the error1 ....  ${e.toString()}');

      mysnackbar(context: context, text: 'please enter email ${e.toString()}');
    } catch (e) {
      print(' what is the error2 ....  ${e.toString()}');
      mysnackbar(context: context, text: e.toString());
    }
  }

  Future<bool> userExists(String email) async {
    var value;
    final response;
    // print('value ${value!}');

    try {
      response = await supabaseClient
          .from('auth.users')
          .select('id')
          .eq('email', email);
      if (response.error != null) {
        print('error ${response.error}');
      }

      final data = response.data;
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
          context, PasswordlessScreen.routename, (route) => false,
          arguments: ref);
    } catch (e) {
      throw Exception(e);
    }
  }
}
