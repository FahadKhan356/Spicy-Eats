// Regression tests for the post-login crash: AccountScreen is built eagerly
// inside Home's IndexedStack, so the user row (userProvider) is still null on
// the first frames. Force-unwrapping it threw
// "Null check operator used on a null value" at app start.

import 'package:flutter_test/flutter_test.dart';

import 'package:spicy_eats/features/Profile/model/usermodel.dart';
import 'package:spicy_eats/features/account/screen/accountscreen.dart';

void main() {
  group('account header name', () {
    test('stays safe while the profile row is not loaded yet', () {
      expect(accountDisplayName(null), '');
      expect(accountAvatarInitial(accountDisplayName(null)), 'U');
    });

    test('uses the loaded profile name', () {
      final user = User(firstname: 'Fahad', lastname: 'Khan');

      expect(accountDisplayName(user), 'Fahad Khan');
      expect(accountAvatarInitial(accountDisplayName(user)), 'F');
    });

    test('ignores blank name parts', () {
      expect(accountDisplayName(User(firstname: '   ')), '');
      expect(accountDisplayName(User(lastname: 'Khan')), 'Khan');
    });
  });
}
