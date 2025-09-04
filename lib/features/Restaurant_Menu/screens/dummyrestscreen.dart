import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class Restaurant {
  final String name;
  final String image;
  final double rating;
  final String deliveryTime;
  final String cuisine;
  final List<MenuCategory> categories;

  Restaurant({
    required this.name,
    required this.image,
    required this.rating,
    required this.deliveryTime,
    required this.cuisine,
    required this.categories,
  });
}

class MenuCategory {
  final String name;
  final List<Dish> dishes;

  MenuCategory({required this.name, required this.dishes});
}

class Dish {
  final String name;
  final String description;
  final double price;
  final String image;
  final bool isVeg;

  Dish({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.isVeg,
  });
}

class RestaurantMenu extends StatefulWidget {
  @override
  _RestaurantMenuState createState() => _RestaurantMenuState();
}

class _RestaurantMenuState extends State<RestaurantMenu>
    with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  TabController? _tabController;
  List<GlobalKey> _categoryKeys = [];
  int _currentIndex = 0;
  double _imageOpacity = 1.0;
  double _headerHeight = 250.0;
  bool _isHeaderVisible = true;

  final Restaurant restaurant = Restaurant(
    name: "Delicious Bites",
    image: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800",
    rating: 4.5,
    deliveryTime: "25-30 min",
    cuisine: "Italian, Continental",
    categories: [
      MenuCategory(
        name: "Starters",
        dishes: [
          Dish(
            name: "Bruschetta",
            description: "Grilled bread with tomatoes, garlic, and basil",
            price: 8.99,
            image:
                "https://images.unsplash.com/photo-1572441713132-51c75654db73?w=200",
            isVeg: true,
          ),
          Dish(
            name: "Caesar Salad",
            description: "Fresh romaine lettuce with parmesan and croutons",
            price: 12.99,
            image:
                "https://images.unsplash.com/photo-1546793665-c74683f339c1?w=200",
            isVeg: true,
          ),
          Dish(
            name: "Chicken Wings",
            description: "Spicy buffalo wings with ranch dip",
            price: 14.99,
            image:
                "https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=200",
            isVeg: false,
          ),
        ],
      ),
      MenuCategory(
        name: "Main Course",
        dishes: [
          Dish(
            name: "Margherita Pizza",
            description: "Classic pizza with tomatoes, mozzarella, and basil",
            price: 18.99,
            image:
                "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=200",
            isVeg: true,
          ),
          Dish(
            name: "Grilled Salmon",
            description: "Fresh salmon with herbs and lemon",
            price: 24.99,
            image:
                "https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=200",
            isVeg: false,
          ),
          Dish(
            name: "Pasta Carbonara",
            description: "Creamy pasta with bacon and parmesan",
            price: 16.99,
            image:
                "https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?w=200",
            isVeg: false,
          ),
          Dish(
            name: "Vegetable Stir Fry",
            description: "Fresh vegetables with Asian spices",
            price: 14.99,
            image:
                "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=200",
            isVeg: true,
          ),
        ],
      ),
      MenuCategory(
        name: "Desserts",
        dishes: [
          Dish(
            name: "Tiramisu",
            description: "Classic Italian dessert with coffee and mascarpone",
            price: 7.99,
            image:
                "https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=200",
            isVeg: true,
          ),
          Dish(
            name: "Chocolate Cake",
            description: "Rich chocolate cake with vanilla ice cream",
            price: 8.99,
            image:
                "https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=200",
            isVeg: true,
          ),
        ],
      ),
      MenuCategory(
        name: "Beverages",
        dishes: [
          Dish(
            name: "Fresh Orange Juice",
            description: "Freshly squeezed orange juice",
            price: 4.99,
            image:
                "https://images.unsplash.com/photo-1613478223719-2ab802602423?w=200",
            isVeg: true,
          ),
          Dish(
            name: "Iced Coffee",
            description: "Cold brew coffee with milk and ice",
            price: 5.99,
            image:
                "https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=200",
            isVeg: true,
          ),
          Dish(
            name: "Mojito",
            description: "Classic mint and lime mocktail",
            price: 6.99,
            image:
                "https://images.unsplash.com/photo-1551538827-9c037cb4f32a?w=200",
            isVeg: true,
          ),
        ],
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: restaurant.categories.length,
      vsync: this,
    );
    _categoryKeys = List.generate(
      restaurant.categories.length,
      (index) => GlobalKey(),
    );
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    double offset = _scrollController.offset;

    // Handle image opacity and header visibility
    setState(() {
      if (offset <= _headerHeight) {
        _imageOpacity = 1.0 - (offset / _headerHeight);
        _isHeaderVisible = true;
      } else {
        _imageOpacity = 0.0;
        _isHeaderVisible = false;
      }
    });

    // Update tab selection based on scroll position
    _updateTabIndex();
  }

  void _updateTabIndex() {
    for (int i = 0; i < _categoryKeys.length; i++) {
      final RenderBox? renderBox =
          _categoryKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        if (position.dy <= 200 && position.dy >= -200) {
          if (_currentIndex != i) {
            setState(() {
              _currentIndex = i;
            });
            _tabController?.animateTo(i);
            break;
          }
        }
      }
    }
  }

  void _scrollToCategory(int index) {
    final RenderBox? renderBox =
        _categoryKeys[index].currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      final offset = _scrollController.offset + position.dy - 150;
      _scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: _headerHeight,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.share, color: Colors.black),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.black),
                  onPressed: () {},
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedOpacity(
                      opacity: _imageOpacity,
                      duration: Duration(milliseconds: 100),
                      child: Image.network(
                        restaurant.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.restaurant,
                                size: 50, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: _imageOpacity,
                      duration: Duration(milliseconds: 100),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                title: AnimatedOpacity(
                  opacity: _isHeaderVisible ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 200),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 16),
                          Text(
                            ' ${restaurant.rating} • ${restaurant.deliveryTime}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                titlePadding: EdgeInsets.only(left: 60, bottom: 16),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: Colors.orange,
                  labelColor: Colors.orange,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  tabs: restaurant.categories.map((category) {
                    return Tab(text: category.name);
                  }).toList(),
                  onTap: _scrollToCategory,
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Restaurant Details (shown when image is visible)
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: _isHeaderVisible ? null : 0,
                child: AnimatedOpacity(
                  opacity: _imageOpacity,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          restaurant.cuisine,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 20),
                            Text(
                              ' ${restaurant.rating}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(' • '),
                            Icon(Icons.access_time,
                                size: 16, color: Colors.grey),
                            Text(' ${restaurant.deliveryTime}'),
                            Spacer(),
                            Icon(Icons.delivery_dining, color: Colors.green),
                            Text(' Free Delivery',
                                style: TextStyle(color: Colors.green)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Menu Categories
              ...restaurant.categories.asMap().entries.map((entry) {
                int index = entry.key;
                MenuCategory category = entry.value;

                return Container(
                  key: _categoryKeys[index],
                  margin: EdgeInsets.only(
                      top: index == 0
                          ? 20
                          : 40), // More spacing between categories
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
                        color: Colors.grey[50],
                        child: Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      ...category.dishes.map((dish) => _buildDishItem(dish)),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDishItem(Dish dish) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      dish.isVeg ? Icons.crop_square : Icons.stop,
                      color: dish.isVeg ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        dish.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  dish.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '\$${dish.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  dish.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: Icon(Icons.fastfood, color: Colors.grey),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: -5,
                right: -5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${dish.name} added to cart!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
