import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/controller/registershop_controller.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/businessInformation.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/paymentmethodescreen.dart';
import 'package:spicy_eats/Register%20shop/widgets/restauarantTextfield.dart';
import 'package:spicy_eats/commons/imagepick.dart';
import 'package:spicy_eats/main.dart';

var nicNumberProvider = StateProvider<int?>((ref) => null);
var nicNumberFirstNameProvider = StateProvider<String?>((ref) => null);
var nicNumberLastNameProvider = StateProvider<String?>((ref) => null);

var isimage = StateProvider<bool>((ref) => true);

class LegalInformationScreen extends ConsumerStatefulWidget {
  static const String routename = '/LegalStffScreen';

  const LegalInformationScreen({super.key});

  @override
  ConsumerState<LegalInformationScreen> createState() =>
      _LegalInformationScreenState();
}

class _LegalInformationScreenState
    extends ConsumerState<LegalInformationScreen> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  File? idImage;
  void pickimagefromgallery() async {
    idImage = await imagePicker(context);
    setState(() {});
    print('this is id image $idImage');
  }

  @override
  Widget build(BuildContext context) {
    final restImg = ref.read(restImageFileProvider);
    final isImageSelected = ref.watch(isimage);
    final registerShopController = ref.watch(registershopcontrollerProvider);
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _form,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                toolbarHeight: 70,
                floating: true,
                pinned: true,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding:
                        const EdgeInsets.only(top: 80, left: 10, right: 10),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: Image.network(
                        'https://img.freepik.com/free-photo/customer-making-payment-through-payment-terminal-counter_1170-645.jpg?t=st=1723985433~exp=1723989033~hmac=54408b88b25d7342b2892309b6d148b405a5d4ead797a8221ee445f182c0a92f&w=740',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 250,
                      ),
                    ),
                  ),
                ),
                title: Center(
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 140,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black38,
                            spreadRadius: 2,
                            offset: Offset(
                              1,
                              1,
                            ),
                            blurRadius: 5)
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: const Center(child: Text('Legat Stuff')),
                  ),
                ),
                leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back)),
              ),
              SliverToBoxAdapter(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    RestaurantTextfield(
                        hintext: '41302-2312345',
                        title: 'Identity Card/Nic Number',
                        onvalidator: (value) {
                          final nicno = int.tryParse(value ?? '');
                          if (nicno == null) {
                            return 'Please enter numbers';
                          }
                          ref.read(nicNumberProvider.notifier).state = nicno;
                          return null;
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    RestaurantTextfield(
                        hintext: 'Mohammad, Alex...',
                        title: 'Nic First Name ',
                        onvalidator: (value) {
                          if (value!.isEmpty) {
                            return 'please fill the field';
                          }
                          ref.read(nicNumberFirstNameProvider.notifier).state =
                              value;
                          return null;
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    RestaurantTextfield(
                        hintext: 'Nic Last Name',
                        title: 'Nic Last Name',
                        onvalidator: (value) {
                          ref.read(nicNumberLastNameProvider.notifier).state =
                              value;
                          return null;
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: 210,
                      width: double.infinity,
                      child: DottedBorder(
                        color: Colors.grey,
                        strokeWidth: 3,
                        dashPattern: const [12, 8],
                        child: idImage != null
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        height: 100,
                                        color: Colors.blueGrey,
                                        child: Column(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  pickimagefromgallery();
                                                  idImage != null
                                                      ? ref
                                                          .read(
                                                              isimage.notifier)
                                                          .state = true
                                                      : ref
                                                          .read(
                                                              isimage.notifier)
                                                          .state = false;
                                                },
                                                icon: const Icon(
                                                  Icons.upload,
                                                  size: 40,
                                                  color: Colors.white,
                                                )),
                                            const Text(
                                              'upload again',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black26,
                                                offset: Offset(1, 3),
                                                spreadRadius: 2,
                                                blurRadius: 2,
                                              )
                                            ]),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.file(
                                            idImage!,
                                            fit: BoxFit.cover,
                                            width: 200,
                                            height: 200,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: IconButton(
                                      onPressed: () {
                                        pickimagefromgallery();
                                        idImage != null
                                            ? ref.read(isimage.notifier).state =
                                                true
                                            : ref.read(isimage.notifier).state =
                                                false;
                                      },
                                      icon: const Icon(
                                        Icons.camera_front_rounded,
                                        size: 100,
                                      ),
                                    ),
                                  ),
                                  const Text('Upload Identity Card Photo')
                                ],
                              ),
                      ),
                    ),
                    isImageSelected == false
                        ? const Text(
                            'upload image please',
                            style: TextStyle(color: Colors.red),
                          )
                        : const SizedBox(),
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
                            onPressed: () async {
                              if (_form.currentState!.validate()
                                  //&& image != null
                                  ) {
                                String userId =
                                    supabaseClient.auth.currentUser!.id;
                                registerShopController.uploadRestaurantData(
                                  restImage: restImg,
                                  folderName: 'Restaurant_Registeration',
                                  restImagePath: '/$userId/Restaurant_covers',
                                  restownerIDImageFolderName:
                                      'Restaurant_Registeration',
                                  restIdImage: idImage,
                                  idImagePath: '/$userId/Restaurant_ownerIds',
                                );
                                Navigator.pushNamed(
                                  context,
                                  PaymentMethodScreen.routename,
                                );
                              }
                            },
                            child: const Text(
                              'Next',
                              style: TextStyle(color: Colors.white),
                            )))
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
