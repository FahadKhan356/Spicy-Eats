import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spicy_eats/Register%20shop/widgets/restauarantTextfield.dart';
import 'package:spicy_eats/commons/country.dart';
import 'package:spicy_eats/commons/mysnackbar.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/features/authentication/controller/AuthenicationController.dart';
import 'package:spicy_eats/main.dart';

class PasswordlessScreen extends ConsumerStatefulWidget {
  final WidgetRef ref;
  static const String routename = '/phonenumber-screen';
  PasswordlessScreen({super.key, required this.ref});

  @override
  ConsumerState<PasswordlessScreen> createState() => _PhonenumberScreenState();
}

class _PhonenumberScreenState extends ConsumerState<PasswordlessScreen>
    with SingleTickerProviderStateMixin {
  bool _isTextFieldVisible = false;
  late final AnimationController _animationController;
  late Animation<double> _arrowRotation;
  // late final StreamSubscription<AuthState> _streamSubscription;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _arrowRotation =
        Tween<double>(begin: 0, end: 0.5).animate(_animationController);
    super.initState();
    final user = supabaseClient.auth.currentUser;

    if (user == null) {
      return;
    } else {
      print('value of user ${user}');
      uploaddata(user);
      Navigator.pushNamed(context, HomeScreen.routename);
      mysnackbar(context: context, text: 'data loaded to users table ');
    }
  }

  Future<bool> userExists(String email) async {
    var value;
    final response;
    print('value ${value!}');

    try {
      response =
          await supabaseClient.from('auth.users').select().eq('email', email);
      if (response.error != null) {
        return true;
      }

      final data = response.data;
      value = data.isNotEmpty;
    } catch (e) {
      e.toString();
    }
    return value;
  }

  List<bool> buttonsindex = [
    false,
    false,
  ];

  uploaddata(user) async {
    if (user != null) {
      await supabaseClient.from('users').insert({
        'id': user.session?.user.id,
        'email': user.session?.user.email,
      });
    } else {
      print('session is null');
    }
  }

  void updatebuttons(int index, bool value) {
    setState(() {
      buttonsindex[index] = !buttonsindex[index];
    });
  }

  void _toggleTextFieldVisibility() {
    setState(() {
      _isTextFieldVisible = !_isTextFieldVisible;
      if (_isTextFieldVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Nopass_emailController.dispose();
    withpass_signin_emailController.dispose();
    withpass_signup_emailController.dispose();
    signuppassController.dispose();
    signinpassController.dispose();
    _animationController.dispose();
  }

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool isShow = false;
  final Nopass_emailController = TextEditingController();
  final withpass_signup_emailController = TextEditingController();
  final withpass_signin_emailController = TextEditingController();
  final signinpassController = TextEditingController();
  final signuppassController = TextEditingController();

  Country? selectedCountry = Country(
      name: 'Pakistan', code: '+92', image: 'lib/assets/images/pakistan.png');

  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authenticationControllerProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'lib/assets/images/FoodBurger.png',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Welcome',
                              style: GoogleFonts.aBeeZee(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  const BoxShadow(
                                    color: Colors.black45,
                                    offset: Offset(2, 4),
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                  ),
                                ],
                                letterSpacing: 5,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              'to',
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    const BoxShadow(
                                      color: Colors.black45,
                                      offset: Offset(2, 4),
                                      blurRadius: 1,
                                      spreadRadius: 1,
                                    ),
                                  ]),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Spicy Eats',
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    const BoxShadow(
                                      color: Colors.black45,
                                      offset: Offset(2, 4),
                                      blurRadius: 1,
                                      spreadRadius: 1,
                                    ),
                                  ]),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Unlock a world of mouthwatering dishes.',
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // Added space to avoid using Spacer

                      if (!_isTextFieldVisible)
                        SizedBox(
                          height: 60,
                          width: double.maxFinite,
                          child: ElevatedButton(
                            onPressed: () {
                              _toggleTextFieldVisibility();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              side: const BorderSide(
                                  width: 2, color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Passwordless Sign Up',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(width: 10),
                                RotationTransition(
                                  turns: _arrowRotation,
                                  child: const Icon(
                                    Icons.arrow_drop_down_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeInOut,
                        child: _isTextFieldVisible
                            ? Column(
                                children: [
                                  RestaurantTextfield(
                                      controller: Nopass_emailController,
                                      hintext: 'Pertermiconon@gmail.com',
                                      title: 'Enter Email',
                                      onvalidator: (value) {
                                        var temp =
                                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$';
                                        final regix = RegExp(temp);
                                        if (value!.isEmpty) {
                                          return 'Please enter email';
                                        } else if (!regix.hasMatch(value)) {
                                          return 'Please enter correct email format';
                                        }

                                        return null;
                                      }),
                                  IconButton(
                                    icon: RotationTransition(
                                      turns: _arrowRotation,
                                      child: const Icon(
                                        Icons.arrow_drop_down_rounded,
                                        size: 40,
                                      ),
                                    ),
                                    onPressed: _toggleTextFieldVisibility,
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: buttonsindex[0] == true
                            ? Column(
                                children: [
                                  const Text(
                                    'or',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  RestaurantTextfield(
                                      controller:
                                          withpass_signup_emailController,
                                      hintext: 'Petermicinon@yahoo.com',
                                      title: 'Enter Email',
                                      onvalidator: (value) {
                                        var temp =
                                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$';
                                        final regix = RegExp(temp);
                                        if (value!.isEmpty) {
                                          return 'Please enter email';
                                        } else if (!regix.hasMatch(value)) {
                                          return 'Please enter correct email format';
                                        }

                                        return null;
                                      }),
                                  RestaurantTextfield(
                                      controller: signinpassController,
                                      hintext: '* * * * *',
                                      title: 'Enter password',
                                      onvalidator: (value) {
                                        if (value!.length < 8) {
                                          return 'Password must be 8 digits longer';
                                        }
                                        if (value.isEmpty) {
                                          return 'Please enter password';
                                        }
                                        return null;
                                      }),
                                  RotationTransition(
                                    turns: _arrowRotation,
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_drop_down),
                                      onPressed: () {
                                        updatebuttons(0, true);
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      if (buttonsindex[0] == false)
                        SizedBox(
                          height: 60,
                          width: double.maxFinite,
                          child: ElevatedButton(
                              onPressed: () {
                                updatebuttons(1, true);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                side: const BorderSide(
                                    width: 2, color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'SignUp with Password',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(width: 10),
                                  RotationTransition(
                                    turns: _arrowRotation,
                                    child: const Icon(
                                      Icons.arrow_drop_down_outlined,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              )),
                        ),

                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        child: buttonsindex[1] == true
                            ? Column(
                                children: [
                                  RestaurantTextfield(
                                      controller:
                                          withpass_signin_emailController,
                                      hintext: 'Petermicinon@yahoo.com',
                                      title: 'Sign in with Email',
                                      onvalidator: (value) {
                                        var temp =
                                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$';
                                        final regix = RegExp(temp);
                                        if (value!.isEmpty) {
                                          return 'Please enter email';
                                        } else if (!regix.hasMatch(value)) {
                                          return 'Please enter correct email format';
                                        }

                                        return null;
                                      }),
                                  RestaurantTextfield(
                                      controller: signuppassController,
                                      hintext: '* * * * *',
                                      title: ' password',
                                      onvalidator: (value) {
                                        if (value!.length < 8) {
                                          return 'Password must be 8 digits longer';
                                        }
                                        if (value.isEmpty) {
                                          return 'Please enter password';
                                        }
                                        return null;
                                      }),
                                  RotationTransition(
                                    turns: _arrowRotation,
                                    child: IconButton(
                                        onPressed: () {
                                          updatebuttons(1, false);
                                        },
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          size: 30,
                                          color: Colors.black,
                                        )),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),
                      if (buttonsindex[1] == false)
                        SizedBox(
                          height: 60,
                          width: double.maxFinite,
                          child: ElevatedButton(
                              onPressed: () {
                                updatebuttons(1, true);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                side: const BorderSide(
                                    width: 2, color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Signin with Password',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(width: 10),
                                  RotationTransition(
                                    turns: _arrowRotation,
                                    child: const Icon(
                                      Icons.arrow_drop_down_outlined,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      SizedBox(
                        height: 60,
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_form.currentState!.validate()) {
                              if (_isTextFieldVisible == false &&
                                  buttonsindex[0] == false &&
                                  buttonsindex[1] == false) {
                                mysnackbar(
                                    context: context,
                                    text: 'please provide fields');

                                return;
                              }

                              if (_isTextFieldVisible) {
                                authController.signInWithMagicLink(
                                    email: Nopass_emailController.text.trim(),
                                    context: context);
                              }

                              if (buttonsindex[1] == true) {
                                authController.Login(
                                    context: context,
                                    email: withpass_signin_emailController.text
                                        .trim(),
                                    passwrod: signinpassController.text.trim());
                              }
                              if (buttonsindex[0] == true) {
                                authController.signup(
                                    context: context,
                                    email: withpass_signup_emailController.text
                                        .trim(),
                                    passwrod: signuppassController.text.trim());
                              }

                              showDialog(
                                  context: context,
                                  builder: (context) => const AlertDialog(
                                        title: Text('Check your Email inbox'),
                                        content: Text(
                                            'Confirm form your email and redirects to main screen'),
                                      ));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            side:
                                const BorderSide(width: 2, color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
