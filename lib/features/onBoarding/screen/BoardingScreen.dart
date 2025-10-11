import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spicy_eats/commons/Responsive.dart';
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
      'title': 'Fast Delivery',
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
        
          actions: [
            TextButton(
              onPressed: () {
                onboardingDone();
              },
              child:  Text(
                'Skip',
                style: TextStyle(color: Colors.orange,fontSize: Responsive.w14px),
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
                    height: Responsive.h300px,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(item['image']),
                            fit: BoxFit.contain)),
                  ),
                  Text(
                    item['title'],
                    style: GoogleFonts.rubik(
                        fontSize: Responsive.w25px, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal:Responsive.w12px ),
                    child: Center(
                      child: Text(
                        item['body'],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.rubik(
                       
                            fontSize: Responsive.w20px,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[300]),
                      ),
                    ),
                  ),
                   SizedBox(
                    height: Responsive.w20px,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        3,
                        (index) => Container(
                              margin:  EdgeInsets.all(Responsive.w6px),
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
                    padding:  EdgeInsets.symmetric(
                        horizontal: Responsive.w30px, vertical: Responsive.h20px),
                    child: SizedBox(
                      height:70, // Responsive.h70px-5,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_selectedIndex == boarding.length - 1) {
                            // TODO: Save "onboarding_done = true" in SQLite and go to home

                            final val = await OnBoardingLocalDatabase.instance
                                .getFlag('boardingFlag');
                          
                            onboardingDone();
                          
                     
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
                            
                            fontSize: Responsive.w20px,
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
