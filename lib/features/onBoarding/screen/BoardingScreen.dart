import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spicy_eats/features/Sqlight%20Database/onBoarding/services/OnBoardingLocalDatabase.dart';
import 'package:spicy_eats/features/authentication/passwordless_signup.dart';

class BoardingScreen extends ConsumerStatefulWidget {
  static const String routename = '/boarding_screen';
  const BoardingScreen({super.key});

  @override
  ConsumerState<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends ConsumerState<BoardingScreen> {
  @override
  void dispose() {
    boardingController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  final PageController boardingController = PageController();
  final List<Map<String, dynamic>> boarding = [
    {
      'image': 'lib/assets/images/onboarding1.jpg',
      'title': 'fast Delivery',
      'body': 'Fast food delivery to your home or office',
    },
    {
      'image': 'lib/assets/images/onboarding2.png',
      'title': 'Nourish to Flourish',
      'body': 'Exploring the Healing Power of Food',
    },
    {
      'image': 'lib/assets/images/onboarding3.png',
      'title': 'Tastebud Trip',
      'body': 'A fun and playful title that promises a journey of flavor',
    },
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    onboardingDone() async {
      await OnBoardingLocalDatabase.instance.setFlag('boardingFlag', true);
    }

    return Scaffold(
        appBar: AppBar(
          leading:
              const Icon(Icons.arrow_back_ios_new_sharp, color: Colors.orange),
          actions: [
            TextButton(
              onPressed: () {
                onboardingDone();
              },
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.orange),
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: PageView.builder(
            controller: boardingController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            itemCount: boarding.length,
            itemBuilder: (context, index) {
              final item = boarding[index];
              return Column(
                children: [
                  Container(
                    height: 300,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(item['image']),
                            fit: BoxFit.contain)),
                  ),
                  Text(
                    item['title'],
                    style: GoogleFonts.rubik(
                        fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    item['body'],
                    style: GoogleFonts.rubik(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[300]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        3,
                        (index) => Container(
                              margin: const EdgeInsets.all(8),
                              height: index == _selectedIndex ? 10 : 8,
                              width: index == _selectedIndex ? 10 : 8,
                              decoration: BoxDecoration(
                                  color: index == _selectedIndex
                                      ? Colors.orange
                                      : Colors.grey[300],
                                  shape: BoxShape.circle),
                            )),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: SizedBox(
                      height: 65,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_selectedIndex == boarding.length - 1) {
                            // TODO: Save "onboarding_done = true" in SQLite and go to home

                            final val = await OnBoardingLocalDatabase.instance
                                .getFlag('boardingFlag');
                            debugPrint('onBoarding Flag before $val');
                            onboardingDone();
                            final val1 = await OnBoardingLocalDatabase.instance
                                .getFlag('boardingFlag');
                            debugPrint('onBoarding Flag afet $val1');
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              PasswordlessScreen.routename,
                              (route) => false,
                              arguments: ref,
                            );
                          } else {
                            boardingController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutQuart,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: Text(
                          _selectedIndex == boarding.length - 1
                              ? 'Done'
                              : 'Next',
                          style: GoogleFonts.rubik(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}
