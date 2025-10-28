import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Cart/model/Cartmodel.dart';


import 'package:spicy_eats/features/Cart/repository/CartRepository.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';

class BasketCard extends ConsumerStatefulWidget {
  const BasketCard({
    super.key,
    this.cardHeight,
    required this.elevation,
    required this.cardColor,
    required this.dish,
    required this.imageHeight,
    required this.imageWidth,
    required this.cartItem,
    required this.userId,
    required this.isCartScreen,
    required this.quantityIndex,
    this.addbuttonHeight,
    this.addbuttonWidth,
    this.buttonIncDecHeight,
    this.buttonIncDecWidth,
    required this.titleVariationList,
  });
  final double? cardHeight;
  final double? elevation;
  final Color? cardColor;
  final DishData? dish;
  final double? imageHeight;
  final double? imageWidth;
  final Cartmodel? cartItem;
  final String? userId;
 final bool? isCartScreen;
  final int? quantityIndex;
  final double? addbuttonHeight;
  final double? addbuttonWidth;
  final double? buttonIncDecHeight;
  final double? buttonIncDecWidth;
  final List<VariattionTitleModel>? titleVariationList;

  @override
  ConsumerState<BasketCard> createState() => _CartCardState();
}

class _CartCardState extends ConsumerState<BasketCard> {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  build(BuildContext context) {
    final cartRepo = ref.read(cartReopProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        surfaceTintColor: Colors.white,
        elevation: widget.elevation ?? 2,
        color: widget.cardColor ?? Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: Colors.grey[100],
                  height: widget.imageHeight ?? 70,
                  width: widget.imageWidth ?? 70,
                  child: Image.network(
                    widget.cartItem!.image.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              const SizedBox(width: 10),
              
              // Details Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.cartItem!.name.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      '\$${widget.cartItem?.tprice?.toStringAsFixed(2) ?? ''}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    
                    // Variations
                    if (widget.cartItem!.variation != null && 
                        widget.cartItem!.variation!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: widget.cartItem!.variation!.map((e) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                e.variationPrice == 0
                                    ? '${e.variationName}'
                                    : '${e.variationName} +\$${e.variationPrice}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black87,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Quantity Controls
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        _debouncer.run(() {
                          cartRepo.incQuantity(
                            ref: ref,
                            cartId: widget.cartItem!.cart_id!,
                            price: widget.cartItem!.itemprice!,
                          );
                        });
                      },
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    
                    Container(
                      height: 28,
                      width: 32,
                      alignment: Alignment.center,
                      child: Text(
                        ref
                            .read(cartProvider.notifier)
                            .state[widget.quantityIndex!]
                            .quantity
                            .toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    
                    InkWell(
                      onTap: () {
                        _debouncer.run(() async {
                          cartRepo.decQuantity(
                            ref: ref,
                            cartId: widget.cartItem!.cart_id!,
                            price: widget.cartItem!.itemprice!,
                          );
                        });
                      },
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Icon(
                          widget.cartItem!.quantity == 1
                              ? Icons.delete_outline
                              : Icons.remove,
                          size: 18,
                          color: Colors.black87,
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