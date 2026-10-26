import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Home/model/AddressModel.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/features/Location/repository/address_repository.dart';
import 'package:spicy_eats/main.dart';

class AddressListState {
  final List<AddressModel> addresses;
  final bool isLoading;
  final String? error;
  final AddressModel? activeAddress;

  const AddressListState({
    this.addresses = const [],
    this.isLoading = false,
    this.error,
    this.activeAddress,
  });

  AddressListState copyWith({
    List<AddressModel>? addresses,
    bool? isLoading,
    String? error,
    AddressModel? activeAddress,
    bool clearError = false,
  }) {
    return AddressListState(
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      activeAddress: activeAddress ?? this.activeAddress,
    );
  }
}

class AddressController extends StateNotifier<AddressListState> {
  final AddressRepository _repository;
  final Ref _ref;

  AddressController({
    required AddressRepository repository,
    required Ref ref,
  })  : _repository = repository,
        _ref = ref,
        super(const AddressListState());

  Future<void> load({bool force = false, String? userId}) async {
    if (state.isLoading && !force) return;

    final currentUserId = userId ?? supabaseClient.auth.currentUser?.id;
    if (currentUserId == null || currentUserId.isEmpty) {
      try {
        final fallback = await _repository.fetchAllAddresses('');
        if (fallback.isNotEmpty) {
          state = state.copyWith(
            addresses: fallback,
            isLoading: false,
            activeAddress: fallback.first,
          );
          return;
        }
      } catch (_) {}

      state = state.copyWith(
        addresses: [],
        isLoading: false,
        clearError: true,
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final fetched = await _repository.fetchAllAddresses(currentUserId);
      final active = _ref.read(pickedAddressProvider);

      // Determine active address
      AddressModel? matchedActive;
      if (active != null) {
        matchedActive = fetched.firstWhere(
          (a) => (a.id != null && a.id == active.id) || a.address == active.address,
          orElse: () => active,
        );
      } else if (fetched.isNotEmpty) {
        matchedActive = fetched.first;
        _ref.read(pickedAddressProvider.notifier).state = matchedActive;
      }

      state = state.copyWith(
        addresses: fetched,
        isLoading: false,
        activeAddress: matchedActive,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load addresses. Please try again.',
      );
    }
  }

  Future<bool> addAddress({
    required String address,
    required String streetNumber,
    required String floor,
    required String label,
    required String othersDetails,
    required double lat,
    required double long,
    bool setAsActive = false,
  }) async {
    final currentUserId = supabaseClient.auth.currentUser?.id ?? '';
    if (currentUserId.isEmpty) return false;

    state = state.copyWith(isLoading: true, clearError: true);

    final newModel = AddressModel(
      userId: currentUserId,
      address: address,
      streetNumber: streetNumber,
      floor: floor,
      label: label,
      othersDetails: othersDetails,
      lat: lat,
      long: long,
    );

    final created = await _repository.addAddress(newModel);
    if (created != null) {
      final updatedList = [created, ...state.addresses];
      AddressModel? newActive = state.activeAddress;

      if (setAsActive || state.activeAddress == null) {
        newActive = created;
        await _repository.setDefaultAddress(created);
        _ref.read(pickedAddressProvider.notifier).state = created;
      }

      state = state.copyWith(
        addresses: updatedList,
        isLoading: false,
        activeAddress: newActive,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to save address. Please try again.',
      );
      return false;
    }
  }

  Future<bool> updateAddress(AddressModel updatedAddress) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final success = await _repository.updateAddress(updatedAddress);
    if (success) {
      final updatedList = state.addresses.map((a) {
        return a.id == updatedAddress.id ? updatedAddress : a;
      }).toList();

      AddressModel? active = state.activeAddress;
      if (active?.id == updatedAddress.id) {
        active = updatedAddress;
        _ref.read(pickedAddressProvider.notifier).state = updatedAddress;
      }

      state = state.copyWith(
        addresses: updatedList,
        isLoading: false,
        activeAddress: active,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update address.',
      );
      return false;
    }
  }

  Future<bool> deleteAddress(int addressId) async {
    final success = await _repository.deleteAddress(addressId);
    if (success) {
      final updatedList = state.addresses.where((a) => a.id != addressId).toList();
      AddressModel? newActive = state.activeAddress;

      if (state.activeAddress?.id == addressId) {
        newActive = updatedList.isNotEmpty ? updatedList.first : null;
        _ref.read(pickedAddressProvider.notifier).state = newActive;
        if (newActive != null) {
          await _repository.setDefaultAddress(newActive);
        }
      }

      state = state.copyWith(
        addresses: updatedList,
        activeAddress: newActive,
      );
      return true;
    }
    return false;
  }

  Future<void> setActiveAddress(AddressModel address) async {
    await _repository.setDefaultAddress(address);
    _ref.read(pickedAddressProvider.notifier).state = address;
    state = state.copyWith(activeAddress: address);
  }
}

final addressControllerProvider =
    StateNotifierProvider<AddressController, AddressListState>((ref) {
  final repo = ref.watch(addressRepositoryProvider);
  return AddressController(repository: repo, ref: ref);
});
