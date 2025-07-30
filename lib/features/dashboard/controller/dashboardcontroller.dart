import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/dashboard/repository/dashboardrepository.dart';

var dashboardControllerProvider = Provider((ref) {
  final dashboardrepo = ref.watch(dashboardRepositoryProvider);
  return DashBoardController(dashBoardRepository: dashboardrepo, ref: ref);
});

class DashBoardController {
  final DashBoardRepository dashBoardRepository;
  final ProviderRef ref;

  DashBoardController({required this.dashBoardRepository, required this.ref});

  Future<void> uploadDish({
    required String? folderName,
    required String? imagePath,
    required String? dishName,
    required String? dishdescription,
    required int? dishPrice,
    required File? dishImage,
    required String? dishcusine,
    required String? restUid,
    required String? categoryId,
  }) async {
    try {
      dashBoardRepository.uploadDish(
          folderName: folderName,
          imagePath: imagePath,
          dishName: dishName,
          dishdescription: dishdescription,
          dishPrice: dishPrice,
          dishImage: dishImage,
          dishcusine: dishcusine,
          restUid: restUid,
          categoryId: categoryId);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addCategory({
    required String? categoryname,
    required String? categorydiscription,
    required String? restUid,
  }) async {
    try {
      dashBoardRepository.addCategory(
          categoryname: categoryname,
          categorydiscription: categorydiscription,
          restUid: restUid);
    } catch (e) {
      throw Exception(e);
    }
  }

  // Future<List<Categories>?> fetchCategories() async {
  //   return dashBoardRepository.fetchCategories();
}
