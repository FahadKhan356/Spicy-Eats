import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/logic/Dummylogics.dart';
import 'package:spicy_eats/commons/CartCard.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/main.dart';
import 'package:spicy_eats/tabexample.dart/tabexample.dart';

class DummyBasket extends ConsumerStatefulWidget {
  List<DishData> dishes = [];
  static const String routename = "/Dummy_basket";
  String restuid;
  DummyBasket({
    super.key,
    //required this.cart,
    required this.dishes,
    required this.restuid,
  });
  // List<CartModelNew> cart = [];

  @override
  ConsumerState<DummyBasket> createState() => _DummyBasketState();
}

class _DummyBasketState extends ConsumerState<DummyBasket> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userId = supabaseClient.auth.currentUser!.id;
    var carttotalamount = ref.read(DummyLogicProvider).getTotalPrice(ref);
    final cart = ref.watch(cartProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pushNamed(
              context,
              MyFinalScrollScreen.routename,
              arguments: widget.restuid,
            ),
          ),
          title: const Text(
            'Your Basket',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              // Scrollable ListView
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cart.length,
                        itemBuilder: (context, index) {
                          final cartitem = cart[index];
                          final dishindex = widget.dishes.firstWhere(
                            (dish) => dish.dishid == cart[index].dish_id,
                          );
                          return CartCard(
                              cardHeight: 120,
                              elevation: 5,
                              cardColor: Colors.white,
                              dish: dishindex,
                              imageHeight: 50,
                              imageWidth: 50,
                              cartItem: cartitem,
                              userId: userId,
                              isCartScreen: false,
                              quantityIndex: index);
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Sticky "Total" Section at the Bottom

              Container(
                height: 250,
                width: double.maxFinite,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                ),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Total',
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Products'),
                        Text('\$12.33'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total'),
                        Text(
                          '\$${carttotalamount}',
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 60,
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            "PROCEED TO CHECKOUT",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
