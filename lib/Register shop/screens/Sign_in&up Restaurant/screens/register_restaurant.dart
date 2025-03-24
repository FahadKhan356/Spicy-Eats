import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/models/restaurant_model.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/businessInformation.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/widgets/map.dart';
import 'package:spicy_eats/Register%20shop/widgets/restauarantTextfield.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';

var isMapPickProvider = StateProvider<bool>((ref) => false);
var restaurantLatProvider = StateProvider<double?>((ref) => null);
var restaurantLongProvider = StateProvider<double?>((ref) => null);
var restaurantAddProvider = StateProvider<String?>((ref) => null);
var restaurantEmailProvider = StateProvider<String?>((ref) => null);
var restaurantNameProvider = StateProvider<String?>((ref) => null);
final restaurantPhoneNumberProvider = StateProvider<int?>((ref) => 0);

class RegisterRestaurant extends ConsumerStatefulWidget {
  static const String routename = '/register-restaurant';
  const RegisterRestaurant({super.key});

  @override
  ConsumerState<RegisterRestaurant> createState() => _RegisterRestaurantState();
}

class _RegisterRestaurantState extends ConsumerState<RegisterRestaurant> {
  // var nameController = TextEditingController();
  // var emailcontroller = TextEditingController();
  // var contactController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers
    // nameController.dispose();
    // emailcontroller.dispose();
    // contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final restaurantData = ref.read(restaurantDataProvider.notifier).state;
    // final formData = ref.watch(restaurantstateProvider);
    // final formNotifier = ref.read(restaurantstateProvider.notifier);

    bool isMapPick = ref.watch(isMapPickProvider);
    var address = ref.watch(restaurantAddProvider);
    var latitude = ref.watch(restaurantLatProvider);
    var longtitude = ref.watch(restaurantLongProvider);
    // var restname = ref.watch(restaurantNameProvider);
    // var restemail = ref.watch(restaurantEmailProvider);
    // var restphoneno = ref.watch(restaurantPhoneNumberProvider);

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _form,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                toolbarHeight: 90,
                pinned: true,
                floating: true,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding:
                        const EdgeInsets.only(top: 90, left: 10, right: 10),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Image.network(
                        'https://plus.unsplash.com/premium_photo-1664298753317-179db93f8ad5?q=80&w=1539&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () =>
                      Navigator.popAndPushNamed(context, HomeScreen.routename),
                ),
                title: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 140,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        spreadRadius: 2,
                        offset: Offset(1, 1),
                        blurRadius: 5,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Text(
                      'Grow Your Buissiness',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      isMapPick
                          ? const Text('Please select restaurant location')
                          : const SizedBox(),
                      Stack(children: [
                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                'https://facts.net/wp-content/uploads/2024/01/19-google-maps-facts-1706165026.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: (MediaQuery.of(context).size.width - 230) / 2 -
                              20,
                          child: SizedBox(
                            height: 50,
                            width: 231,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyMap()),
                                );
                              },
                              child: const Text(
                                'Select restaurant location',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      RestaurantTextfield(
                        hintext: 'macdonalds, pizza hut, shinwari karahi etc',
                        title: 'Restaurant Name',
                        onvalidator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter name';
                          }
                          ref.read(restaurantNameProvider.notifier).state =
                              value;
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      RestaurantTextfield(
                        hintext: 'Pizza360@gmial.com...',
                        title: 'Email',
                        onvalidator: (value) {
                          const emailPattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$';
                          final regix = RegExp(emailPattern);
                          if (value!.isEmpty) {
                            return 'Please enter email';
                          }
                          if (!regix.hasMatch(value)) {
                            return 'Please enter a valid email format';
                          }
                          ref.read(restaurantEmailProvider.notifier).state =
                              value;

                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      RestaurantTextfield(
                        hintext: '923312355223',
                        title: 'Phone number',
                        onvalidator: (value) {
                          if (value == null) {
                            return 'Please enter contact number';
                          }
                          final temp = int.tryParse(value);
                          if (temp == null) {
                            return 'Please enter numbers only';
                          }
                          ref
                              .read(restaurantPhoneNumberProvider.notifier)
                              .state = temp;
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 60,
                        width: 250,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            side:
                                const BorderSide(width: 2, color: Colors.white),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            if (_form.currentState!.validate()) {
                              if (address != null &&
                                  latitude != null &&
                                  longtitude != null) {
                                if (mounted) {
                                  if (mounted) {
                                    ref.read(isMapPickProvider.notifier).state =
                                        false;

                                    Navigator.pushNamed(context,
                                        BusinessDetailsScreen.routename);
                                  }
                                  // print(formData.toJson());
                                  //});
                                }
                              } else {
                                if (mounted) {
                                  ref.read(isMapPickProvider.notifier).state =
                                      true;
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please pick your restaurant location')),
                                );
                              }
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
