import 'package:flutter/material.dart';
import 'package:spicy_eats/commons/Responsive.dart';

class AnimatedNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const AnimatedNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<AnimatedNavBar> createState() => _AnimatedNavBarState();
}

class _AnimatedNavBarState extends State<AnimatedNavBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // <- keeps it above system navigation
      child: Container(
        width: Responsive.w280px,//280,
        height: Responsive.w50px + Responsive.w10px,//60, // ✅ fixed height like normal nav bar
        // margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(Responsive.w30px),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavItem(index: 0, icon: Icons.explore, label: "Explore"),
            _buildNavItem(index: 1, icon: Icons.favorite, label: "Favorites"),
            _buildNavItem(
                index: 2, icon: Icons.shopping_bag_outlined, label: "Cart"),
            _buildNavItem(
                index: 3, icon: Icons.person_2_outlined, label: "Profile"),
          ],
        ),
      ),
    );
  }



  Widget _buildNavItem(
      {required int index, required IconData icon, required String label}) {
    final bool isSelected = widget.selectedIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(Responsive.w30px),
      onTap: () => widget.onItemTapped(index),
      child: AnimatedContainer(
        width: isSelected ? Responsive.w120px : Responsive.w50px,
        height: Responsive.w50px,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(Responsive.w25px),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.orange,
              size: Responsive.w22px,
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => SizeTransition(
                  sizeFactor: anim, axis: Axis.horizontal, child: child),
              child: isSelected
                  ? Padding(
                      padding:  EdgeInsets.only(left: Responsive.w6px),
                      key: ValueKey(label),
                      child: Center(
                        child: Text(
                          label,
                          style:  TextStyle(
                            fontSize: Responsive.w14px,
                        
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

}



// class NavItem extends StatelessWidget {
//   final isSelected;
//   final IconData icon;
//   final String label;
//    NavItem({super.key,required this.isSelected,required this.label,required this.icon,});

//   @override
//   Widget build(BuildContext context) {
    
//     return InkWell(
//       borderRadius: BorderRadius.circular(30),
//       onTap: () => widget.onItemTapped(index),
//       child: AnimatedContainer(
//         width: isSelected ? 120 : 50,
//         height: 50,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOutCubic,
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.orange : Colors.white,
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? Colors.white : Colors.orange,
//               size: 22,
//             ),
//             AnimatedSwitcher(
//               duration: const Duration(milliseconds: 300),
//               transitionBuilder: (child, anim) => SizeTransition(
//                   sizeFactor: anim, axis: Axis.horizontal, child: child),
//               child: isSelected
//                   ? Padding(
//                       padding: const EdgeInsets.only(left: 6),
//                       key: ValueKey(label),
//                       child: Text(
//                         label,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     )
//                   : const SizedBox.shrink(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }