import 'package:flutter/material.dart';

class SliverAppBarWithDynamicTabs extends StatefulWidget {
  @override
  _SliverAppBarWithDynamicTabsState createState() =>
      _SliverAppBarWithDynamicTabsState();
}

class _SliverAppBarWithDynamicTabsState
    extends State<SliverAppBarWithDynamicTabs>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(length: 3, vsync: this);

    _scrollController.addListener(() {
      _handleScroll();
    });
  }

  void _handleScroll() {
    double expandedHeight = 250.0; // Expanded height of SliverAppBar
    double scrollOffset = _scrollController.offset;

    // Fade in title when scrolling up
    double newOpacity = (scrollOffset / expandedHeight).clamp(0.0, 1.0);
    if (newOpacity != _opacity) {
      setState(() {
        _opacity = newOpacity;
        print(scrollOffset);
      });
    }

    // **Tab Switching Logic**
    if (scrollOffset >= 600) {
      _tabController.animateTo(2); // Tab 3 (Item 10 and beyond)
    } else if (scrollOffset >= 300) {
      _tabController.animateTo(1); // Tab 2 (Item 5 to 9)
    } else {
      _tabController.animateTo(0); // Tab 1 (Item 1 to 4)
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              pinned: true,
              expandedHeight: 250.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  "https://notjustdev-dummy.s3.us-east-2.amazonaws.com/uber-eats/restaurant1.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
              bottom: _scrollController.offset >= 190
                  ? PreferredSize(
                      preferredSize: Size.fromHeight(50.0),
                      child: Container(
                        color: Colors.white,
                        child: TabBar(
                          controller: _tabController,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(text: "Tab 1"),
                            Tab(text: "Tab 2"),
                            Tab(text: "Tab 3"),
                          ],
                        ),
                      ),
                    )
                  : PreferredSize(
                      preferredSize: Size.fromHeight(10), child: SizedBox()),
              //Opacity(
              //   opacity: _opacity,
              //   child: Text("Your Title"),
              //),
              // bottom: _scrollController.offset >= 100
              //     ? PreferredSize(
              //         preferredSize: Size.fromHeight(50.0),
              //         child: Container(
              //           color: Colors.white,
              //           child: TabBar(
              //             controller: _tabController,
              //             labelColor: Colors.black,
              //             unselectedLabelColor: Colors.grey,
              //             tabs: [
              //               Tab(text: "Tab 1"),
              //               Tab(text: "Tab 2"),
              //               Tab(text: "Tab 3"),
              //             ],
              //           ),
              //         ),
              //       )
              //     : PreferredSize(
              //         preferredSize: Size.fromHeight(10), child: SizedBox()),
            ),
          ],
          body: ListView.builder(
            itemCount: 30,
            itemBuilder: (context, index) =>
                ListTile(title: Text("Item $index")),
          ),
        ),
      ),
    );
  }
}
