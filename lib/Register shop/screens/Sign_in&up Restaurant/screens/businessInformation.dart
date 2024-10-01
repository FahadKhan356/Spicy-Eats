import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/controller/registershop_controller.dart';
import 'package:spicy_eats/Register%20shop/models/registershop.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/legalstuffscreen.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/paymentmethodescreen.dart';
import 'package:spicy_eats/Register%20shop/widgets/Mybottomsheet.dart';
import 'package:spicy_eats/Register%20shop/widgets/restauarantTextfield.dart';
import 'package:spicy_eats/commons/imagepick.dart';

import 'package:spicy_eats/main.dart';

var restaurantDescriptionProvider = StateProvider<String?>((ref) => null);
var restaurantDeliveryFeeProvider = StateProvider<double?>((ref) => null);
var restaurantDeliveryMinTimeProvider = StateProvider<int?>((ref) => null);
var restaurantDeliveryMaxTimeProvider = StateProvider<int?>((ref) => null);
var restaurantDeliveryAreaProvider = StateProvider<String?>((ref) => null);
var restaurantPostalCodeProvider = StateProvider<String?>((ref) => null);
var restImageFileProvider = StateProvider<File?>((ref) => null);
var restLogoFileProvider = StateProvider<File?>((ref) => null);

var isBottomSheetProvider = StateProvider((ref) => false);

class BusinessDetailsScreen extends ConsumerStatefulWidget {
  static const String routename = '/business-details/screen';
  const BusinessDetailsScreen({super.key});

  @override
  ConsumerState<BusinessDetailsScreen> createState() =>
      _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends ConsumerState<BusinessDetailsScreen> {
  List<RestaurantData>? restaurants;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref
        .read(registershopcontrollerProvider)
        .fetchrestaurants(supabaseClient.auth.currentUser!.id)
        .then((restaurant) {
      if (restaurant != null) {
        setState(() {
          restaurants = restaurant;
          print(restaurant.length);
        });
      }
    });
  }

  var restaurantdescriptionController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  File? image;
  void pickimagefromgallery() async {
    image = await imagePicker(context);
    setState(() {});
    print('this is id image $image');
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _form,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                  collapsedHeight: 60,
                  pinned: true,
                  floating: true,
                  expandedHeight: 300,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding:
                          const EdgeInsets.only(top: 50, left: 10, right: 10),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1533052286801-2385cb274342?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  backgroundColor: Colors.white,
                  leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                      onPressed: () => Navigator.pop(context)),
                  title: Padding(
                    padding: const EdgeInsets.all(.0),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      height: 50,
                      width: MediaQuery.of(context).size.width - 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: Text(
                          'Buissiness Details',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Restaurant Description',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      TextFormField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLength: 150,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please give restaurant description';
                          }

                          ref
                              .read(restaurantDescriptionProvider.notifier)
                              .state = value;
                          return null;
                        },
                        onChanged: (value) {
                          if (value.contains('\n')) {
                            restaurantdescriptionController.text =
                                value.replaceAll('\n', '');
                            restaurantdescriptionController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: restaurantdescriptionController
                                        .text.length));
                          }
                        },
                        controller: restaurantdescriptionController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                              //const BorderSide(
                              //     width: 2, color: Colors.black)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              //const BorderSide(
                              //     width: 2, color: Colors.black),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText:
                                'This restaurant provides tasty and delicious chinese food...',
                            hintStyle: const TextStyle(color: Colors.black54),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                      ),
                      SizedBox(
                        height: 60,
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: () async {
                            ref.watch(restImageFileProvider.notifier).state =
                                await pickImageFromGallerymob(context);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              backgroundColor: Colors.black),
                          child: Text(
                            'Upload Restaurant Display Image',
                            style: TextStyle(
                                fontSize: height * 0.02, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 60,
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: () async {
                            ref.watch(restLogoFileProvider.notifier).state =
                                await pickImageFromGallerymob(context);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              backgroundColor: Colors.black),
                          child: Text(
                            'Upload Restaurant Logo',
                            style: TextStyle(
                                fontSize: height * 0.02, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 60,
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: () {
                            print(
                                '${ref.read(restImageFileProvider)} this is rest image');
                            showMyBottomSheet(context);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              backgroundColor: Colors.black),
                          child: Text(
                            'Set your restaurant schedule(optional)',
                            style: TextStyle(
                                fontSize: height * 0.02, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: RestaurantTextfield(
                                hintext: '\$12',
                                title: 'delivery fee',
                                size: 14,
                                onvalidator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter delivery area here';
                                  }
                                  ref
                                      .read(restaurantDeliveryFeeProvider
                                          .notifier)
                                      .state = double.tryParse(value);
                                  return null;
                                }),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: RestaurantTextfield(
                                hintext: '20, 25 ...',
                                title: 'delivery min time',
                                size: 14,
                                onvalidator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter delivery area here';
                                  }
                                  ref
                                      .read(restaurantDeliveryMinTimeProvider
                                          .notifier)
                                      .state = int.tryParse(value);

                                  return null;
                                }),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: RestaurantTextfield(
                                hintext: '40 , 60 ...',
                                title: 'delivery max time',
                                size: 14,
                                onvalidator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter delivery area here';
                                  }
                                  var temp = int.tryParse(value);
                                  if (temp == null) {
                                    return 'please enter number';
                                  }
                                  ref
                                      .read(restaurantDeliveryMaxTimeProvider
                                          .notifier)
                                      .state = int.tryParse(value);

                                  return null;
                                }),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RestaurantTextfield(
                          hintext: 'Delhi , Kolkata, san francisco',
                          title: 'Delivery Area',
                          onvalidator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter delivery area here';
                            }
                            ref
                                .read(restaurantDeliveryAreaProvider.notifier)
                                .state = value;

                            return null;
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      RestaurantTextfield(
                          hintext: 'Your city postal code ie:1700, 22009 etc',
                          title: 'Postal code',
                          onvalidator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter city postal code';
                            }
                            ref
                                .read(restaurantPostalCodeProvider.notifier)
                                .state = value;
                            return null;
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          height: 60,
                          width: 250,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  side: const BorderSide(
                                      width: 2, color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () {
                                if (_form.currentState!.validate()) {
                                  restaurants!.isNotEmpty && restaurants != null
                                      ? Navigator.pushNamed(context,
                                          PaymentMethodScreen.routename,
                                          arguments: restaurants)
                                      : Navigator.pushNamed(context,
                                          LegalInformationScreen.routename);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please pick your restaurant location')));
                              },
                              child: const Text(
                                'Next',
                                style: TextStyle(color: Colors.white),
                              ))),
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
