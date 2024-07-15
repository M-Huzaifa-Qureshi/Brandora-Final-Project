import 'dart:ui';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splash_practices/custom_widegets/customText.dart';
import 'package:splash_practices/custom_widegets/spin_kit.dart';
import 'package:splash_practices/model_classes/pics_entity.dart';
import 'package:splash_practices/ui_screens/detail_screen.dart';
import 'drawer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  List<DocumentSnapshot<PicsEntity>> filterData = [];
  late Stream<QuerySnapshot<PicsEntity>> data;
  final currentUser = FirebaseAuth.instance.currentUser!.email;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterData);
    data = PicsEntity.collection().snapshots();
  }

  @override
  void dispose() {
    searchController.removeListener(_filterData);
    searchController.dispose();
    super.dispose();
  }

  void _filterData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("HomeScreen"),
        automaticallyImplyLeading: currentUser == "huzaifa@gmail.com",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder<QuerySnapshot<PicsEntity>>(
            stream: data,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loadingIndicator();
              } else if (snapshot.hasError) {
                return Center(child: Text("Error occurred: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No data available"));
              }

              filterData = snapshot.data!.docs.where((doc) {
                return doc
                    .data()
                    .name!
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase());
              }).toList();

              return Column(
                children: [
                  AnimSearchBar(
                    width: 400,
                    textController: searchController,
                    onSuffixTap: () {
                      searchController.clear();
                    },
                    onSubmitted: (p0) {},
                  ),
                  GridView.builder(
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filterData.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 7,
                      mainAxisSpacing: 7,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      return Card(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(filterData[index]
                                  .data()!
                                  .image
                                  .toString()),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.only(
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
                                    Text("Item: ${filterData[index].data()!.name}"),
                                    Text("Price: \$${filterData[index].data()!.price}"),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailScreen(
                                              data: snapshot.data!.docs[index].data(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const CustomText(
                                        text: "Detail",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
      drawer: currentUser == "huzaifa@gmail.com" ? const DrawerScreen() : null,
    );
  }
}
