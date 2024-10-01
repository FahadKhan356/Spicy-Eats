import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/commons/mysnackbar.dart';
import 'package:spicy_eats/features/Home/controller/homecontroller.dart';

class InnerOverview extends ConsumerStatefulWidget {
  final String? restuid;
  static const String routename = '/inneroverview';
  InnerOverview({super.key, required this.restuid});

  @override
  ConsumerState<InnerOverview> createState() => _InnerOverviewState();
}

class _InnerOverviewState extends ConsumerState<InnerOverview> {
  @override
  Widget build(BuildContext context) {
    var homecontroller = ref.read(homeControllerProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        const Text(
          'Dishes',
          style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        FutureBuilder(
            future: homecontroller.fetchDishes(restuid: widget.restuid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                floatingsnackBar(
                    context: context, text: snapshot.error.toString());
              } else if (snapshot.hasData && snapshot.data != null) {
                return GridView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) {
                      var data = snapshot.data![index];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 0),
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                  color:
                                      Colors.white54, // Change to transparent
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
                                              data.dish_imageurl!,
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
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      bottomLeft:
                                                          Radius.circular(20),
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

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Text(
                                      data.dish_name!,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  // const SizedBox(
                                  //   height: 10,
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Text(
                                      data.dish_price.toString(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              }
              return const Center(
                child: Text('There is no dishes'),
              );
            })
      ]),
    );
  }
}
