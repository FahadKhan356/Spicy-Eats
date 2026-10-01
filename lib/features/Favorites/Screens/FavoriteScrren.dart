import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/commons/Providers.dart';
import 'package:spicy_eats/features/Cart/model/Cartmodel.dart';
import 'package:spicy_eats/features/Cart/repository/CartRepository.dart';
import 'package:spicy_eats/features/Cart/screens/BasketScreen.dart';
import 'package:spicy_eats/features/Favorites/model/FavoriteDish.dart';
import 'package:spicy_eats/features/Favorites/repository/FavoritesRepository.dart';
import 'package:spicy_eats/features/Home/model/restaurant_model.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/Sqlight%20Database/Dishes/services/DishesLocalDataBase.dart';
import 'package:spicy_eats/features/Sqlight%20Database/Restaurants/services/RestaurantLocalDataBase.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/dish%20menu/dishmenuVariation.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';

class Favoritescreen extends ConsumerStatefulWidget {
  static const String routename = '/favorite';

  const Favoritescreen({super.key});

  @override
  ConsumerState<Favoritescreen> createState() => _FavoritescreenState();
}

class _FavoritescreenState extends ConsumerState<Favoritescreen> {
  bool _isLoading = true;
  int _busyDishId = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(favoriteDishListProvider.notifier).load();
      if (mounted) setState(() => _isLoading = false);
    });
  }

  /// Resolves a restaurant from the local restaurant cache so variation dishes
  /// can be opened on the screen that already knows how to collect options.
  Future<RestaurantModel?> _resolveRestaurant(String restaurantId) async {
    try {
      final restaurants = await RestaurantLocalDatabase.instance.getRestaurants();
      for (final restaurant in restaurants) {
        if (restaurant.restuid == restaurantId) return restaurant;
      }
      return restaurants.isEmpty ? null : restaurants.first;
    } catch (e) {
      debugPrint('Failed To Resolve Restaurant $e');
      return null;
    }
  }

  void _showMessage(String message,
      {IconData icon = Icons.check_circle, Color color = Colors.green}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
  }

  Future<void> _removeFavorite(FavoriteDish favorite) async {
    await ref
        .read(favoriteDishListProvider.notifier)
        .remove(favorite.dishId);

    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text('${favorite.name} removed from favorites')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          action: SnackBarAction(
            label: 'Undo',
            textColor: Colors.white,
            onPressed: () => ref
                .read(favoriteDishListProvider.notifier)
                .restore(favorite),
          ),
        ),
      );
  }

  Future<void> _confirmRemove(FavoriteDish favorite) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.favorite_border, color: Colors.red),
            SizedBox(width: 12),
            Text('Remove from Favorites'),
          ],
        ),
        content: Text('Remove "${favorite.name}" from your favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _removeFavorite(favorite);
    }
  }

  Future<void> _confirmClearAll(int count) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red),
            SizedBox(width: 12),
            Text('Clear Favorites'),
          ],
        ),
        content: Text(
            'Remove all $count favorite${count == 1 ? '' : 's'} from your list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ref.read(favoriteDishListProvider.notifier).clearAll();
    _showMessage('All favorites cleared',
        icon: Icons.delete_outline, color: Colors.red);
  }

  Future<void> _addToCart(FavoriteDish favorite) async {
    if (_busyDishId != -1) return;
    setState(() => _busyDishId = favorite.dishId);

    try {
      if (favorite.isVariation) {
        await _openVariationPicker(favorite);
        return;
      }

      await ref.read(cartReopProvider).addCartItem(
            restaurantName: favorite.restaurantName,
            restaurantId: favorite.restaurantId,
            itemprice: favorite.payablePrice,
            name: favorite.name,
            description: favorite.description,
            ref: ref,
            userId: currentUserId,
            dishId: favorite.dishId,
            discountprice: favorite.discountPrice,
            price: favorite.price,
            image: favorite.image,
            variations: null,
            isdishScreen: false,
            quantity: 1,
            freqboughts: null,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.shopping_cart, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text('${favorite.name} added to cart')),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            action: SnackBarAction(
              label: 'View Cart',
              textColor: Colors.white,
              onPressed: () => _openCart(favorite.restaurantId),
            ),
          ),
        );
    } catch (e) {
      debugPrint('Failed To Add Favorite To Cart $e');
      _showMessage('Could not add to cart. Please try again.',
          icon: Icons.error_outline, color: Colors.red);
    } finally {
      if (mounted) setState(() => _busyDishId = -1);
    }
  }

  /// Dishes with variations cannot be added blindly, so they are sent to the
  /// existing variation screen to pick options.
  Future<void> _openVariationPicker(FavoriteDish favorite) async {
    final restaurant = await _resolveRestaurant(favorite.restaurantId);
    if (!mounted) return;

    if (restaurant == null) {
      _showMessage('Restaurant unavailable. Please try again later.',
          icon: Icons.error_outline, color: Colors.red);
      return;
    }

    List<DishData> dishes = [];
    try {
      dishes = await DishesLocalDatabase.instance.getDishes(restaurant.restuid!) ?? [];
    } catch (e) {
      debugPrint('Failed To Load Dishes For Variation $e');
    }

    if (!dishes.any((dish) => dish.dishid == favorite.dishId)) {
      dishes = [...dishes, favorite.toDishData()];
    }

    // The variation screen resolves "frequently bought together" against this
    // provider, which the restaurant menu normally fills. Seed it here so the
    // section still works when favorites is the first screen opened.
    ref.read(dishesListProvider.notifier).state = dishes;

    final cart = ref.read(cartProvider);
    final cartItem = cart.cast<Cartmodel?>().firstWhere(
          (item) => item?.dish_id == favorite.dishId,
          orElse: () => null,
        );

    if (!mounted) return;
    ref.read(isloaderProvider.notifier).state = true;
    await Navigator.pushNamed(
      context,
      DishMenuVariation.routename,
      arguments: {
        'dishes': dishes,
        'dish': favorite.toDishData(),
        'iscart': cartItem != null,
        'cartdish': cartItem,
        'carts': cart,
        'isbasket': false,
        'isdishscreen': true,
        'restaurantdata': restaurant,
      },
    );
    if (mounted) ref.read(isloaderProvider.notifier).state = false;
  }

  Future<void> _openCart(String restaurantId) async {
    final restaurant = await _resolveRestaurant(restaurantId);
    if (!mounted || restaurant == null) return;

    List<DishData> dishes = [];
    try {
      dishes =
          await DishesLocalDatabase.instance.getDishes(restaurant.restuid!) ??
              [];
    } catch (e) {
      debugPrint('Failed To Load Dishes For Cart $e');
    }

    if (!mounted) return;
    await Navigator.pushNamed(
      context,
      CartScreen.routename,
      arguments: {
        'dishes': dishes,
        'restuid': restaurant.restuid,
        'restdata': restaurant,
      },
    );
  }

  /// The favorites list is the second tab of the Home shell, so "explore" has
  /// to switch that shell back to its first tab. Pushing HomeScreen as a fresh
  /// route instead would stack a second copy of the tab on top of the shell,
  /// which drops the bottom nav and leaves a stray back button behind.
  void _exploreMenu() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    }
    ref.read(currentIndexProvider.notifier).state = 0;
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoriteDishListProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Favorites',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            if (favorites.isNotEmpty)
              Text(
                '${favorites.length} item${favorites.length == 1 ? '' : 's'} saved',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        centerTitle: true,
        actions: [
          if (favorites.isNotEmpty)
            IconButton(
              onPressed: () => _confirmClearAll(favorites.length),
              icon: Icon(Icons.delete_outline, color: Colors.grey[700]),
              tooltip: 'Clear all',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : favorites.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () => ref
                      .read(favoriteDishListProvider.notifier)
                      .load(userId: currentUserId),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final favorite = favorites[index];
                      return _buildFavoriteCard(context, favorite);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 100,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            Text(
              'No Favorites Yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart on any dish to save it here for later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _exploreMenu,
              icon: const Icon(Icons.explore),
              label: const Text('Explore Menu'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[600],
                foregroundColor: Colors.white,
                shadowColor: Colors.orange.withValues(alpha: 0.4),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, FavoriteDish favorite) {
    final isBusy = _busyDishId == favorite.dishId;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDishImage(favorite.image),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (favorite.isVeg == true) ...[
                              const Icon(Icons.crop_square,
                                  size: 14, color: Colors.green),
                              const SizedBox(width: 4),
                            ] else if (favorite.isVeg == false) ...[
                              const Icon(Icons.stop,
                                  size: 14, color: Colors.red),
                              const SizedBox(width: 4),
                            ],
                            Expanded(
                              child: Text(
                                favorite.name,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _confirmRemove(favorite),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.restaurant,
                                size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                favorite.restaurantName,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (favorite.isVariation) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Options',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.purple,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          favorite.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Divider(color: Colors.grey[200], height: 1),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '\$${favorite.payablePrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                            ),
                          ),
                          if (favorite.hasDiscount) ...[
                            const SizedBox(width: 6),
                            Text(
                              '\$${favorite.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  _buildAddToCartButton(favorite, isBusy),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDishImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 90,
        height: 90,
        color: Colors.grey[200],
        child: imageUrl.isEmpty
            ? Icon(Icons.restaurant, size: 40, color: Colors.grey[400])
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: 90,
                height: 90,
                cacheWidth: 180,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported,
                      size: 32, color: Colors.grey[400]),
                ),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildAddToCartButton(FavoriteDish favorite, bool isBusy) {
    return SizedBox(
      height: 46,
      child: ElevatedButton(
        onPressed: isBusy ? null : () => _addToCart(favorite),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange[600]!, Colors.orange[400]!],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: isBusy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        favorite.isVariation
                            ? Icons.tune
                            : Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        favorite.isVariation ? 'Options' : 'Add to Cart',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
