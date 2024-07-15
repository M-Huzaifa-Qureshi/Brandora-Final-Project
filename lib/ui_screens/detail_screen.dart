import 'package:another_flushbar/flushbar.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splash_practices/custom_widegets/customText.dart';
import 'package:splash_practices/custom_widegets/custom_button.dart';
import 'package:splash_practices/model_classes/pics_entity.dart';
import 'package:splash_practices/provider_classes/add_cart.dart';
import 'cart_screen.dart';

class DetailScreen extends StatefulWidget {
  final PicsEntity? data;
  const DetailScreen({super.key, this.data});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}
class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    initializing();
  }
  initializing() {
    final cartProvider = Provider.of<AddCart>(context, listen: false);
    // Initialize item count and price
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.data != null) {
        cartProvider.initializeItem(widget.data!.price!);
      }
    });
  }

  void showFlushbar(BuildContext context, String title, String message,
      FlushbarPosition position, double blur, EdgeInsets yes,
      {Color? backgroundColor}) {
    Flushbar(
      boxShadows: const [
        BoxShadow(
          color: Colors.purple,
          blurRadius: 5,
          blurStyle: BlurStyle.outer,
          spreadRadius: 6

        ),
      ],
      padding: yes,
      barBlur: blur,
      flushbarPosition: position,
      title: title,
      message: message,
      duration: Duration(seconds: 3),
      backgroundColor: backgroundColor ?? Colors.black,
    ).show(context);
  }
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<AddCart>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Detail Screen"),
        actions: [
          Consumer<AddCart>(
            builder: (context, cartProvider, child) {
              return badges.Badge(
                position: badges.BadgePosition.topEnd(top: 0, end: 3),
                badgeContent: Text(
                  cartProvider.cartItems.length.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Cart()),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart_rounded),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: CustomContainer(
              shape: BoxShape.circle,
              height: height * 0.4,
              boxShadow: const [
                BoxShadow(
                  color: Colors.purple,
                  spreadRadius: 5,
                  blurStyle: BlurStyle.outer,
                  blurRadius: 10,
                ),
              ],
              width: double.infinity,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.data!.image.toString())),
              child: const Center(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomContainer(
              height: height * 0.5,
              width: double.infinity,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.09),
                    Row(
                      children: [
                        CustomText(text: 'Name: ${widget.data!.name}'),
                        Spacer(),
                        CustomContainer(
                          conColor: Colors.purple,
                          height: 30,
                          width: 30,
                          borderRadius: BorderRadius.circular(5),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                cartProvider
                                    .incrementItemCount(widget.data!.price!);
                                cartProvider.updateCartItem(
                                    widget.data!.name!,
                                    cartProvider.itemCount,
                                    widget.data!.price!);
                              },
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        CustomText(text: '${cartProvider.itemCount}'),
                        SizedBox(width: 10),
                        CustomContainer(
                          conColor: Colors.purple,
                          height: 30,
                          width: 30,
                          borderRadius: BorderRadius.circular(5),
                          child: GestureDetector(
                            onTap: () {
                              cartProvider
                                  .decrementItemCount(widget.data!.price!);
                              cartProvider.updateCartItem(widget.data!.name!,
                                  cartProvider.itemCount, widget.data!.price!);
                            },
                            child: const Icon(
                              CupertinoIcons.minus,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    CustomText(
                        text:
                            'Price: \$${cartProvider.totalPrice.toStringAsFixed(2)}'),
                    const SizedBox(height: 60),
                    const CustomText(
                      text: "Description",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    CustomText(text: widget.data!.descController.toString()),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        CartProduct item = CartProduct(
                          quantity: cartProvider.itemCount,
                          price: widget.data!.price!,
                          name: widget.data!.name,
                          imageUrl: widget.data!.image,
                        );
                        if (cartProvider
                            .itemInCart(widget.data!.name.toString())) {
                          showFlushbar(
                              backgroundColor: Colors.purple,
                              context,
                              "Cart",
                              "Already in Cart",
                              FlushbarPosition.TOP,
                              40,
                              EdgeInsets.all(30));
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(content: Text("Already in cart")),
                          // );
                        } else {
                          cartProvider.add(item);
                          showFlushbar(
                              backgroundColor: Colors.purple,
                              context,
                              "Add Card",
                              "Add in to Cart",
                              FlushbarPosition.TOP,
                              30,EdgeInsets.all(30));
                        }
                      },
                      child: CustomContainer(
                        alignment: Alignment.center,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(30),
                        height: height * 0.07,
                        conColor: Colors.purple,
                        child: const CustomText(
                          text: "Add to Cart",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
