import 'package:flutter/material.dart';

String image =
    'https://b.zmtcdn.com/data/pictures/chains/7/20287/24697b617bb8aaf5b1c7df9a7074a662.jpg?fit=around|960:500&crop=960:500;*,*';

class FoodMenuScreen extends StatefulWidget {
  const FoodMenuScreen({super.key});

  @override
  _FoodMenuScreenState createState() => _FoodMenuScreenState();
}

class _FoodMenuScreenState extends State<FoodMenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final List<String> _headers = [
    'Spicy Dishes',
    'Sea Food',
    'Sweets',
    'Beverages'
  ];
  final List<List<String>> _items = [
    ['Spicy Item 1', 'Spicy Item 2', 'Spicy Item 3'],
    ['Sea Food Item 1', 'Sea Food Item 2', 'Sea Food Item 3'],
    ['Sweet Item 1', 'Sweet Item 2', 'Sweet Item 3'],
    ['Beverage Item 1', 'Beverage Item 2', 'Beverage Item 3'],
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _headers.length, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Calculate the current visible section based on scroll position
    final double offset = _scrollController.offset;
    int newIndex = 0;
    for (int i = 0; i < _headers.length; i++) {
      if (offset >= _getSectionOffset(i) && offset < _getSectionOffset(i + 1)) {
        newIndex = i;
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
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200.0,
              pinned: true,
              floating: false, // Disable floating to ensure smooth animation
              snap: false, // Disable snap to ensure smooth animation
              flexibleSpace: FlexibleSpaceBar(
                collapseMode:
                    CollapseMode.parallax, // Smooth shrinking animation
                title: _scrollController.hasClients &&
                        _scrollController.offset > 100
                    ? Container(
                        color: Colors.white, // Background color for the TabBar
                        child: TabBar(
                          controller: _tabController,
                          tabs: _headers
                              .map((header) => Tab(text: header))
                              .toList(),
                          onTap: (index) {
                            _scrollController.animateTo(
                              _getSectionOffset(index),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      )
                    : null, // Show TabBar only when image is shrunk
                background: Image.network(
                  'https://b.zmtcdn.com/data/pictures/chains/7/20287/24697b617bb8aaf5b1c7df9a7074a662.jpg?fit=around|960:500&crop=960:500;*,*',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: ListView.builder(
          controller: _scrollController,
          itemCount: _headers.length * 2 + 1, // Headers + Items + Extra padding
          itemBuilder: (context, index) {
            if (index == _headers.length * 2) {
              // Add extra padding at the bottom to allow the last header to reach the top
              return SizedBox(height: MediaQuery.of(context).size.height);
            }
            if (index.isEven) {
              // Header
              final headerIndex = index ~/ 2;
              return Container(
                height: 100,
                alignment: Alignment.center,
                color: Colors.grey[200],
                child: Text(
                  _headers[headerIndex],
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              );
            } else {
              // Items
              final itemIndex = (index - 1) ~/ 2;
              return Column(
                children: _items[itemIndex]
                    .map((item) => ListTile(
                          title: Text(item),
                        ))
                    .toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
