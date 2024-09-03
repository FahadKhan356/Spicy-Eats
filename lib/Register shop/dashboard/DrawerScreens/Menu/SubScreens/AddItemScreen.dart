import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/widgets/Lists.dart';
import 'package:spicy_eats/Register%20shop/widgets/customTextfield.dart';

var scheduledMealProvider = StateProvider<String?>((ref) => null);
var cusinesProvider = StateProvider<String?>((ref) => null);
var discountProvider = StateProvider<double>((ref) => 0);
var actualProvider = StateProvider<double>((ref) => 0);
var finaldiscountProvider = StateProvider<String>((ref) => '');
var isErrorProvider = StateProvider<bool>((ref) => false);

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
    final finaldiscount = ref.watch(finaldiscountProvider);
    final isError = ref.watch(isErrorProvider);
    final GlobalKey<FormState> _form = GlobalKey<FormState>();

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
      try {
        final actualprice = double.tryParse(priceController.text) ?? 0;
        final discountprice = double.tryParse(discountController.text) ?? 0;
        if (actualprice == 0) {
          ref.read(isErrorProvider.notifier).state = false;

          ref.read(finaldiscountProvider.notifier).state = '0%';
          return;
        }
        if (actualprice < discountprice) {
          ref.read(isErrorProvider.notifier).state = true;
          return;
        }
        final finaldiscount =
            ((actualprice - discountprice) / actualprice) * 100;

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
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            //'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                            'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                            width: 180,
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15))),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt_sharp,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            )),
                      ],
                    )
                  ],
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
                              .map<DropdownMenuItem<String?>>((String? value) {
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
                            ref.read(cusinesProvider.notifier).state = value;
                            print(ref.read(cusinesProvider.notifier).state =
                                value);
                          },
                          items: cuisines
                              .map<DropdownMenuItem<String?>>((String? value) {
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
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green),
                      child: const Text(
                        'Discount offer',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
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
                        hintext: '100-90 = 10% discount',
                        title: 'Discounted Price'),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isError ? Colors.red : Colors.green),
                      child: Text(
                        isError
                            ? 'Actual Price can not be smaller than discount'
                            : 'Discount is $finaldiscount % off',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!_form.currentState!.validate()) {
                          validactualprice(discountController.text,
                              'empty value', 'ony number type allowed');
                          return;
                        }
                        ref.read(isErrorProvider.notifier).state = false;
                        updateDiscountforactualprice();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green),
                        child: const Text(
                          'see discount',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
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
