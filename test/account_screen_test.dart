// Reproduces the exact post-login failure: Home builds its tabs through an
// IndexedStack, so AccountScreen is pumped before ProfileRepo has filled
// `userProvider`. It used to die with
//   TypeError: Null check operator used on a null value
// on the very first frame. This test pumps the real screen and asserts it lays
// out with no exception while the profile row is still missing.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:spicy_eats/features/account/screen/accountscreen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // GoTrue keeps its session in shared_preferences; without the mock the
    // plugin channel is missing and Supabase.initialize throws.
    SharedPreferences.setMockInitialValues({});
    // Dummy project: the widget only reads auth.currentUser, which is null until
    // someone signs in - exactly the state the crash happened in.
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey: 'public-anon-key',
    );
  });

  testWidgets('AccountScreen renders with no user profile loaded',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: AccountScreen())),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Spicy Eats User'), findsOneWidget);
    expect(find.text('U'), findsOneWidget);
  });
}
