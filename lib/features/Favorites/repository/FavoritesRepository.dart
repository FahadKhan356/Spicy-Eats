import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Favorites/data/FavoritesLocalDatabase.dart';
import 'package:spicy_eats/features/Favorites/data/FavoritesStore.dart';
import 'package:spicy_eats/features/Favorites/model/FavoriteDish.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/main.dart';

/// User id used when nobody is signed in, so guests still get a working
/// favorites list on the device.
String get currentUserId =>
    supabaseClient.auth.currentUser?.id ?? 'guest_user';

final favoriteDishListProvider = StateNotifierProvider<FavoriteDishNotifier,
    List<FavoriteDish>>((ref) {
  return FavoriteDishNotifier(FavoritesLocalDatabase.instance);
});

class FavoriteDishNotifier extends StateNotifier<List<FavoriteDish>> {
  FavoriteDishNotifier(this._database) : super(const []);

  final FavoritesStore _database;
  String? _loadedUserId;

  bool isFavorite(int dishId) => state.any((favorite) => favorite.dishId == dishId);

  Set<int> get favoriteDishIds =>
      state.map((favorite) => favorite.dishId).toSet();

  /// Reads favorites from SQLite. Safe to call repeatedly; only the first call
  /// for a given user hits the database.
  Future<void> load({String? userId}) async {
    final user = userId ?? currentUserId;
    if (_loadedUserId == user && state.isNotEmpty) return;
    _loadedUserId = user;
    final favorites = await _database.getFavorites(user);
    state = favorites;
  }

  /// Heart/unheart a dish. Returns the resulting state so callers can show the
  /// right confirmation message.
  Future<bool> toggle({
    required DishData dish,
    required String restaurantId,
    required String restaurantName,
  }) async {
    final user = currentUserId;
    await load(userId: user);

    final existing =
        state.where((fav) => fav.dishId == dish.dishid).toList();
    if (existing.isNotEmpty) {
      await remove(dish.dishid ?? 0);
      return false;
    }

    final favorite = FavoriteDish.fromDish(
      dish: dish,
      userId: user,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
    );

    final inserted = await _database.addFavorite(favorite);
    if (inserted <= 0) return false;

    state = [favorite, ...state];
    return true;
  }

  Future<void> remove(int dishId) async {
    await _database.removeFavorite(currentUserId, dishId);
    state = state.where((fav) => fav.dishId != dishId).toList();
  }

  /// Re-inserts a previously removed favorite, used by the undo action.
  Future<void> restore(FavoriteDish favorite) async {
    final inserted = await _database.addFavorite(favorite);
    if (inserted <= 0) return;
    state = [favorite, ...state];
  }

  Future<int> clearAll() async {
    final removed = await _database.clearFavorites(currentUserId);
    state = const [];
    return removed;
  }
}
