import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
          itemCount: 6,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 0),
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.white54, // Change to transparent
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            offset: Offset(3, 2),
                            blurRadius: 6,
                          )
                        ]),
                    child: Column(
                      children: [
                        Container(
                          height: 120,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors
                                .white, // This will be the background color
                            borderRadius: BorderRadius.circular(
                                20), // Round the corners of the container
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      20), // Ensure the image is also rounded
                                  child: Image.network(
                                    'https://img.freepik.com/free-photo/tasty-top-view-sliced-pizza-italian-traditional-round-pizza_90220-1357.jpg',
                                    fit: BoxFit
                                        .contain, // Adjusted for better image fit
                                  ),
                                ),
                              ),
                              Positioned(
                                  right: 0,
                                  top: 0,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                          )),
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Pizza chezious',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          '\$9.0',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
      // Container(
      //   height: 200,
      //   width: 100,
      //   color: Colors.amber,
      //   child: Stack(
      //     children: [
      //       Container(
      //         height: 100,
      //         width: 100,
      //         color: Colors.black12,
      //         child: Image.network(
      //           'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.thespruceeats.com%2Fhamburger-hot-dogs-480688&psig=AOvVaw36BDudAZzRnCbKSgrdtoBP&ust=1727711985125000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCKCZjPDC6IgDFQAAAAAdAAAAABAQ',
      //           fit: BoxFit.cover,
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
