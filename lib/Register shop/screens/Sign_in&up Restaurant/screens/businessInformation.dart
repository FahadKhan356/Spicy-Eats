import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/controller/registershop_controller.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/legalstuffscreen.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/register_restaurant.dart';
import 'package:spicy_eats/Register%20shop/utils/restaurantNotifier.dart';
import 'package:spicy_eats/Register%20shop/widgets/Lists.dart';
import 'package:spicy_eats/Register%20shop/widgets/Mybottomsheet.dart';
import 'package:spicy_eats/Register%20shop/widgets/restauarantTextfield.dart';

var restaurantDescriptionProvider = StateProvider<String?>((ref) => null);
var restaurantDeliveryFeeProvider = StateProvider<double?>((ref) => null);
var restaurantDeliveryMinTimeProvider = StateProvider<int?>((ref) => null);
var restaurantDeliveryMaxTimeProvider = StateProvider<int?>((ref) => null);
var restaurantDeliveryAreaProvider = StateProvider<String?>((ref) => null);
var restaurantPostalCodeProvider = StateProvider<String?>((ref) => null);

var isBottomSheetProvider = StateProvider((ref) => false);

class BusinessDetailsScreen extends ConsumerStatefulWidget {
  static const String routename = '/business-details/screen';
  const BusinessDetailsScreen({super.key});

  @override
  ConsumerState<BusinessDetailsScreen> createState() =>
      _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends ConsumerState<BusinessDetailsScreen> {
  RegisterShopContoller registerShopContoller = RegisterShopContoller();
  var restaurantdescriptionController = TextEditingController();
  var deliveryareacontroller = TextEditingController();
  var postalcodeController = TextEditingController();
  var deliveryfee = TextEditingController();
  var deliveryMinTime = TextEditingController();
  var deliveryMaxTime = TextEditingController();

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final formData = ref.watch(restaurantstateProvider);
    final formNotifier = ref.read(restaurantstateProvider.notifier);
    final restaurantData = ref.read(restaurantDataProvider.notifier).state;

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
                          //'https://plus.unsplash.com/premium_photo-1664298753317-179db93f8ad5?q=80&w=1539&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
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
                          ref.read(restaurantDataProvider.notifier).state =
                              restaurantData.copywith(
                            description: value,
                          );
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
                          onPressed: () {
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
                                controller: deliveryfee,
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
                                controller: deliveryMinTime,
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
                                controller: deliveryMaxTime,
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
                          controller: deliveryareacontroller,
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
                          controller: postalcodeController,
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
                                  Navigator.pushNamed(context,
                                      LegalInformationScreen.routename);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please pick your restaurant location')));
                              },
                              child: GestureDetector(
                                onTap: () {
                                  // formNotifier
                                  //     .setRestaurantData(formData.copywith(
                                  //   description:
                                  //       restaurantdescriptionController.text,
                                  //   openingHours: openinghours,
                                  //   deliveryFee:
                                  //       double.tryParse(deliveryfee.text),
                                  //   minTime: int.tryParse(deliveryMinTime.text),
                                  //   maxTime: int.tryParse(deliveryMaxTime.text),
                                  //   deliveryArea: deliveryareacontroller.text,
                                  //   postalCode: postalcodeController.text,
                                  // ));

                                  //////////////////////
                                  // ref
                                  //     .read(restaurantstateProvider.notifier)
                                  //     .setRestaurantData(
                                  //       description:
                                  //           restaurantdescriptionController
                                  //               .text,
                                  //       openingHours: openinghours,
                                  //       deliveryFee:
                                  //           double.tryParse(deliveryfee.text),
                                  //       minTime:
                                  //           int.tryParse(deliveryMinTime.text),
                                  //       maxTime:
                                  //           int.tryParse(deliveryMaxTime.text),
                                  //       deliveryArea:
                                  //           deliveryareacontroller.text,
                                  //       postalCode: postalcodeController.text,
                                  // //     );
                                  // registerShopContoller.updatePage2(
                                  //   description:
                                  //       restaurantdescriptionController.text,
                                  //   deliveryarea: deliveryareacontroller.text,
                                  //   postalcode: postalcodeController.text,
                                  //   deliveryfee:
                                  //       double.tryParse(deliveryfee.text),
                                  //   mintime: int.tryParse(deliveryMinTime.text),
                                  //   maxtime: int.tryParse(deliveryMaxTime.text),
                                  //   openhours: openinghours,
                                  // );

                                  // ref
                                  //     .read(restaurantDataProvider.notifier)
                                  //     .state = restaurantData.copywith(
                                  //   openingHours: openinghours,
                                  // );
                                  Navigator.pushNamed(context,
                                      LegalInformationScreen.routename);
                                  print(formData.toJson());
                                },
                                child: const Text(
                                  'Next',
                                  style: TextStyle(color: Colors.white),
                                ),
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
