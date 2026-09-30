import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/commons/mysnackbar.dart';
import 'package:spicy_eats/features/Home/screens/Home.dart';
import 'package:spicy_eats/features/authentication/authServices.dart';
import 'package:spicy_eats/features/authentication/auth_config.dart';
import 'package:spicy_eats/features/authentication/repository/AuthenticationRepository.dart';

final authenticationControllerProvider = Provider((ref) {
  final authrepo = ref.watch(authenticationRepositoryProvider);
  return AuthenticationController(authenticationRepository: authrepo);
});

class AuthenticationController {
  AuthenticationRepository authenticationRepository;
  AuthenticationController({required this.authenticationRepository});
//signup with magiclink
  void signInWithMagicLink(
      {required BuildContext context, required String email}) {
    authenticationRepository.signInWithMagicLink(
        context: context, email: email);
  }

  //sign up with email and password both

  Future<bool> signup(
      {required BuildContext context,
      required String email,
      required String passwrod,
      String fullName = '',
      String? phone}) {
    return authenticationRepository.signup(
        context: context,
        email: email,
        password: passwrod,
        fullName: fullName,
        phone: phone);
  }

//sign in with email and password

  Future<bool> Login(
      {required BuildContext context,
      required String email,
      required String passwrod}) {
    return authenticationRepository.login(
        context: context, email: email, password: passwrod);
  }

  /// Social sign-ins used to crash: the Google native SDK threw (missing
  /// google-services.json / wrong SHA-1 / placeholder client id) and the raw
  /// exception left [_isLoading] spinning or took the app down. Centralising
  /// the flow here shows a readable message and always resets loading state.
  Future<bool> signInWithGoogle(
      {required BuildContext context, required VoidCallback setLoading}) async {
    final authService = AuthService();
    setLoading();
    try {
      final response = await authService.signInWithGoogle();
      if (response?.user == null) return false; // user dismissed the sheet
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, Home.routename);
      }
      return true;
    } on SocialSignInNotConfiguredException catch (e) {
      if (context.mounted) {
        mysnackbar(context: context, text: e.message);
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        mysnackbar(context: context, text: 'Google sign in failed: $e');
      }
      return false;
    } finally {
      setLoading();
    }
  }

  void logout(context, WidgetRef ref) {
    authenticationRepository.logoutUser(context, ref);
  }
}
