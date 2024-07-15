import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../custom_widegets/customText.dart';
import '../custom_widegets/spin_kit.dart';
import '../model_classes/pics_entity.dart';

class MyItem extends StatefulWidget {
  const MyItem({super.key});

  @override
  State<MyItem> createState() => _MyItemState();
}

class _MyItemState extends State<MyItem> {
  Stream<QuerySnapshot<PicsEntity>> myItem = PicsEntity.collection().snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:  StreamBuilder(
        stream: myItem,
        builder:
            (context, AsyncSnapshot<QuerySnapshot<PicsEntity>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text("Error occurred: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No data available"));
          }
          return GridView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 7,
                mainAxisSpacing: 7,
                childAspectRatio: 0.7),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(snapshot.data!.docs[index]
                            .data()
                            .image
                            .toString()))),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    height: 70,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("item  :  "+snapshot.data!.docs[index].data().name.toString()),
                          Text("price : ${snapshot.data!.docs[index].data().price}"),
                          InkWell(
                            onTap:(){
                              setState(() {
                                PicsEntity.collection().doc(snapshot.data!.docs[index].id).delete();

                              });
                            },
                            child: Icon(Icons.delete)),
                        ],

                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
