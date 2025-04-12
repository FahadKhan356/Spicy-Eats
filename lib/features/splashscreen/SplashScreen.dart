import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Home/screens/Home.dart';
import 'package:spicy_eats/features/authentication/passwordless_signup.dart';
import 'package:spicy_eats/main.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Future<void> onPersistence() async {
    await Future.delayed(const Duration(seconds: 3), () {
      // final session = supabaseClient.auth.currentSession;
      if (!mounted) return;
      final session = supabaseClient.auth.currentSession;
      if (session != null) {
        // Already logged in (like from magic link)
        Navigator.pushNamedAndRemoveUntil(
            context, Home.routename, (route) => false);
      } else {
        // Not logged in, show login screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          PasswordlessScreen.routename,
          (route) => false,
          arguments: ref,
        );
      }
    });
  }
  //   Future.delayed(const Duration(seconds: 10), () {
  //     supabaseClient.auth.currentSession != null
  //         ? Navigator.pushNamed(context, Home.routename)
  //         : Navigator.pushNamed(context, PasswordlessScreen.routename,
  //             arguments: ref);
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onPersistence();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(
            height: 200,
          ),
          Center(
            child: Image.asset(
              height: 300,
              'lib/assets/images/SpicyeatsLogo.png',
              fit: BoxFit.contain,
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: CircularProgressIndicator(
              backgroundColor: Colors.black12,
              color: Colors.white,
            ),
          ),
          const Center(
              child: Text(
            "Version 1.0.0",
            style: TextStyle(color: Colors.white),
          )),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
