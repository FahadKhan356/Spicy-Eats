import 'package:flutter/foundation.dart';
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
    try {
      final res =
          await supabaseClient.from('users').select('*').eq('id', userid);
      if (res.isNotEmpty) {
        ref.read(userDataProvider.notifier).state =
            res.map((e) => User.fromjson(e)).toList();
        debugPrint('...userdata fetched');
      }
    } catch (e) {
      debugPrint('Failed to fetch current user data: $e');
    }
  }

  /// Loads the `users` row for [userid] into [userProvider].
  ///
  /// Social sign-ins (Google/Facebook) and magic links never inserted a row, and
  /// a missing row used to make this throw. That left [userProvider] null and
  /// crashed the home screen on `ref.read(userProvider)!.latitude!`. The row is
  /// therefore created on the fly (self-healing) and failures are logged rather
  /// than rethrown, so the rest of the home screen can still render.
  Future<void> fetchuser(String userid, WidgetRef ref) async {
    try {
      Map<String, dynamic>? res = await supabaseClient
          .from('users')
          .select('*')
          .eq('id', userid)
          .maybeSingle();

      res ??= await _createMissingUserRow(userid);

      if (res != null) {
        ref.read(userProvider.notifier).state = User.fromjson(res);
        debugPrint('...userdata fetched for $userid');
      }
    } catch (e) {
      debugPrint('Failed to fetch user data for $userid: $e');
    }
  }

  /// Creates the `users` row for a freshly authenticated user (e.g. the first
  /// Google or Facebook login) and returns it. Returns null when it still cannot
  /// be read back.
  Future<Map<String, dynamic>?> _createMissingUserRow(String userid) async {
    final authUser = supabaseClient.auth.currentUser;
    try {
      final metadata = authUser?.userMetadata;
      final fullName = (metadata?['full_name'] ?? metadata?['name'])?.toString();
      final nameParts = (fullName == null || fullName.trim().isEmpty)
          ? const <String>[]
          : fullName.trim().split(RegExp(r'\s+'));

      await supabaseClient.from('users').upsert({
        'id': userid,
        if (authUser?.email != null) 'email': authUser!.email,
        if (nameParts.isNotEmpty) 'firstname': nameParts.first,
        if (nameParts.length > 1) 'lastname': nameParts.skip(1).join(' '),
      });
      debugPrint('Created missing users row for $userid');
    } catch (e) {
      debugPrint('Could not create users row for $userid: $e');
      return null;
    }

    return supabaseClient
        .from('users')
        .select('*')
        .eq('id', userid)
        .maybeSingle();
  }

  Future<void> updatePersonalDetails(WidgetRef ref, String? firstname,
      String? lastname, String userid, String? email, String? contactno) async {
    final user = ref.watch(userProvider);
    try {
      if (firstname != user?.firstname) {
        await supabaseClient.from('users').update({
          'firstname': firstname,
        }).eq('id', userid);
      } else if (lastname != user?.lastname) {
        await supabaseClient.from('users').update({
          'lastname': lastname,
        }).eq('id', userid);
      } else if (email != user?.email) {
        await supabaseClient.from('users').update({
          'email': email,
        }).eq('id', userid);
      } else if (contactno != null && int.tryParse(contactno) != null) {
        // Never `int.parse(contactno!)` here: the field is optional and an
        // empty input used to throw instead of being ignored.
        await supabaseClient.from('users').update({
          'contactno': int.parse(contactno),
        }).eq('id', userid);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
