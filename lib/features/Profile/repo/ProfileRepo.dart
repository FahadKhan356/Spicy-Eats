import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Profile/model/usermodel.dart';
import 'package:spicy_eats/main.dart';

var profileRepoProvider = Provider((ref) => ProfileRepo());
var userDataProvider = StateProvider<List<User>?>((ref) => []);
var userProvider = StateProvider<User?>((ref) => null);

class ProfileRepo {
  Future<void> fetchCurrentUserData(
      {required userid, required WidgetRef ref}) async {
    final res = await supabaseClient.from('users').select('*').eq('id', userid);
    if (res.isNotEmpty) {
      ref.read(userDataProvider.notifier).state =
          res.map((e) => User.fromjson(e)).toList();
      print('...userdata fetched');
    }
  }

  Future<void> fetchuser(String userid, WidgetRef ref) async {
    try {
      final res = await supabaseClient
          .from('users')
          .select('*')
          .eq('id', userid)
          .single();
      if (res.isNotEmpty) {
        ref.read(userProvider.notifier).state = User.fromjson(res);
        print('...userdata fetched11');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
