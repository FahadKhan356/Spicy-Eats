import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/commons/orderModel.dart';
import 'package:spicy_eats/features/Profile/commons/CommonContainer.dart';
import 'package:spicy_eats/features/Profile/commons/EditScreen.dart';
import 'package:spicy_eats/features/Profile/repo/ProfileRepo.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  static const String routename = '/Profile-screen';
  ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'X',
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Personal details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 20,
              ),
              commonContainer(
                  title: 'Name',
                  titlename: '${user!.firstname!}${user.lastname}',
                  onpressed: () => Navigator.pushNamed(
                      context, EditScreen.routname,
                      arguments: 'Name')),
              const SizedBox(
                height: 20,
              ),
              commonContainer(
                  title: 'Email',
                  titlename: user.email!,
                  onpressed: () => Navigator.pushNamed(
                      context, EditScreen.routname,
                      arguments: 'Email')),
              const SizedBox(
                height: 20,
              ),
              commonContainer(
                  title: 'Mobile number',
                  titlename: user.contactno.toString(),
                  onpressed: () => Navigator.pushNamed(
                      context, EditScreen.routname,
                      arguments: 'Contactnumber')),
            ],
          ),
        ),
      ),
    );
  }
}
