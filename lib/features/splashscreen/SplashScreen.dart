import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Home/screens/Home.dart';
import 'package:spicy_eats/features/Sqlight%20Database/onBoarding/services/OnBoardingLocalDatabase.dart';
import 'package:spicy_eats/features/authentication/authServices.dart';
import 'package:spicy_eats/features/authentication/passwordless_signup.dart';
import 'package:spicy_eats/features/authentication/signinscreen.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/onBoarding/screen/BoardingScreen.dart';
import 'package:spicy_eats/main.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin{
    late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool? flag;
   final db = LocationLocalDatabase.instance;
    Future<void> resetFlag()async{
final stored = await db.getLocationWithFlag('LocationData');


  if (stored != null) {
    // Only reset the flag, keep the last location
    await db.setLocationWithFlag(
      'LocationData',
       true, // reset for new session
     stored['lastLocation'],
    ).then((value)=>debugPrint('inside then flag value : ${stored['flag']}  Last Loocation : ${stored['lastLocation']}'));
  
  debugPrint('flag value : ${stored['flag']}  Last Loocation : ${stored['lastLocation']}');
  }
  }
  Future<void> onPersistence() async {
    flag = await OnBoardingLocalDatabase.instance.getFlag('boardingFlag');
//     debugPrint('onboarding before: $flag');
// await OnBoardingLocalDatabase.instance.setFlag('boardingFlag',false);
//      debugPrint('onboarding before: $flag');

    await Future.delayed(const Duration(seconds: 3), ()async {
      // final session = supabaseClient.auth.currentSession;
      if (!mounted) return;
      final session = supabaseClient.auth.currentSession;
      // await OnBoardingLocalDatabase.instance.setFlag('boardingFlag',false);
      if (session != null && flag==true) {
        // Already logged in (like from magic link)
        
        Navigator.pushNamedAndRemoveUntil(
            context, Home.routename, (route) => false);
      } else if (flag != null && flag == false) {
        Navigator.pushNamedAndRemoveUntil(
            context, BoardingScreen.routename, (route) => false);
      } else {
        // Not logged in, show login screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          SignInScreen.routeName,
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

Future<void> _initAsync() async {
  await resetFlag(); // now works correctly
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(isloaderProvider.notifier).state = true;
    });
    onPersistence();
_initAsync();
    // Fade animation for logo
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Scale animation for logo
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Slide animation for text
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _slideController.forward();
    });
  }
  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }


  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.black,
  //     body: Column(
  //       children: [
  //         const SizedBox(
  //           height: 200,
  //         ),
  //         Center(
  //           child: Image.asset(
  //             height: 300,
  //             'lib/assets/images/SpicyeatsLogo.png',
  //             fit: BoxFit.contain,
  //           ),
  //         ),
  //         const Spacer(),
  //         const Padding(
  //           padding: EdgeInsets.symmetric(vertical: 20),
  //           child: CircularProgressIndicator(
  //             backgroundColor: Colors.black12,
  //             color: Colors.white,
  //           ),
  //         ),
  //         const Center(
  //             child: Text(
  //           "Version 1.0.0",
  //           style: TextStyle(color: Colors.white),
  //         )),
  //         const SizedBox(
  //           height: 10,
  //         ),
  //       ],
  //     ),
  //   );
  // }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Food Image with Gradient Overlay
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=1200',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dark Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.85),
                  Colors.black.withOpacity(0.95),
                ],
              ),
            ),
          ),

          // Orange Gradient Accent
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.orange.withOpacity(0.2),
                  Colors.transparent,
                  Colors.orange.withOpacity(0.1),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Animated Logo
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'lib/assets/images/SpicyeatsLogo.png',
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Animated Tagline
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'Spicy Eats',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                            shadows: [
                              Shadow(
                                color: Colors.orange.withOpacity(0.5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange[600]!.withOpacity(0.3),
                                Colors.orange[400]!.withOpacity(0.3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.orange.withOpacity(0.5),
                            ),
                          ),
                          child: const Text(
                            'Delicious Food, Delivered Fast',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // Loading Indicator
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // Modern Circular Progress
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.orange[400]!,
                          ),
                          backgroundColor: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Version Info
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        children: [
                          Text(
                            'Version 1.0.0',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Made with ❤️ for food lovers',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating Food Icons (Optional decorative elements)
          Positioned(
            top: 100,
            right: 30,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Icon(
                Icons.restaurant,
                size: 30,
                color: Colors.orange.withOpacity(0.2),
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            left: 40,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Icon(
                Icons.fastfood,
                size: 25,
                color: Colors.orange.withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 50,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Icon(
                Icons.local_pizza,
                size: 20,
                color: Colors.orange.withOpacity(0.1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
