import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:splash_practices/custom_widegets/customText.dart';
import 'package:splash_practices/custom_widegets/custom_button.dart';
import 'package:splash_practices/model_classes/checkout_model.dart';
import 'package:splash_practices/ui_screens/ordered_detail.dart';

class OrderedScreen extends StatefulWidget {
  const OrderedScreen({super.key});

  @override
  State<OrderedScreen> createState() => _OrderedScreenState();
}

class _OrderedScreenState extends State<OrderedScreen> {
  Stream<QuerySnapshot<Check>> orderedData = Check.collection().snapshots();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Ordered Screen"),
      ),
      body:Padding(
        padding:  const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: orderedData,
          builder: (context, AsyncSnapshot<QuerySnapshot<Check>> snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return  const CircularProgressIndicator();
            }else if (snapshot.hasError){
              return const Center(child: CustomText(text: "Error Occured"),);
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Check check = snapshot.data!.docs[index].data();
                List<dynamic> selectedItem = check.selectedItem;
                return CustomContainer(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.purple,
                        spreadRadius: 5,
                        blurStyle: BlurStyle.outer,
                        blurRadius: 5
                    )
                  ],
                  child: Card(
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6,top: 6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Text("Quantity: "'${selectedItem[index]['quantity']}'),
                               Text("Item: "+selectedItem[index]['name']),
                               Text("Total price: "+'${selectedItem[index]['total price']}'),
                             InkWell(
                                 onTap: () {
                                   Navigator.push(context,MaterialPageRoute(builder: (context) => OrderedDetail(selectedItem:snapshot.data!.docs[index].data(),),),);

                             }, child: CustomText(text: "Detail"))
                             ],
                          ),
                        ),
                        SizedBox(width: width*0.1),
                        Expanded(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(image: NetworkImage(selectedItem[index]['image'],
                              ),
                                fit: BoxFit.fill
                              )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );



              },
            );
          },
        ),
      ),
    );
  }
}
