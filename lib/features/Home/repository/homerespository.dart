import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/repository/registershop_repository.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/main.dart';

var homeRepositoryController = Provider((ref) => HomeRepository());

class HomeRepository {
  Future<List<DishData>?> fetchDishes({
    required String? restuid,
    required ProviderRef ref,
  }) async {
    List<DishData>? dishList;
    try {
      List<dynamic> response = await supabaseClient
          .from('dishes')
          .select('*')
          .eq('rest_uid', restuid!);
      if (response.isEmpty) {
        print('there is no dishes');
        return null;
      }
      dishList =
          response.map((dishdata) => DishData.fromJson(dishdata)).toList();

      return dishList;
    } catch (e) {
      print('${dishList} this is dishlist');
      print('${ref.read(rest_ui_Provider)} this is rest uid in the homerepo');

      print(e.toString());
    }
  }
}
