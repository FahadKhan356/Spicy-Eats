import 'dart:io';

import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/controller/registershop_controller.dart';
import 'package:spicy_eats/Register%20shop/models/restaurant_model.dart';
import 'package:spicy_eats/commons/categoriesmodel.dart';
import 'package:spicy_eats/commons/orderModel.dart';
import 'package:spicy_eats/features/dashboard/controller/dashboardcontroller.dart';
import 'package:spicy_eats/Register%20shop/repository/registershop_repository.dart';
import 'package:spicy_eats/Register%20shop/widgets/Lists.dart';
import 'package:spicy_eats/Register%20shop/widgets/customTextfield.dart';
import 'package:spicy_eats/commons/imagepick.dart';
import 'package:spicy_eats/features/dashboard/repository/dashboardrepository.dart';
import 'package:spicy_eats/main.dart';

var cusinesProvider = StateProvider<String?>((ref) => null);
var isErrorProvider = StateProvider<bool>((ref) => false);
var dishimage = StateProvider<bool>((ref) => true);
var selectedCategoryIdProvider = StateProvider<String?>((ref) => null);
var isSearchProvider = StateProvider<bool>((ref) => false);
var categoryIdProvider = StateProvider<String?>((ref) => null);

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key});

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final actualController = TextEditingController();
  final discountController = TextEditingController();
  final categoryNameController = TextEditingController();
  final categoryDiscriptionController = TextEditingController();

  File? image;

  void pickimagefromgallery() async {
    image = await pickImageFromGallerymob(context);
    setState(() {});
  }

  List<Categories>? categoriesList = [];
  List<RestaurantModel>? restaurants = [];
  String? restid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialfetches();
    // ref.read(dashboardRepositoryProvider).fetchCategories().then((value) {
    //   if (value != null) {
    //     setState(() {
    //       categoriesList = value;
    //       print(' ye hai init state me se ${categoriesList![0].categoryid}');
    //     });
    //   }
    // });

    // ref
    //     .read(registershopcontrollerProvider)
    //     .fetchrestaurants(supabaseClient.auth.currentUser?.id)
    //     .then((value) {
    //   if (value != null) {
    //     setState(() {
    //       restaurants = value;
    //       print(' ye hai init state me se ${restaurants![0].email}');
    //     });
    //   }
    // });
  }

  Future<void> initialfetches() async {
    await ref.read(dashboardRepositoryProvider).fetchCategories().then((value) {
      if (value != null) {
        setState(() {
          categoriesList = value;
          print(' ye hai init state me se ${categoriesList![0].categoryid}');
        });
      }
    });

    await ref
        .read(registershopcontrollerProvider)
        .fetchrestaurants()
        .then((value) {
      if (value != null) {
        setState(() {
          restaurants = value;
          print(' ye hai init state me se ${restaurants![0].email}');
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    categoryNameController.dispose();
    categoryDiscriptionController.dispose();
    nameController.dispose();
    priceController.dispose();
    discountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final dashboardController = ref.read(dashboardControllerProvider);
    final isError = ref.watch(isErrorProvider);
    final GlobalKey<FormState> form = GlobalKey<FormState>();

    final isSearch = ref.watch(isSearchProvider);
    final cusinesvalue = ref.watch(cusinesProvider);
    final categoryId = ref.watch(categoryIdProvider);

    return Scaffold(
      backgroundColor: Colors.white12,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: form,
            child: Column(
              children: [
                restaurants!.length == 1
                    ? Text(restaurants![0].restaurantName.toString())
                    : DropdownButton<String?>(
                        hint: const Text('select restaurant to add dish'),
                        value: restaurants!.isNotEmpty ? restid : null,
                        menuMaxHeight: 300,
                        isExpanded: true,
                        onChanged: (value) {
                          setState(() {
                            restid = value;
                          });
                        },
                        items: restaurants!.map((restaurant) {
                          return DropdownMenuItem<String?>(
                              value: restaurant.restuid,
                              child:
                                  Text(restaurant.restaurantName.toString()));
                        }).toList(),
                      ),

                const SizedBox(
                  height: 20,
                ),
                CustomTextfield(
                  onvalidator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please name your item';
                    }
                    if (value.length < 8) {
                      return 'Item name atleast have 8 alphabets';
                    }
                    return null;
                  },
                  onchanged: (value) {},
                  controller: nameController,
                  hintext: 'california pizza, fish curry',
                  title: 'Item Name',
                ),

                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Description',
                        style: TextStyle(
                            color: Colors.black, fontSize: size.width * 0.045),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        // Check if Enter key is pressed
                        if (value.contains('\n')) {
                          // Remove Enter key press
                          descriptionController.text =
                              value.replaceAll('\n', '');
                          descriptionController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset: descriptionController.text.length),
                          );
                        }
                      },
                      // onFieldSubmitted: (value) {
                      //   // If the content is empty, do not go to the next line
                      //   if (value.trim().isEmpty) {
                      //     // Reset focus to prevent going to the next line
                      //     FocusScope.of(context).unfocus();
                      //   }
                      // },
                      maxLines:
                          null, // Allows the text field to expand vertically
                      minLines:
                          1, // Sets a minimum number of lines to make it taller initially
                      keyboardType:
                          TextInputType.multiline, // Allows for multiline input
                      textInputAction: TextInputAction.newline,
                      maxLength: 500,
                      controller: descriptionController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black)),
                          hintText: 'its the best tasty and delicious ...',
                          border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black))),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: CustomTextfield(
                              onvalidator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the price of item';
                                }
                                final dvalue = double.tryParse(value);
                                if (dvalue == null) {
                                  return 'please enter valid data';
                                }
                                return null;
                              },
                              onchanged: (value) {},
                              controller: priceController,
                              hintext: '\$10.0',
                              title: 'Price')),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        height: 210,
                        width: double.infinity,
                        child: DottedBorder(
                          color: Colors.grey,
                          strokeWidth: 3,
                          dashPattern: const [12, 8],
                          child: image != null
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          height: 100,
                                          color: Colors.blueGrey,
                                          child: Column(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    pickimagefromgallery();
                                                    setState(() {});
                                                    print('$image the image');
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
                                              image!,
                                              fit: BoxFit.cover,
                                              width: 100,
                                              height: 100,
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
                                          setState(() {});
                                          print('$image the image');
                                          // image != null
                                          //     ? ref
                                          //         .read(dishimage.notifier)
                                          //         .state = true
                                          //     : ref
                                          //         .read(dishimage.notifier)
                                          //         .state = false;
                                        },
                                        icon: const Icon(
                                          Icons.add_box,
                                          size: 100,
                                        ),
                                      ),
                                    ),
                                    const Text('Upload Dish image')
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.all(8.0),
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       color: Colors.green),
                    //   //   child: const Text(
                    //   //     'Discount offer',
                    //   //     style: TextStyle(color: Colors.white, fontSize: 18),
                    //   //   ),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cusines',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * 0.035),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          DropdownButton<String?>(
                            menuMaxHeight: 300,
                            isExpanded: true,
                            style: const TextStyle(fontSize: 15),
                            value: cusinesvalue,
                            hint: const Text('Select an option'),
                            onChanged: (String? value) {
                              ref.read(cusinesProvider.notifier).state = value;
                              print(ref.read(cusinesProvider.notifier).state =
                                  value);
                            },
                            items: cuisines.map<DropdownMenuItem<String?>>(
                                (String? value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value ?? '',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      overflow: TextOverflow
                                          .visible), // Custom text style
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Section/Category',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: size.width * 0.035),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        DropdownButton<String?>(
                          value: categoriesList?.isNotEmpty == true
                              ? selectedCategoryId
                              : null, // Set value only if there are items in the list
                          hint: const Text('Featured items...'),
                          isExpanded: true,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                          menuMaxHeight: 300,
                          onChanged: (value) {
                            // Update the selected category ID
                            ref
                                .read(selectedCategoryIdProvider.notifier)
                                .state = value;
                            ref.read(categoryIdProvider.notifier).state = value;

                            print(ref
                                .read(selectedCategoryIdProvider.notifier)
                                .state);
                          },
                          items: categoriesList?.map((category) {
                            return DropdownMenuItem<String>(
                              value: category.categoryid,
                              child: Text(
                                  category.categoryname ?? 'Unnamed Category'),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        ref.read(isSearchProvider.notifier).state = !isSearch;
                      },
                      child: Row(
                        children: [
                          Center(
                              child: Text(
                            'Or Create a new category',
                            style: TextStyle(fontSize: size.width * 0.035),
                          )),
                          const Icon(
                            Icons.arrow_drop_down,
                            size: 25,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Column(
                        children: [
                          ref.read(isSearchProvider.notifier).state == true
                              ? AnimatedSize(
                                  duration: const Duration(microseconds: 900),
                                  curve: Curves.linear,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: categoryNameController,
                                        decoration: InputDecoration(
                                            hintText:
                                                'add new category to your ',
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            // prefixIcon: const Icon(Icons.search),
                                            filled: true,
                                            fillColor: Colors.grey[200],
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none)),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller:
                                            categoryDiscriptionController,
                                        decoration: InputDecoration(
                                            hintText: 'category discription ',
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            // prefixIcon: const Icon(Icons.search),
                                            filled: true,
                                            fillColor: Colors.grey[200],
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none)),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await dashboardController.addCategory(
                                              categoryname:
                                                  categoryNameController.text,
                                              categorydiscription:
                                                  categoryDiscriptionController
                                                      .text,
                                              restUid: restid);
                                          print('Successfulu category added');
                                          await ref
                                              .read(dashboardRepositoryProvider)
                                              .fetchCategories()
                                              .then((value) {
                                            if (value != null) {
                                              setState(() {
                                                categoriesList = value;
                                                print(
                                                    ' ye hai init state me se ${categoriesList![0].categoryid}');
                                              });
                                            }
                                          });
                                          setState(() {});
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ///////////////////////////////////////////////////////
                ///
                ///
                SizedBox(
                    height: 60,
                    width: 250,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            side:
                                const BorderSide(width: 2, color: Colors.white),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          final price = int.tryParse(priceController.text) ?? 0;
                          final discount =
                              int.tryParse(discountController.text) ?? 0;

                          if (price < discount) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("failed to add")));
                            return;
                          }
                          if (form.currentState?.validate() ?? false) {
                            // if (!isError) {
                            String userId = supabaseClient.auth.currentUser!.id;
                            dashboardController.uploadDish(
                                folderName: 'Dish_Images',
                                imagePath:
                                    '/$userId/${nameController.text}/images',
                                dishName: nameController.text,
                                dishdescription: descriptionController.text,
                                dishPrice: price,
                                dishImage: image,
                                categoryId: categoryId,
                                dishcusine: cusinesvalue,
                                restUid: restid);

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("successfully added")));
                            //}
                          }
                          // ref.read(isErrorProvider.notifier).state = true;
                          if (isError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("failed to add")));
                          }
                        },
                        child: const Text(
                          'Add Dish',
                          style: TextStyle(color: Colors.white),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
