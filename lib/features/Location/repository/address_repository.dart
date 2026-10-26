import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Home/model/AddressModel.dart';
import 'package:spicy_eats/features/Sqlight%20Database/onBoarding/services/OnBoardingLocalDatabase.dart';
import 'package:spicy_eats/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepository(supabase: supabaseClient);
});

class AddressRepository {
  final SupabaseClient supabase;

  AddressRepository({required this.supabase});

  /// Fetches all saved addresses for a given user.
  Future<List<AddressModel>> fetchAllAddresses(String userId) async {
    try {
      if (userId.isEmpty) return [];

      final response = await supabase
          .from('user_address')
          .select('*')
          .eq('userId', userId)
          .order('id', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      return data
          .map((item) => AddressModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching addresses: $e');
      return [];
    }
  }

  /// Inserts a new address and returns the created AddressModel with its generated ID.
  Future<AddressModel?> addAddress(AddressModel address) async {
    try {
      final insertData = {
        'userId': address.userId,
        'address': address.address ?? '',
        'streetNumber': address.streetNumber ?? '',
        'floor': address.floor ?? '',
        'label': address.label ?? 'Home',
        'othersDetails': address.othersDetails ?? '',
        'lat': address.lat,
        'long': address.long,
      };

      final response = await supabase
          .from('user_address')
          .insert(insertData)
          .select()
          .single();

      return AddressModel.fromJson(response);
    } catch (e) {
      debugPrint('Error adding address: $e');
      return null;
    }
  }

  /// Updates an existing address in user_address.
  Future<bool> updateAddress(AddressModel address) async {
    try {
      if (address.id == null) return false;

      await supabase.from('user_address').update({
        'address': address.address ?? '',
        'streetNumber': address.streetNumber ?? '',
        'floor': address.floor ?? '',
        'label': address.label ?? '',
        'othersDetails': address.othersDetails ?? '',
        'lat': address.lat,
        'long': address.long,
      }).eq('id', address.id!);

      return true;
    } catch (e) {
      debugPrint('Error updating address: $e');
      return false;
    }
  }

  /// Deletes an address. Handles FK reference in users table if needed.
  Future<bool> deleteAddress(int addressId) async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId != null) {
        try {
          await supabase
              .from('users')
              .update({'address_id': null})
              .eq('id', currentUserId)
              .eq('address_id', addressId);
        } catch (_) {}
      }

      await supabase.from('user_address').delete().eq('id', addressId);
      return true;
    } catch (e) {
      debugPrint('Error deleting address: $e');
      return false;
    }
  }

  /// Sets the active delivery address for the current session and in database.
  Future<bool> setDefaultAddress(AddressModel address) async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId != null && address.id != null) {
        try {
          await supabase.from('users').update({
            'address_id': address.id,
            'address': address.address,
            'latitude': address.lat,
            'longitude': address.long,
          }).eq('id', currentUserId);
        } catch (e) {
          debugPrint('Skipping user profile update: $e');
        }
      }

      // Persist in local storage for fast cold boots
      if (address.address != null && address.address!.isNotEmpty) {
        try {
          await LocationLocalDatabase.instance
              .setLocationWithFlag('LocationData', false, address.address!);
        } catch (_) {}
      }

      return true;
    } catch (e) {
      debugPrint('Error setting default address: $e');
      return false;
    }
  }
}
