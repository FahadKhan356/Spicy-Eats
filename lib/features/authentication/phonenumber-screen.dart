import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spicy_eats/Register%20shop/widgets/Lists.dart';
import 'package:spicy_eats/commons/country.dart';
import 'package:spicy_eats/features/authentication/otp.dart';

class PhonenumberScreen extends StatefulWidget {
  static const String routename = '/phonenumber-screen';
  const PhonenumberScreen({super.key});

  @override
  State<PhonenumberScreen> createState() => _PhonenumberScreenState();
}

class _PhonenumberScreenState extends State<PhonenumberScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phonenumberController.dispose();
  }

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool isShow = false;
  final phonenumberController = TextEditingController();
  Country? selectedCountry = Country(
      name: 'Pakistan', code: '+92', image: 'lib/assets/images/pakistan.png');

  @override
  Widget build(BuildContext context) {
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
                      // Removing Expanded to prevent Flex error
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Select Country',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(2, 2),
                                        blurRadius: 2,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 30,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black45,
                                                offset: Offset(1, 2),
                                                blurRadius: 2,
                                                spreadRadius: 1,
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.asset(
                                              selectedCountry!.image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(selectedCountry!.name),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isShow = !isShow;
                                          });
                                        },
                                        icon: const Icon(
                                            Icons.arrow_drop_down_sharp),
                                      ),
                                    ],
                                  ),
                                ),
                                isShow
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: countries.length,
                                          itemBuilder: (context, index) {
                                            final country = countries[index];

                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedCountry = country;
                                                  isShow = false;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: index == 2
                                                      ? const BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10))
                                                      : BorderRadius.circular(
                                                          0),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        height: 30,
                                                        width: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black45,
                                                              offset:
                                                                  Offset(1, 2),
                                                              blurRadius: 2,
                                                              spreadRadius: 1,
                                                            )
                                                          ],
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.asset(
                                                            country.image,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(country.name),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Phone Number',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            selectedCountry!.code,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter phonenumber';
                                }
                                final temp = int.tryParse(value);
                                if (temp == null) {
                                  return 'please enter numbers only';
                                }
                                if (value.startsWith('0')) {
                                  return 'please do not add 0 in begining';
                                }
                                if (value.startsWith(selectedCountry!.code)) {
                                  return 'please do not add countrycode in begining';
                                }

                                return null;
                              },
                              controller: phonenumberController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                  //const BorderSide(width: 2, color: Colors.black)
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  //const BorderSide(width: 2, color: Colors.black),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintText: '3312355223',
                                hintStyle:
                                    const TextStyle(color: Colors.black54),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                          height: 30), // Added space to avoid using Spacer
                      SizedBox(
                        height: 60,
                        width: 250,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            side:
                                const BorderSide(width: 2, color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (_form.currentState!.validate()) {
                              Navigator.pushNamed(context, OtpScreen.routename);
                            }
                          },
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
