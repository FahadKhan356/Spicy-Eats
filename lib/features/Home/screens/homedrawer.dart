import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/register_restaurant.dart';
import 'package:spicy_eats/features/Home/screens/widgets/customdraweritem.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          padding: const EdgeInsets.all(10),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.521),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(1, 1),
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
              topLeft: Radius.circular(0),
              bottomLeft: Radius.circular(0),
            ),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, RegisterRestaurant.routename),
                child: CustomDrawerItem(
                    leadingname: 'Become a partner',
                    icon: Icons.food_bank_rounded),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomDrawerItem(
                  leadingname: 'Your restaurant', icon: Icons.settings),
              const Spacer(),
              CustomDrawerItem(leadingname: 'Settings', icon: Icons.settings),
            ],
          ),
        ),
      ),
    );
  }
}
