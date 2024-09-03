import 'package:flutter/material.dart';
import 'package:spicy_eats/Register%20shop/widgets/TimePicker.dart';

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({super.key});

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _sliderAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _sliderAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.slowMiddle),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _sliderAnimation,
      child: TimePicker(),
    );
  }
}

void showMyBottomSheet(BuildContext context) {
  showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => const MyBottomSheet());
}
