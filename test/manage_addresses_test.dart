import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spicy_eats/features/Home/model/AddressModel.dart';
import 'package:spicy_eats/features/Location/repository/address_repository.dart';
import 'package:spicy_eats/features/Location/screens/manage_addresses_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAddressRepository extends AddressRepository {
  final List<AddressModel> mockList;

  MockAddressRepository({required this.mockList})
      : super(supabase: Supabase.instance.client);

  @override
  Future<List<AddressModel>> fetchAllAddresses(String userId) async {
    return List.from(mockList);
  }

  @override
  Future<AddressModel?> addAddress(AddressModel address) async {
    final created = address.copyWith(id: 999);
    mockList.insert(0, created);
    return created;
  }

  @override
  Future<bool> updateAddress(AddressModel address) async {
    final index = mockList.indexWhere((a) => a.id == address.id);
    if (index != -1) {
      mockList[index] = address;
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteAddress(int addressId) async {
    mockList.removeWhere((a) => a.id == addressId);
    return true;
  }

  @override
  Future<bool> setDefaultAddress(AddressModel address) async {
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey: 'public-anon-key',
    );
  });

  group('AddressModel Unit Tests', () {
    test('JSON serialization & deserialization works correctly', () {
      final json = {
        'id': 101,
        'userId': 'user-uuid-123',
        'address': 'Main Clifton Road, Block 4',
        'streetNumber': '12',
        'floor': '3rd Floor',
        'label': 'Office',
        'othersDetails': 'Leave with security guard',
        'lat': 24.8607,
        'long': 67.0011,
      };

      final model = AddressModel.fromJson(json);

      expect(model.id, 101);
      expect(model.userId, 'user-uuid-123');
      expect(model.address, 'Main Clifton Road, Block 4');
      expect(model.streetNumber, '12');
      expect(model.floor, '3rd Floor');
      expect(model.label, 'Office');
      expect(model.othersDetails, 'Leave with security guard');
      expect(model.lat, 24.8607);
      expect(model.long, 67.0011);

      final exported = model.toJson();
      expect(exported['id'], 101);
      expect(exported['label'], 'Office');
      expect(exported['streetNumber'], '12');
    });

    test('copyWith updates specified fields only', () {
      final original = AddressModel(
        id: 1,
        userId: 'u1',
        address: 'Old Address',
        streetNumber: '1',
        floor: '2',
        label: 'Home',
        othersDetails: '',
        lat: 10.0,
        long: 20.0,
      );

      final updated = original.copyWith(
        address: 'New Address',
        label: 'Work',
      );

      expect(updated.id, 1);
      expect(updated.userId, 'u1');
      expect(updated.address, 'New Address');
      expect(updated.label, 'Work');
      expect(updated.streetNumber, '1');
      expect(updated.floor, '2');
      expect(updated.lat, 10.0);
      expect(updated.long, 20.0);
    });
  });

  group('ManageAddressesScreen Widget Tests', () {
    testWidgets('renders empty state when user has no addresses',
        (WidgetTester tester) async {
      final mockRepo = MockAddressRepository(mockList: []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            addressRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: const MaterialApp(
            home: ManageAddressesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('My Addresses'), findsOneWidget);
      expect(find.text('No Saved Addresses Yet'), findsOneWidget);
      expect(find.text('Add Your First Address'), findsOneWidget);
    });

    testWidgets('renders saved addresses and active banner',
        (WidgetTester tester) async {
      final sampleAddresses = [
        AddressModel(
          id: 1,
          userId: 'test-user',
          address: 'Sunset Boulevard, Apt 4B',
          streetNumber: '15',
          floor: '4',
          label: 'Home',
          othersDetails: 'Buzzer #4',
          lat: 24.8,
          long: 67.0,
        ),
        AddressModel(
          id: 2,
          userId: 'test-user',
          address: 'Tech Park Tower 2, Floor 8',
          streetNumber: '22',
          floor: '8',
          label: 'Work',
          othersDetails: '',
          lat: 24.9,
          long: 67.1,
        ),
      ];

      final mockRepo = MockAddressRepository(mockList: sampleAddresses);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            addressRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: const MaterialApp(
            home: ManageAddressesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('My Addresses'), findsOneWidget);
      expect(find.text('Saved Locations (2)'), findsOneWidget);
      expect(find.text('Sunset Boulevard, Apt 4B'), findsWidgets);
      expect(find.text('Tech Park Tower 2, Floor 8'), findsOneWidget);
      expect(find.text('Home'), findsWidgets);
      expect(find.text('Work'), findsOneWidget);
      expect(find.text('Add New Address'), findsOneWidget);
    });
  });
}
