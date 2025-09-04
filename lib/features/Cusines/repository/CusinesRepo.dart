import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Cusines/model/CusinesModel.dart';
import 'package:spicy_eats/main.dart';

final cusinesRepo = Provider((ref) => Cusinesrepo());

class Cusinesrepo {
  Future<List<CusinesModel>?> fetchCusines() async {
    List<CusinesModel>? allcusines;
    try {
      debugPrint("Fetching cuisines from Supabase...");
      final res = await supabaseClient.from('cusines').select('*');
      debugPrint("Supabase response: ${res.length} items");

      if (res.isNotEmpty) {
        allcusines = res.map((e) => CusinesModel.fromJson(e)).toList();
        debugPrint("Parsed ${allcusines.length} cuisines");
      } else {
        debugPrint("No cuisines found in database");
      }
      return allcusines;
    } catch (e) {
      debugPrint("Failed Cusines Fetch : $e");
    }
    return [];
  }
}
