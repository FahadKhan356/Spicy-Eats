import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/commons/categoriesmodel.dart';
import 'package:spicy_eats/features/Home/repository/homerespository.dart';
import 'package:spicy_eats/features/Sqlight%20Database/Dishes/services/DishesLocalDataBase.dart';


import '../../Restaurant_Menu/model/dish.dart';

var homeControllerProvider = Provider((ref) {
  final homerepo = ref.read(homeRepositoryController);
  return HomeController(
      homeRepository: homerepo,
      ref: ref,
      database: DishesLocalDatabase.instance);
});

class HomeController {
  final DishesLocalDatabase database;
  HomeRepository homeRepository;
  final ProviderRef ref;
  HomeController(
      {required this.homeRepository,
      required this.ref,
      required this.database});

  Future<List<DishData>?> fetchDishes({required String? restuid}) {
    return homeRepository.fetchDishes(restuid: restuid, ref: ref);
  }

  Future<List<Categories>?> fetchCategories({required String restuid}) {
    return homeRepository.fetchcategorieslist(restuid: restuid);
  }

  Future<List<DishData>> getDishesData(String restaurantUid) async {
    final data = await database.getDishes(restaurantUid);
    return data!;
  }
}
