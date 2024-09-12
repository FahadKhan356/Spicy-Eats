import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spicy_eats/commons/restaurantModel.dart';
import 'package:spicy_eats/commons/restaurant_container.dart';
import 'package:spicy_eats/features/Home/screens/homedrawer.dart';
import 'package:spicy_eats/features/Home/screens/widgets/cusineslist.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/restaurant_menu.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routename = '/homescreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationcontroller;
  late Animation<double> _animationbody;
  bool clicked = false;

  @override
  void initState() {
    super.initState();
    _animationcontroller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animationbody = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationcontroller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationcontroller.dispose();
    super.dispose();
  }

  void onclick() {
    if (clicked) {
      _animationcontroller.forward();
    } else {
      _animationcontroller.reverse();
    }
  }

  Future<List<Restaurant>> readjsondata() async {
    final data =
        await rootBundle.loadString('lib/assets/data/restaurants.json');
    final list = jsonDecode(data) as List<dynamic>;
    return list.map((e) => Restaurant.fromjson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      appBar: AppBar(
        title: Center(
            child: Column(
          children: [
            Text(
              'Delivering to',
              style: GoogleFonts.aBeeZee(fontSize: 22),
            ),
            Text(
              'Riyadh-Saudi Arabia',
              style: TextStyle(
                // GoogleFonts.aBeeZee(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        )),
        actions: [
          Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                // color: const Color(0xFFD1C4E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.shopping_cart,
                size: 26,
              )),
        ],
        leading: IconButton(
          onPressed: () {
            setState(() {
              clicked = !clicked;
              onclick();
            });
          },
          icon: const Icon(Icons.menu),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[300],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CusinesList(),
          Expanded(
            child: Stack(
              children: [
                RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _animationbody,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_animationbody.value * 100, 0),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(
                                (_animationbody.value * 20) * math.pi / 180),
                          child: child,
                        ),
                      );
                    },
                    child: FutureBuilder(
                      future: readjsondata(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(child: Text("Error"));
                        } else if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: ((context, index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      RestaurantMenu.routename,
                                      arguments: snapshot.data![index],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: RestaurantContainer(
                                        name: snapshot.data![index].name,
                                        price: snapshot.data![index].deliveryFee
                                            .toString(),
                                        image: snapshot.data![index].image,
                                        mindeliverytime: snapshot
                                            .data![index].minDeliveryTime,
                                        maxdeliverytime: snapshot
                                            .data![index].maxDeliveryTime,
                                        ratings: snapshot.data![index].rating,
                                      ),
                                    ),
                                  ),
                                )),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _animationbody,
                  builder: (BuildContext context, Widget? child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-1, 0), // Starting position
                        end: Offset.zero, // Ending position
                      ).animate(_animationbody),
                      child: const HomeDrawer(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
