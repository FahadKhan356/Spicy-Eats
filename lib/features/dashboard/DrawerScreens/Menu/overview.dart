import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/controller/registershop_controller.dart';
import 'package:spicy_eats/features/dashboard/DrawerScreens/Menu/ineroverview.dart';
import 'package:spicy_eats/commons/mysnackbar.dart';

class OverviewScreen extends ConsumerStatefulWidget {
  const OverviewScreen({super.key});

  @override
  ConsumerState<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends ConsumerState<OverviewScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final registershopcontroller = ref.read(registershopcontrollerProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: registershopcontroller.fetchrestaurants(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    floatingsnackBar(
                        context: context, text: snapshot.error.toString());
                  } else if (snapshot.hasData && snapshot.data != null) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var data = snapshot.data![index];

                          return InkWell(
                            onTap: () => Navigator.pushNamed(
                                context, InnerOverview.routename,
                                arguments: data.restuid),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: Container(
                                    //margin: EdgeInsets.only(bottom: 0),
                                    height: 250,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors
                                            .white54, // Change to transparent
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
                                          height: 150,
                                          width: double.infinity,
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20), // Ensure the image is also rounded
                                                  child: Image.network(
                                                    width: double.infinity,
                                                    data.restaurantImageUrl!,
                                                    fit: BoxFit
                                                        .cover, // Adjusted for better image fit
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
                                                      decoration:
                                                          const BoxDecoration(
                                                              color:
                                                                  Colors.green,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        20),
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
                                        Center(
                                          child: Text(
                                            data.restaurantName!,
                                            style: TextStyle(
                                                fontSize: size.width * 0.04,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: Text(
                                            data.address!,
                                            style: TextStyle(
                                                fontSize: size.width * 0.03,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  }
                  return const Center(
                    child: Text('There is no restaurants'),
                  );
                }),
          ],
        ),
      ),
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
