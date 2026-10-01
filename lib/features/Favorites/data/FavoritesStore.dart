import 'package:spicy_eats/features/Favorites/model/FavoriteDish.dart';

/// Storage contract for hearted dishes, so the favorites logic does not depend
/// on a specific database implementation.
abstract class FavoritesStore {
  Future<List<FavoriteDish>> getFavorites(String userId);

  /// Inserts a favorite, or refreshes the stored snapshot when the dish is
  /// already hearted. Returns the stored row id.
  Future<int> addFavorite(FavoriteDish favorite);

  Future<void> removeFavorite(String userId, int dishId);

  /// Removes every favorite for the user and returns how many were deleted.
  Future<int> clearFavorites(String userId);
}
