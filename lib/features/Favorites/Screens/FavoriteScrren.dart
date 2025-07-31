import 'package:flutter/material.dart';

class Favoritescrren extends StatelessWidget {
  static const String routename = '/favorite';

  const Favoritescrren({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Favorites',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (conttxt, index) => favoriteContainer(context))),
    );
  }
}

Widget favoriteContainer(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    width: double.maxFinite,
    padding: const EdgeInsets.all(8.0), // Add some padding
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(color: Colors.black12, spreadRadius: 0.1, blurRadius: 2),
      ],
      color: Colors.white,
    ),
    child: Row(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Allow content to expand vertically
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            'https://assets.epicurious.com/photos/63e221469cd8e164fe127588/1:1/pass/0201023-make-ahead-egg-and-cheese-sandwiches-lede.jpg',
            width: width * 0.18,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Cheese Burger',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 0.1,
                            blurRadius: 2),
                      ],
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.favorite, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'A fresh cheese burger filled with fresh meat and vegetables',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '\$20.00',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: width * 0.08,
                    width: width * 0.26,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.orange[900],
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(width * 0.035 / 2),
                        ),
                      ),
                      onPressed: () {},
                      child: Text('Add To Cart',
                          style: TextStyle(
                              fontSize: width * 0.02, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
