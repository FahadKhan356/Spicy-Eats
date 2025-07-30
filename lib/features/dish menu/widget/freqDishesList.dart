import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/dishmenuVariation.dart';

class Freqdisheslist extends ConsumerWidget {
  final double screenSize;
  final List<DishData> freqList;

  const Freqdisheslist(
      {super.key, required this.screenSize, required this.freqList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: freqList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 280, crossAxisCount: 2),
      itemBuilder: (context, index) {
        final fetchedItem = freqList[index];
        final provierItem = ref.watch(freqDishesProvider) ?? [];
        final selected =
            provierItem.any((element) => element.dishid == fetchedItem.dishid);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 6,
                  color: Colors.black12,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image and Favorite icon
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        fetchedItem.dish_imageurl!,
                        // 'https://assets.epicurious.com/photos/5c745a108918ee7ab68daf79/1:1/pass/Smashburger-recipe-120219.jpg',
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Positioned(
                      right: 8,
                      top: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 14, color: Colors.black87),
                            SizedBox(width: 4),
                            Text('31 min', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  fetchedItem.dish_name!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 14),
                    SizedBox(width: 4),
                    Text('4.8', style: TextStyle(fontSize: 12)),
                    Text(' (22+)',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '\$0 Delivery fee over \$26',
                  style: TextStyle(fontSize: 11, color: Colors.red),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        fetchedItem.dish_discount != null
                            ? Text(
                                fetchedItem.dish_discount.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenSize * 0.025,
                                    color: Colors.black),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          width: 10,
                        ),
                        Stack(
                          children: [
                            Text(
                              fetchedItem.dish_price.toString(),
                              style: TextStyle(
                                fontSize: screenSize * 0.025,
                                color: Colors.grey[600],
                              ),
                            ),
                            Positioned(
                              top: 0.8 * (screenSize * 0.025),
                              // adjust based on text size
                              child: Container(
                                width: 50, // adjust to match text width
                                height: 1.5,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        final updatedList = [...provierItem];

                        if (!selected) {
                          updatedList.add(DishData(
                            isVariation: false,
                            dishid: fetchedItem.dishid,
                            dish_description: fetchedItem.dish_description,
                            dish_price: fetchedItem.dish_price,
                            dish_discount: fetchedItem.dish_discount,
                            dish_imageurl: fetchedItem.dish_imageurl,
                            dish_name: fetchedItem.dish_name,
                            dish_schedule_meal: '',
                          ));
                        } else {
                          updatedList.removeWhere(
                              (item) => item.dishid == fetchedItem.dishid);
                        }
                        ref.read(freqDishesProvider.notifier).state =
                            updatedList;
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: 30,
                            height: 30,
                            color: selected ? Colors.black : Colors.orange[900],
                            child: selected
                                ? const Center(
                                    child: Icon(
                                      Icons.check_sharp,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
