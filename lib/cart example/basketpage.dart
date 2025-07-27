import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimatedAddButton extends StatefulWidget {
  @override
  _AnimatedAddButtonState createState() => _AnimatedAddButtonState();
}

class _AnimatedAddButtonState extends State<AnimatedAddButton> {
  bool isExpanded = false;
  int quantity = 0;
  Timer? _collapseTimer;

  void _startCollapseTimer() {
    _collapseTimer?.cancel();
    _collapseTimer = Timer(Duration(seconds: 2), () {
      setState(() {
        isExpanded = false;
      });
    });
  }

  void _increaseQuantity() {
    setState(() {
      quantity++;
      _startCollapseTimer();
    });
  }

  void _decreaseQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
        _startCollapseTimer();
      } else {
        quantity = 0;
        isExpanded = false;
      }
    });
  }

  void _expandButton() {
    setState(() {
      isExpanded = true;
      if (quantity == 0) quantity = 1;
      _startCollapseTimer();
    });
  }

  @override
  void dispose() {
    _collapseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: isExpanded ? 160 : 80, // Flexible width
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: isExpanded
            ? FittedBox(
                // Prevents overflow by adjusting to available space
                child: Row(
                  children: [
                    _buildIconButton(Icons.remove, _decreaseQuantity),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                        child: Text(
                          '$quantity',
                          key: ValueKey<int>(quantity),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    _buildIconButton(Icons.add, _increaseQuantity),
                  ],
                ),
              )
            : TextButton(
                onPressed: _expandButton,
                child: Text(
                  quantity == 0 ? "Add" : "$quantity",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 4), // Adds spacing between buttons
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
        ),
        child: IconButton(
          padding: EdgeInsets.zero, // Removes default padding
          constraints: BoxConstraints.tightFor(width: 32, height: 32),
          icon: Icon(icon, color: Colors.white, size: 10),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

// class CustomAnimatedButton extends ConsumerStatefulWidget {
//   const CustomAnimatedButton({super.key,required this.dishid,});
//   final dishid;


//   @override
//   ConsumerState<CustomAnimatedButton> createState() => _CustomAnimatedButtonState();
// }

// class _CustomAnimatedButtonState extends ConsumerState<CustomAnimatedButton> {
//   bool isExpanded=false;
//   Timer? _timerCollapse;


//   void expandbutton(){
//    setState(() {
//      isExpanded=true;
//    startcollapseTimer();
//    });
//   }


//   void startcollapseTimer() {
//     _timerCollapse!.cancel();
//     _timerCollapse=Timer(const Duration(seconds: 2), () { 
//       setState(() {
//         isExpanded=false;
//       });
//     });
//   }


//   @override
//   void dispose() {
//     // TODO: implement dispose
//    _timerCollapse!.cancel();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {

 


//     return AnimatedContainer(
//       duration: const Duration(seconds: 2),
//       color: Colors.black,
//       child: isExpanded? FittedBox(
//         child: Row(
//           children: [
//             iconButton(Icons.add, ref.read(DummyLogicProvider).increaseQuantity(ref, dishId, price)),
//        AnimatedSwitcher(duration: const Duration(milliseconds: 300),
//        transitionBuilder: (child, animation) => ScaleTransition(scale: animation,child: child,),
//        child: Text( quantity,key: ValueKey<int>(quantity),style: TextStyle(fontSize: 16,),),
//        )
//           iconButton(Icons.remove, ref.read(DummyLogicProvider).decreaseQuantity(ref, dishId, price))
//           ],
//         ),
//       ):
//       TextButton(onPressed:(){}, child: child),
//     );
//   }
  

// }

// Widget iconButton(IconData icon,onpress) {
//   return IconButton(onPressed: onpress, icon: Icon(icon,color: Colors.white,size: 20,),);
// }
