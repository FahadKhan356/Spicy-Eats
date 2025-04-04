import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Profile/repo/ProfileRepo.dart';
import 'package:spicy_eats/features/Profile/screen/ProfileScreen.dart';
import 'package:spicy_eats/features/account/commons/RowContainer.dart';

class AccountScreen extends ConsumerStatefulWidget {
  static const String routename = '/Account-screen';
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Account',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, ProfileScreen.routename),
                  child: Container(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user!.firstname}${user.lastname}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        Text(
                          'view profile',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  rowContainer(
                      icon: Icons.menu_book, onpressed: () {}, title: 'Orders'),
                  rowContainer(
                      icon: Icons.favorite_border,
                      onpressed: () {},
                      title: 'Favourites'),
                  rowContainer(
                      icon: Icons.location_on_outlined,
                      onpressed: () {},
                      title: 'Addresses'),
                ],
              ),
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
                      onPressed: () {},
                      child: const Text(
                        'Log out',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
