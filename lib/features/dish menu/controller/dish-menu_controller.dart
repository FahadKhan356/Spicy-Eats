import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';

var dishMenuControllerProvider = Provider((ref) => DishMenuController());

class DishMenuController {
  // if restaurand admin create Frequent bought dishes list then for showing we are fetching frequently bought dishes
  Future<List<DishData>> fetchfrequentlybought({
    required freqId,
    required WidgetRef ref,
  }) async {
    List<DishData>? freqList;
    if (freqId != null) {
      freqList = await ref.read(dishMenuRepoProvider).fetchfrequentlybuy(
            freqid: freqId!,
            ref: ref,
          );
    }
    return freqList!;
  }

//for decrease quantity for showing in ui for already in cart item or for simple item
  Future<void> decreaseItemQuantity(
    bool isCart,
    debouncer,
    // void Function(VoidCallback fn) refreshUI,
    ref,
    // {required int updatedQuantity}
  ) async {
    debugPrint("before ${ref.read(updatedQuantityProvider.notifier).state}}");
    if (isCart) {
      debouncer.run(() {
        if (ref.read(updatedQuantityProvider.notifier).state > 0) {
          ref.read(updatedQuantityProvider.notifier).state--;
        }
        // if (updatedQuantity > 0) {
        //   refreshUI(() {
        //     updatedQuantity--;
        //   });
        // }
        debugPrint("after ${ref.read(updatedQuantityProvider.notifier).state}");
      });
    } else {
      debouncer.run(() {
        if (ref.read(quantityPrvider.notifier).state > 1) {
          ref.read(quantityPrvider.notifier).state--;
        }
      });
    }
    debugPrint(
        "Dish menu Controller: quantity:${ref.watch(quantityPrvider.notifier).state} Updatequantity:${ref.read(updatedQuantityProvider.notifier).state}  ");
  }
}
