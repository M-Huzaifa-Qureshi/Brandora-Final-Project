import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../custom_widegets/customText.dart';
import '../custom_widegets/custom_button.dart';
import '../model_classes/checkout_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Stream<QuerySnapshot<Check>> orderedData = Check.collection()
      .where("checkID", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("History Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: orderedData,
          builder: (context, AsyncSnapshot<QuerySnapshot<Check>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Center(
                child: CustomText(text: "Error Occured"),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Check check = snapshot.data!.docs[index].data();
                List<dynamic> selectedItem = check.selectedItem;
                // String timeFormat = DateFormat("dd MM yyy").format(selectedItem[index]["Date"]);
                return CustomContainer(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.purple,
                        spreadRadius: 5,
                        blurStyle: BlurStyle.outer,
                        blurRadius: 5)
                  ],
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6, top: 6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Quantity: "
                                  '${selectedItem[index]['quantity']}'),
                              Text("Item: " '${selectedItem[index]['name']}'),
                              Text("Total price: "
                                  '${selectedItem[index]['total price']}'),
                              Text(
                                  "Date: ${DateFormat('dd MMM yyyy, hh:mm a').format((selectedItem[index]['Date'] as Timestamp).toDate())}"),
                            ],
                          ),
                        ),
                        SizedBox(width: width * 0.1),
                        Expanded(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: NetworkImage(
                                      selectedItem[index]['image'],
                                    ),
                                    fit: BoxFit.fill)),
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
    ;
  }
}
