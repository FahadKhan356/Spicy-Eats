import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Profile/repo/ProfileRepo.dart';
import 'package:spicy_eats/features/Profile/screen/ProfileScreen.dart';

class EditScreen extends ConsumerStatefulWidget {
  static const String routname = '/Edit-Screen';
  final String editType;

  EditScreen({super.key, required this.editType});

  @override
  ConsumerState<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends ConsumerState<EditScreen> {
  bool isloader = false;
  final firstnamecontroller = TextEditingController();

  final lastnamecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final contactnocontroller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    firstnamecontroller.dispose();
    lastnamecontroller.dispose();
    emailcontroller.dispose();
    contactnocontroller.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstnamecontroller.text = ref.read(userProvider)!.firstname!;
    lastnamecontroller.text = ref.read(userProvider)!.lastname!;
    emailcontroller.text = ref.read(userProvider)!.email!;
    contactnocontroller.text = ref.read(userProvider)!.contactno.toString();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        // leading: TextButton(
        //   onPressed: () => Navigator.pop(context),
        //   child: const Text(
        //     'X',
        //     style: TextStyle(fontSize: 15, color: Colors.black),
        //   ),
        // ),
        centerTitle: true,
        title: Text(
          widget.editType,
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: isloader
          ? const Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.black12,
              color: Colors.black,
            ))
          : Column(
              children: [
                widget.editType == 'Name'
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: firstnamecontroller,
                              decoration: InputDecoration(
                                suffixIcon: TextButton(
                                  child: const Text('x'),
                                  onPressed: () {
                                    firstnamecontroller.text = '';
                                  },
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                label: const Text('First name'),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: lastnamecontroller,
                              decoration: InputDecoration(
                                suffixIcon: TextButton(
                                  child: const Text('x'),
                                  onPressed: () {
                                    lastnamecontroller.text = '';
                                  },
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                label: const Text('Last name'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      )
                    : widget.editType == 'Email'
                        ? TextFormField(
                            controller: emailcontroller,
                            decoration: InputDecoration(
                              suffixIcon: TextButton(
                                child: const Text('x'),
                                onPressed: () {
                                  emailcontroller.text = '';
                                },
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              label: const Text('Email'),
                            ),
                          )
                        : widget.editType == 'Contactnumber'
                            ? TextFormField(
                                controller: contactnocontroller,
                                decoration: InputDecoration(
                                  suffixIcon: TextButton(
                                    child: const Text('x'),
                                    onPressed: () {
                                      contactnocontroller.text = '';
                                    },
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10)),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  label: const Text('Mobile number'),
                                ),
                              )
                            : const SizedBox(),
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          if (firstnamecontroller.text.isNotEmpty &&
                              lastnamecontroller.text.isNotEmpty) {
                            setState(() {
                              isloader = true;
                            });
                            ref.read(profileRepoProvider).updatePersonalDetails(
                                  // firstnamecontroller.text != user!.firstname
                                  //     ? firstnamecontroller.text
                                  //     : null,
                                  // lastnamecontroller.text != user.lastname
                                  //     ? lastnamecontroller.text
                                  //     : null,
                                  // ref.read(userProvider)!.id!,
                                  // emailcontroller.text != user.email
                                  //     ? emailcontroller.text
                                  //     : null,
                                  // contactnocontroller.text !=
                                  //         user.contactno.toString()
                                  //     ? (contactnocontroller.text as num)
                                  //         .toInt()
                                  //     : null,
                                  ref,
                                  firstnamecontroller.text,
                                  lastnamecontroller.text,
                                  ref.read(userProvider)!.id!,
                                  emailcontroller.text,
                                  contactnocontroller.text,
                                );

                            ref
                                .read(profileRepoProvider)
                                .fetchuser(ref.read(userProvider)!.id!, ref);

                            Navigator.pushNamed(
                                context, ProfileScreen.routename);
                            setState(() {
                              isloader = false;
                            });

                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    margin: EdgeInsets.symmetric(vertical: 100),
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      'Successfully updated',
                                    )));
                          }
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ),
                )
              ],
            ),
    );
  }
}
