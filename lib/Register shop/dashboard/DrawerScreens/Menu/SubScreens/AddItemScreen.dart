import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/widgets/Lists.dart';
import 'package:spicy_eats/Register%20shop/widgets/customTextfield.dart';
import 'package:spicy_eats/commons/imagepick.dart';

var scheduledMealProvider = StateProvider<String?>((ref) => null);
var cusinesProvider = StateProvider<String?>((ref) => null);
var discountProvider = StateProvider<double>((ref) => 0);
var actualProvider = StateProvider<double>((ref) => 0);
var finaldiscountProvider = StateProvider<String>((ref) => '');
var isErrorProvider = StateProvider<bool>((ref) => false);
var msgError = StateProvider((ref) => '');
var isimage = StateProvider<bool>((ref) => true);

class AddItemScreen extends ConsumerStatefulWidget {
  AddItemScreen({super.key});

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final actualController = TextEditingController();
  final discountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    File? image;
    final finaldiscount = ref.watch(finaldiscountProvider);
    final isError = ref.watch(isErrorProvider);
    final GlobalKey<FormState> _form = GlobalKey<FormState>();
    String msg = ref.watch(msgError);
    bool redError = false;

    pickimagefromgallery() async {
      image = await imagePicker(context);
    }

    String? validactualprice(
        String? value, String? firstmsg, String? secondmsg) {
      if (value == null || value.isEmpty) {
        return firstmsg;
      }
      final doublevalue = double.tryParse(value);
      if (doublevalue == null) {
        return secondmsg;
      }
      return null;
    }

    String? validdiscount(String? value, String? firstmsg, String? secondmsg) {
      if (value == null || value.isEmpty) {
        return firstmsg;
      }
      final doublevalue = double.tryParse(value);
      if (doublevalue == null) {
        return secondmsg;
      }
      return null;
    }

    void updateDiscountforactualprice() {
      final actualprice = double.tryParse(priceController.text) ?? 90;
      final discountprice = double.tryParse(discountController.text) ?? 0;
      try {
        if (actualprice == 0) {
          ref.read(isErrorProvider.notifier).state = true;
          ref.read(msgError.notifier).state = 'actual price can not be 0 value';

          ref.read(finaldiscountProvider.notifier).state = '0%';
          return;
        }
        if (discountprice <= 0) {
          ref.read(isErrorProvider.notifier).state = true;
          ref.read(msgError.notifier).state =
              'discount can not be 0% or lesser';

          // ref.read(isErrorProvider.notifier).state = true;
          return;
        }
        if (discountprice >= 100) {
          ref.read(isErrorProvider.notifier).state = true;
          ref.read(msgError.notifier).state =
              'discount can not be 100% or more';

          // ref.read(isErrorProvider.notifier).state = true;
          return;
        }

        final finaldiscount =
            (actualprice - (actualprice * discountprice / 100));

        ref.read(finaldiscountProvider.notifier).state =
            finaldiscount.toStringAsFixed(0);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    final scheduledmealvalue = ref.watch(scheduledMealProvider);
    final cusinesvalue = ref.watch(cusinesProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _form,
            child: Column(
              children: [
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
                    title: 'Item Name'),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description',
                      style: TextStyle(fontSize: 20, color: Colors.black),
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
                      maxLength: 100,
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.black)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.black)),
                          hintText: 'its the best tasty and delicious ...',
                          border: OutlineInputBorder(
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
                                          padding: EdgeInsets.all(10),
                                          height: 100,
                                          color: Colors.blueGrey,
                                          child: Column(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    pickimagefromgallery();
                                                    image != null
                                                        ? ref
                                                            .read(isimage
                                                                .notifier)
                                                            .state = true
                                                        : ref
                                                            .read(isimage
                                                                .notifier)
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
                                              image!,
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
                                          image != null
                                              ? ref
                                                  .read(isimage.notifier)
                                                  .state = true
                                              : ref
                                                  .read(isimage.notifier)
                                                  .state = false;
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
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextfield(
                        controller: discountController,
                        onvalidator: (value) {
                          return validdiscount(
                              value,
                              'Enter given item discount',
                              'Please enter numbers only');
                        },
                        onchanged: (value) {},
                        hintext:
                            '10% discount i.e: price-percentage=Discount  ',
                        title: 'Enter Discounted Percentage(Optional)'),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isError
                                //priceController.text == '0' ||
                                //         discountController.text == '0' ||
                                //         discountController.text == '100'
                                ? Colors.red
                                : Colors.black87,
                          ),
                          child: Text(
                            // priceController.text == '0'
                            //     ? 'Actual Price can not be Zero'
                            //     : discountController.text == '0'
                            //         ? 'discount can not be Zero or less'
                            //         : discountController.text == '100'
                            //             ? 'discount can not be 100% or more'
                            isError
                                ? msg
                                : 'New DiscountedPrice  ${ref.watch(finaldiscountProvider)}/-',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // if (!_form.currentState!.validate()) {
                            //   validactualprice(discountController.text,
                            //       'empty value', 'only number type allowed');
                            //   return;
                            // }
                            ref.read(isErrorProvider.notifier).state = false;
                            setState(() {
                              updateDiscountforactualprice();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green),
                            child: const Text(
                              'see discount',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          const Text(
                            'Scheduled Meal (Optional)',
                            style: TextStyle(color: Colors.black38),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: DropdownButton<String?>(
                              isExpanded: true,
                              style: const TextStyle(fontSize: 15),
                              value: scheduledmealvalue,
                              hint: const Text('Select an option'),
                              onChanged: (String? value) {
                                ref.read(scheduledMealProvider.notifier).state =
                                    value;
                                // var set;
                                // setState(() {
                                //   set = value;
                                // });
                                print(
                                    'ne value   ${ref.read(scheduledMealProvider.notifier).state}');
                              },
                              items: scheduledmeal
                                  .map<DropdownMenuItem<String?>>(
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
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          const Text(
                            'Cusines',
                            style: TextStyle(color: Colors.black38),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: DropdownButton<String?>(
                              menuMaxHeight: 300,
                              isExpanded: true,
                              style: const TextStyle(fontSize: 15),
                              value: cusinesvalue,
                              hint: const Text('Select an option'),
                              onChanged: (String? value) {
                                ref.read(cusinesProvider.notifier).state =
                                    value;
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      final price = double.tryParse(priceController.text) ?? 0;
                      final discount =
                          double.tryParse(discountController.text) ?? 0;

                      if (price < discount) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("failed to add")));
                        return;
                      }
                      if (_form.currentState?.validate() ?? false) {
                        if (!isError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("successfully added")));
                        }
                      }
                      // ref.read(isErrorProvider.notifier).state = true;
                      if (isError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("failed to add")));
                      }
                    },
                    child: const Text('Add')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
