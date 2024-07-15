import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splash_practices/custom_widegets/customText.dart';
import 'package:splash_practices/model_classes/checkout_model.dart';
import 'package:splash_practices/ui_screens/check_out.dart';
import '../provider_classes/add_cart.dart';

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<AddCart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cartProvider.cartItems.length,
        itemBuilder: (context, index) {
          final item = cartProvider.cartItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: Card(
              child: ListTile(
               trailing: CircleAvatar(
                 backgroundImage:  NetworkImage(item.imageUrl!) ),
                title: Text(item.name!),
                subtitle: Text('Quantity: ${item.quantity}\nPrice: \$${(item.price)}'),
              ),
            ),
          );
        },
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 75,
        child: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOut(),));
          },
          child: Center(
            child: CustomText(text:"Check out",color: Colors.white   ,),
          ),

        ),
      ),
    );
  }
}
