import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  void signup(
      {required BuildContext context,
      required String email,
      required String passwrod}) {
    authenticationRepository.signup(
        context: context, email: email, password: passwrod);
  }

//sign up with email and password both

  void Login(
      {required BuildContext context,
      required String email,
      required String passwrod}) {
    authenticationRepository.login(
        context: context, email: email, password: passwrod);
  }
}
