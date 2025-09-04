import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spicy_eats/commons/consts.dart';
import 'package:spicy_eats/features/Cusines/model/CusinesModel.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';

class CusinesList extends ConsumerStatefulWidget {
  final List<CusinesModel>? cusineList;
  const CusinesList({super.key, required this.cusineList});

  @override
  ConsumerState<CusinesList> createState() => _CusinesListState();
}

Future<void> filterCusines({
  required int cusineId,
  required WidgetRef ref,
}) async {
  ref.read(isloaderProvider.notifier).state = true;

  // await Future.delayed(const Duration(seconds: 2)); // fake delay

  final restList = ref.read(restaurantlistProvider);

  final filteredList = restList
      .where((restaurant) =>
          restaurant.cuisineIds != null &&
          restaurant.cuisineIds!.contains(cusineId))
      .toList();

  ref.read(restaurantDisplayListProvider.notifier).state = filteredList;

  ref.read(isloaderProvider.notifier).state = false; // stop loading here
}

class _CusinesListState extends ConsumerState<CusinesList> {
  @override
  Widget build(
    BuildContext context,
  ) {
    final isLoading = ref.watch(isloaderProvider);

    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.width * 0.5,
      width: double.infinity,
      // color: Colors.red,
      child: Skeletonizer(
        ignorePointers: true,
        ignoreContainers: true,
        enabled: isLoading,
        enableSwitchAnimation: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                ref.read(isloaderProvider.notifier).state = true;
                Future.delayed(const Duration(seconds: 2));

                // Reset back to full list
                ref.read(restaurantDisplayListProvider.notifier).state =
                    ref.read(restaurantlistProvider);

                ref.read(isloaderProvider.notifier).state = false;
              },
              child: const Text(
                'Reset',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.cusineList?.length, //cusines.length,
                itemBuilder: ((context, index) => Column(
                      children: [
                        widget.cusineList != null
                            ? InkWell(
                                onTap: () async {
                                  if (!mounted) return;
                                  await filterCusines(
                                    ref: ref,
                                    cusineId: widget.cusineList![index].id,
                                  );
                                  debugPrint(
                                      'cusine index : ${widget.cusineList![index].id}');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Container(
                                    width: size.width * 0.12,
                                    height: size.width * 0.12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                            245, 124, 0, 1), // 🔸 border color
                                        width: 4, // border thickness
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(widget
                                            .cusineList![index].cusineImage),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                        widget.cusineList != null
                            ? Text(
                                widget.cusineList![index].cusineName,
                                style: TextStyle(
                                    fontSize: size.width * 0.03,
                                    fontWeight: FontWeight.w500),
                              )
                            : const SizedBox()
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
