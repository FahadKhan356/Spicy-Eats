import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/repository/registershop_repository.dart';
import 'package:spicy_eats/features/Restaurant_Menu/widgets/GlassIconButton.dart';
import 'package:spicy_eats/main.dart';

class RestaurantContainer extends ConsumerStatefulWidget {
  final String name;
  final String price;
  final String image;
  final double ratings;
  final int mindeliverytime;
  final int maxdeliverytime;
  final String restid;
  final String userid;

  const RestaurantContainer({
    super.key,
    required this.restid,
    required this.userid,
    required this.name,
    required this.price,
    required this.image,
    required this.ratings,
    required this.mindeliverytime,
    required this.maxdeliverytime,
  });

  @override
  ConsumerState<RestaurantContainer> createState() =>
      _RestaurantContainerState();
}

class _RestaurantContainerState extends ConsumerState<RestaurantContainer> {
  @override
  Widget build(BuildContext context) {
    bool isFav = ref.watch(favoriteProvider)[widget.restid] ?? false;

    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: AspectRatio(
              aspectRatio: 16 / 8,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      errorBuilder: (context, obj, stack) =>
                          const Icon(Icons.image),
                      widget.image,
                      fit: BoxFit.cover,
                      width: double.maxFinite,
                    ),
                  ),
                  Positioned(
                      right: size.width * 0.03,
                      top: size.height * 0.02,
                      child: GlassIconButton(
                        height: 50,
                        width: 50,
                        icon: isFav
                            ? Icons.favorite
                            : Icons.favorite_outline_sharp,
                        iconColor: isFav ? Colors.orange[900] : Colors.white,
                        onTap: () => ref
                            .read(registershoprepoProvider)
                            .togglefavorites(
                                userid: supabaseClient.auth.currentUser!.id,
                                restid: widget.restid,
                                ref: ref,
                                context: context),
                      ))
                ],
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.015,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                            fontSize: size.width * 0.040,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis),
                      ),

                      Row(children: [
                        Icon(
                          Icons.access_time_sharp,
                          color: Colors.black54,
                          size: size.width * 0.05,
                        ),
                        Text(
                          "${widget.mindeliverytime}-${widget.maxdeliverytime} mins",
                          style: TextStyle(
                              fontSize: size.width * 0.035,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "\$${widget.price}",
                          style: TextStyle(
                              fontSize: size.width * 0.035,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                      //   Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [

                      //       Container(
                      //         height: size.width * 0.1,
                      //         width: size.width * 0.1,
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(10),
                      //             color: const Color(0xFFD1C4E9)),
                      //         child: Center(
                      //           child: Text(
                      //             ratings.toString(),
                      //             style: TextStyle(
                      //                 fontSize: size.width * 0.04,
                      //                 color: Colors.black,
                      //                 fontWeight: FontWeight.bold),
                      //           ),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ],
                    ]),
              ),
              Container(
                height: size.width * 0.1,
                width: size.width * 0.1,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.orange[900]),
                child: Center(
                  child: Text(
                    widget.ratings.toString(),
                    style: TextStyle(
                        fontSize: size.width * 0.035,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
