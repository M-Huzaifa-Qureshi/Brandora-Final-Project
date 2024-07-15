import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splash_practices/custom_widegets/custom_button.dart';

import '../model_classes/checkout_model.dart';

class OrderedDetail extends StatefulWidget {
  final Check? selectedItem;
  const OrderedDetail({this.selectedItem, super.key});

  @override
  State<OrderedDetail> createState() => _OrderedDetailState();
}

class _OrderedDetailState extends State<OrderedDetail> {
  @override
  Widget build(BuildContext context) {
    final double height=  MediaQuery.of(context).size.height;
    final double width=  MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("ordered Detail"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            child: CustomContainer(
              height: height*0.15,
              boxShadow: [
                BoxShadow(
                  color: Colors.purple,
                  spreadRadius: 5,
                  blurStyle: BlurStyle.outer,
                  blurRadius: 5
                )
              ],

              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6,top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text("Email: "+widget.selectedItem!.email.toString()),
                        Text("Name: "+widget.selectedItem!.name.toString()),
                        Text("Contact: "+widget.selectedItem!.contactNo.toString()),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomContainer(
                      image: DecorationImage(image: NetworkImage(widget.selectedItem!.nicImage.toString()),fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(10),
                    ) ),
                ],
              ),
            ),
          ),
        ));
  }
}
