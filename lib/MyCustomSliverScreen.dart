import 'package:flutter/material.dart';

class MyCustomSliverScreen extends StatefulWidget {
  const MyCustomSliverScreen({super.key});

  @override
  State<MyCustomSliverScreen> createState() => _MyCustomSliverScreenState();
}

class _MyCustomSliverScreenState extends State<MyCustomSliverScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isSliverAppBarPinned = false;

  final List<String> _headers = [
    'asdadsadasd',
    'adsdad',
    'Spicy Dishes',
    'Sea Food',
    'Sweets',
    'Beverages'
  ];
  final List<List<String>> _items = [
    [
      'Spicy Item 1',
      'Spicy Item 2',
      'Spicy Item 3',
      'Spicy Item 4',
      'Spicy Item 5',
      'Spicy Item 6',
      'Spicy Item 7',
      'Spicy Item 8',
      'Spicy Item 9',
      'Spicy Item 10'
    ],
    [
      'Spicy Item 1',
      'Spicy Item 2',
      'Spicy Item 3',
      'Spicy Item 4',
      'Spicy Item 5',
      'Spicy Item 6',
      'Spicy Item 7',
      'Spicy Item 8',
      'Spicy Item 9',
      'Spicy Item 10'
    ],
    [
      'Spicy Item 1',
      'Spicy Item 2',
      'Spicy Item 3',
      'Spicy Item 4',
      'Spicy Item 5',
      'Spicy Item 6',
      'Spicy Item 7',
      'Spicy Item 8',
      'Spicy Item 9',
      'Spicy Item 10'
    ],
    [
      'Sea Food Item 1',
      'Sea Food Item 2',
      'Sea Food Item 3',
      'Sea Food Item 4',
      'Sea Food Item 5'
    ],
    ['Sweet Item 1', 'Sweet Item 2', 'Sweet Item 3'],
    [
      'Beverage Item 1',
      'Beverage Item 2',
      'Beverage Item 3',
      'Beverage Item 4',
      'Beverage Item 4',
    ],
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: _headers.length, vsync: this);
    _scrollController.addListener(_onScroll);

    super.initState();
  }

  void _onScroll() {
    // Calculate the current visible section based on scroll position
    final double offset = _scrollController.offset;
    int newIndex = 0;
    for (int i = 0; i < _headers.length; i++) {
      if (offset >= _getSectionOffset(i) && offset < _getSectionOffset(i + 1)) {
        newIndex = i;
        _tabController.animateTo(newIndex);
        break;
      }
    }
    // Ensure the last section stays selected when scrolling to the bottom
    if (offset >= _getSectionOffset(_headers.length - 1)) {
      newIndex = _headers.length - 1;
    }
    if (newIndex != _currentIndex) {
      setState(() {
        _currentIndex = newIndex;
        _tabController.animateTo(newIndex);
      });
    }
  }

  double _getSectionOffset(int index) {
    // Calculate the offset for each section
    double offset = 0;
    for (int i = 0; i < index; i++) {
      offset += _items[i].length * 60.0 +
          100; // 60 is item height, 100 is header height
    }
    return offset;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total number of children (headers + items)
    int totalChildren =
        _headers.length + _items.fold(0, (sum, items) => sum + items.length);

    return Scaffold(
      body: NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
          final double offset = notification.metrics.pixels;
          const double appBarHeight =
              120.0; // Height of the expanded SliverAppBar

          if (offset >= appBarHeight && !_isSliverAppBarPinned) {
            setState(() {
              _isSliverAppBarPinned = true;
            });
          } else if (offset < appBarHeight && _isSliverAppBarPinned) {
            setState(() {
              _isSliverAppBarPinned = false;
            });
          }
          return false;
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.brown[100],
              pinned: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  'https://b.zmtcdn.com/data/pictures/chains/7/20287/24697b617bb8aaf5b1c7df9a7074a662.jpg?fit=around|960:500&crop=960:500;*,*',
                  fit: BoxFit.cover,
                ),
              ),
              title: _isSliverAppBarPinned
                  ? TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      tabs: _headers.map((e) => Text(e)).toList(),
                      onTap: (index) {
                        _scrollController.animateTo(
                          _getSectionOffset(index),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                    )
                  : null,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  // Calculate which header and item to display
                  int headerIndex = 0;
                  int itemIndex = 0;
                  int currentIndex = 0;

                  for (int i = 0; i < _headers.length; i++) {
                    if (index == currentIndex) {
                      // Display header
                      return Container(
                        height: 100,
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child: Text(
                          _headers[i],
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    currentIndex++;
                    for (int j = 0; j < _items[i].length; j++) {
                      if (index == currentIndex) {
                        // Display item
                        return ListTile(
                          title: Text(_items[i][j]),
                        );
                      }
                      currentIndex++;
                    }
                  }
                  return null;
                },
                childCount: totalChildren, // Total number of children
              ),
            )
          ],
        ),
      ),
    );
  }
}
