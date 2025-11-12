import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Profile/model/usermodel.dart';
import 'package:spicy_eats/main.dart';

var profileRepoProvider = Provider((ref) => ProfileRepo());
var userDataProvider = StateProvider<List<User>?>((ref) => []);
var userProvider = StateProvider<User?>((ref) => null);

class ProfileRepo {
  Future<void> fetchCurrentUserData(
      {required userid, required WidgetRef ref}) async {
    if (userid == null) return;
    final res = await supabaseClient.from('users').select('*').eq('id', userid);
    if (res.isNotEmpty) {
      ref.read(userDataProvider.notifier).state =
          res.map((e) => User.fromjson(e)).toList();
      print('...userdata fetched r');
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

  Future<void> updatePersonalDetails(WidgetRef ref, String? firstname,
      String? lastname, String userid, String? email, String? contactno) async {
    final user = ref.watch(userProvider);
    try {
      if (firstname != user!.firstname) {
        await supabaseClient.from('users').update({
          'firstname': firstname,
        }).eq('id', userid);
      } else if (lastname != user.lastname) {
        await supabaseClient.from('users').update({
          'lastname': lastname,
        }).eq('id', userid);
      } else if (email != user.email) {
        await supabaseClient.from('users').update({
          'email': email,
        }).eq('id', userid);
      } else {
        await supabaseClient.from('users').update({
          'contactno': int.parse(contactno!),
        }).eq('id', userid);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
