import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Payment/model/payment_method_model.dart';
import 'package:spicy_eats/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final paymentMethodsRepositoryProvider = Provider<PaymentMethodsRepository>((ref) {
  return PaymentMethodsRepository(supabase: supabaseClient);
});

class PaymentMethodsRepository {
  final SupabaseClient supabase;

  PaymentMethodsRepository({required this.supabase});

  /// Fetches saved payment methods for a given user.
  Future<List<PaymentMethodModel>> fetchUserPaymentMethods(String userId) async {
    try {
      if (userId.isEmpty) return [];

      final response = await supabase
          .from('payments')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      return data
          .map((item) => PaymentMethodModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching payment methods: $e');
      return [];
    }
  }

  /// Saves a new payment method to the payments table.
  Future<PaymentMethodModel?> addPaymentMethod(PaymentMethodModel model) async {
    try {
      if (model.isDefault) {
        // Reset any existing default cards for this user
        try {
          await supabase
              .from('payments')
              .update({'isDefault': false})
              .eq('user_id', model.userId);
        } catch (_) {}
      }

      final insertData = model.toJson();
      insertData.remove('paymentId'); // Let DB generate default gen_random_uuid()

      final response = await supabase
          .from('payments')
          .insert(insertData)
          .select()
          .single();

      return PaymentMethodModel.fromJson(response);
    } catch (e) {
      debugPrint('Error adding payment method: $e');
      return null;
    }
  }

  /// Deletes a payment method by its paymentId.
  Future<bool> deletePaymentMethod(String paymentId) async {
    try {
      await supabase.from('payments').delete().eq('paymentId', paymentId);
      return true;
    } catch (e) {
      debugPrint('Error deleting payment method: $e');
      return false;
    }
  }

  /// Sets a specific payment method as the default.
  Future<bool> setDefaultPaymentMethod({
    required String paymentId,
    required String userId,
  }) async {
    try {
      // Set all to false
      await supabase
          .from('payments')
          .update({'isDefault': false})
          .eq('user_id', userId);

      // Set target to true
      await supabase
          .from('payments')
          .update({'isDefault': true})
          .eq('paymentId', paymentId);

      return true;
    } catch (e) {
      debugPrint('Error setting default payment method: $e');
      return false;
    }
  }
}
