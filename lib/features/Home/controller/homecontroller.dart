import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Home/repository/homerespository.dart';

import '../../../SyncTabBar/categoriesmodel.dart';
import '../../Restaurant_Menu/model/dish.dart';

var homeControllerProvider = Provider((ref) {
  final homerepo = ref.read(homeRepositoryController);
  return HomeController(homeRepository: homerepo, ref: ref);
});

class HomeController {
  HomeRepository homeRepository;
  final ProviderRef ref;
  HomeController({required this.homeRepository, required this.ref});

  Future<List<DishData>?> fetchDishes({required String? restuid}) {
    return homeRepository.fetchDishes(restuid: restuid, ref: ref);
  }

  Future<List<Categories>?> fetchCategories({required String restuid}) {
    return homeRepository.fetchcategorieslist(restuid: restuid);
  }
}
