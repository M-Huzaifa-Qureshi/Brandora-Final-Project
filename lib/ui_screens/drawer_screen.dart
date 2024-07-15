import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splash_practices/auth_screens/login_screen.dart';
import 'package:splash_practices/custom_widegets/customText.dart';
import 'package:splash_practices/custom_widegets/custom_button.dart';
import 'package:splash_practices/model_classes/pics_entity.dart';
import 'package:splash_practices/ui_screens/floating_screen.dart';
import 'package:splash_practices/ui_screens/myitem.dart';
import 'package:splash_practices/ui_screens/orderd_screen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Drawer(
      width: width * 0.6,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FloatingScreen(),
                    ),
                  );
                },
                child: FirebaseAuth.instance.currentUser!.email ==
                        "huzaifa@gmail.com"
                    ? CustomContainer(
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 5,
                            blurStyle: BlurStyle.outer,
                            spreadRadius: 5,
                            color: Colors.purple,
                          )
                        ],
                        alignment: Alignment.center,
                        height: height * 0.17,
                        conColor: Colors.purple,
                        shape: BoxShape.circle,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.add_circled,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(height: 5),
                            CustomText(
                              text: "Add Product",
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ),
              SizedBox(height: height*0.02),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderedScreen(),));
                },
                child: FirebaseAuth.instance.currentUser!.email=="huzaifa@gmail.com"?
                CustomContainer(
                  alignment:Alignment.center,
                   borderRadius: BorderRadius.circular(10),
                  width: double.infinity,
                  height: height * 0.08,
                  conColor: Colors.purple,
                  child: const CustomText(
                    text: "Ordered",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ):const SizedBox(),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyItem(),));
                },
                child: FirebaseAuth.instance.currentUser!.email=="huzaifa@gmail.com"?CustomContainer(
                  alignment:Alignment.center,
                  borderRadius: BorderRadius.circular(10),
                  width: double.infinity,
                  height: height * 0.08,
                  conColor: Colors.purple,
                  child: const CustomText(
                    text: "My Items ",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ): SizedBox(
                  width: double.infinity,
                  height: height * 0.08,),
              ),
              // ListView.builder(
              //   scrollDirection: Axis.vertical,
              //   shrinkWrap: true,
              //   itemCount: 3,
              //   itemBuilder: (context, index) {
              //     return Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 5),
              //       child: CustomContainer(
              //         conColor: Colors.purple,
              //         alignment: Alignment.center,
              //         borderRadius: BorderRadius.circular(10),
              //         height: height * 0.08,
              //         child: const CustomText(text: "Add Product",color: Colors.white,),
              //       ),
              //     );
              //   },
              // ),

            ],
          ),
        ),
      ),
    );
  }
}
