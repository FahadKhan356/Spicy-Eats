import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Payment/PaymentScreen.dart';
import 'package:spicy_eats/features/Payment/model/payment_method_model.dart';
import 'package:spicy_eats/features/Payment/repo/payment_methods_repository.dart';
import 'package:spicy_eats/main.dart';

class PaymentMethodsState {
  final List<PaymentMethodModel> methods;
  final bool isLoading;
  final String? error;
  final PaymentMethodModel? defaultMethod;
  final bool codEnabled;

  const PaymentMethodsState({
    this.methods = const [],
    this.isLoading = false,
    this.error,
    this.defaultMethod,
    this.codEnabled = true,
  });

  PaymentMethodsState copyWith({
    List<PaymentMethodModel>? methods,
    bool? isLoading,
    String? error,
    PaymentMethodModel? defaultMethod,
    bool? codEnabled,
    bool clearError = false,
  }) {
    return PaymentMethodsState(
      methods: methods ?? this.methods,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      defaultMethod: defaultMethod ?? this.defaultMethod,
      codEnabled: codEnabled ?? this.codEnabled,
    );
  }
}

class PaymentMethodsController extends StateNotifier<PaymentMethodsState> {
  final PaymentMethodsRepository _repository;
  final Ref _ref;

  PaymentMethodsController({
    required PaymentMethodsRepository repository,
    required Ref ref,
  })  : _repository = repository,
        _ref = ref,
        super(const PaymentMethodsState());

  Future<void> load({bool force = false, String? userId}) async {
    if (state.isLoading && !force) return;

    final currentUserId = userId ?? supabaseClient.auth.currentUser?.id;
    if (currentUserId == null || currentUserId.isEmpty) {
      try {
        final fallback = await _repository.fetchUserPaymentMethods('');
        if (fallback.isNotEmpty) {
          final def = fallback.firstWhere((m) => m.isDefault, orElse: () => fallback.first);
          state = state.copyWith(
            methods: fallback,
            isLoading: false,
            defaultMethod: def,
          );
          return;
        }
      } catch (_) {}

      state = state.copyWith(
        methods: [],
        isLoading: false,
        clearError: true,
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final fetched = await _repository.fetchUserPaymentMethods(currentUserId);
      PaymentMethodModel? def;
      if (fetched.isNotEmpty) {
        def = fetched.firstWhere((m) => m.isDefault, orElse: () => fetched.first);
        // Pre-select for checkout if not yet selected
        final currentSelected = _ref.read(selectedmethodProvider);
        if (currentSelected == null || currentSelected.isEmpty) {
          _ref.read(selectedmethodProvider.notifier).state =
              '${def.brandName} (${def.maskedCardNumber})';
        }
      }

      state = state.copyWith(
        methods: fetched,
        isLoading: false,
        defaultMethod: def,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load payment methods.',
      );
    }
  }

  Future<bool> addCard({
    required String cardNumber,
    required String cardHolder,
    required String expiryDate,
    required String cvv,
    bool isDefault = false,
  }) async {
    final currentUserId = supabaseClient.auth.currentUser?.id ?? '';
    if (currentUserId.isEmpty) return false;

    state = state.copyWith(isLoading: true, clearError: true);

    final newModel = PaymentMethodModel(
      userId: currentUserId,
      cardNumber: cardNumber,
      cardHolder: cardHolder,
      accountHolderName: cardHolder,
      expiryDate: expiryDate,
      mmYy: expiryDate,
      cvv: cvv,
      paymentType: 'Card',
      isDefault: isDefault || state.methods.isEmpty,
    );

    final created = await _repository.addPaymentMethod(newModel);
    if (created != null) {
      final List<PaymentMethodModel> updatedList = created.isDefault
          ? [
              created,
              ...state.methods.map((m) => m.copyWith(isDefault: false)),
            ]
          : [created, ...state.methods];

      PaymentMethodModel? def = state.defaultMethod;
      if (created.isDefault || def == null) {
        def = created;
        _ref.read(selectedmethodProvider.notifier).state =
            '${created.brandName} (${created.maskedCardNumber})';
      }

      state = state.copyWith(
        methods: updatedList,
        isLoading: false,
        defaultMethod: def,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to save card.',
      );
      return false;
    }
  }

  Future<bool> deleteCard(String paymentId) async {
    final success = await _repository.deletePaymentMethod(paymentId);
    if (success) {
      final updatedList =
          state.methods.where((m) => m.paymentId != paymentId).toList();
      PaymentMethodModel? newDef = state.defaultMethod;

      if (state.defaultMethod?.paymentId == paymentId) {
        newDef = updatedList.isNotEmpty ? updatedList.first : null;
        if (newDef != null) {
          final currentUserId = supabaseClient.auth.currentUser?.id ?? '';
          await _repository.setDefaultPaymentMethod(
            paymentId: newDef.paymentId!,
            userId: currentUserId,
          );
        }
      }

      state = state.copyWith(
        methods: updatedList,
        defaultMethod: newDef,
      );
      return true;
    }
    return false;
  }

  Future<void> setDefault(String paymentId) async {
    final currentUserId = supabaseClient.auth.currentUser?.id ?? '';
    final success = await _repository.setDefaultPaymentMethod(
      paymentId: paymentId,
      userId: currentUserId,
    );

    if (success) {
      final updatedList = state.methods.map((m) {
        return m.copyWith(isDefault: m.paymentId == paymentId);
      }).toList();

      final def = updatedList.firstWhere(
        (m) => m.paymentId == paymentId,
        orElse: () => updatedList.first,
      );

      _ref.read(selectedmethodProvider.notifier).state =
          '${def.brandName} (${def.maskedCardNumber})';

      state = state.copyWith(
        methods: updatedList,
        defaultMethod: def,
      );
    }
  }
}

final paymentMethodsControllerProvider =
    StateNotifierProvider<PaymentMethodsController, PaymentMethodsState>((ref) {
  final repo = ref.watch(paymentMethodsRepositoryProvider);
  return PaymentMethodsController(repository: repo, ref: ref);
});
