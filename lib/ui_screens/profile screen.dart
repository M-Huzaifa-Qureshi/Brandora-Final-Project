import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:splash_practices/auth_screens/login_screen.dart';
import '../custom_widegets/customText.dart';
import '../custom_widegets/custom_button.dart';

import '../model_classes/user_entity.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? pickedImage;
  String? imageUrl;

  Future<void> getImage(Function setState, ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);

    setState(() {
      if (image != null) {
        pickedImage = File(image.path);
      }
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>? editProfile;

  @override
  void initState() {
    super.initState();
    String userId = FirebaseAuth.instance.currentUser!.uid;
    editProfile = FirebaseFirestore.instance
        .collection("editprofile")
        .doc(userId)
        .snapshots();
  }

  // var userInformation = userEntity.collection().doc().snapshots();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: userEntity.doc(userId: FirebaseAuth.instance.currentUser!.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text("No data available"),
              );
            }
            return Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        editImage();
                      },
                      child: editProfile != null
                          ? StreamBuilder(
                        stream: editProfile,
                        builder: (context,
                            AsyncSnapshot<
                                DocumentSnapshot<
                                    Map<String, dynamic>>>
                            snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData ||
                              !snapshot.data!.exists) {
                            return const Icon(
                              Icons.person,
                              size: 50,
                            );
                          }

                          return Image(
                            image: NetworkImage(snapshot.data!['profileimag'] ?? ""),
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill,
                          );
                        },
                      )
                          : const Icon(
                        Icons.person,
                        size: 50,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Your Email: ${snapshot.data!.data()!.email ?? ""}"),
                          Text("Your Name: ${snapshot.data!.data()!.userName ?? ""}"),
                        ],
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                                },
                                child: const CustomText(text: "Yes"),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const CustomText(text: "No"),
                              ),
                            ],
                          ),
                          title: const CustomText(text: "Are you sure you want to logout?"),
                        );
                      },
                    );
                  },
                  child: const Card(
                    child: ListTile(
                      leading: Text("Sign out"),
                      trailing: Icon(Icons.logout),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void editImage() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              title: const Text("Add your image if you want"),
              actions: [
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    child: InkWell(
                      onTap: () {
                        getImage(setState, ImageSource.gallery);
                      },
                      child: pickedImage != null
                          ? CustomContainer(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: FileImage(File(pickedImage!.path)),
                            fit: BoxFit.fill),
                      )
                          : const Icon(Icons.image),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: CustomContainer(
                    alignment: Alignment.center,
                    height: 50,
                    width: 100,
                    boxShadow: const [
                      BoxShadow(color: Colors.purple, blurRadius: 5)
                    ],
                    borderRadius: BorderRadius.circular(30),
                    conColor: Colors.purple,
                    child: InkWell(
                      onTap: () async {
                        String userid = FirebaseAuth.instance.currentUser!.uid;
                        await FirebaseStorage.instance
                            .ref("editprofile")
                            .child(userid)
                            .putFile(pickedImage!);
                        imageUrl = await FirebaseStorage.instance
                            .ref('editprofile')
                            .child(userid)
                            .getDownloadURL();
                        await FirebaseFirestore.instance
                            .collection("editprofile")
                            .doc(userid)
                            .set({
                          'profileimag': imageUrl,
                        });

                        Navigator.pop(context);
                      },
                      child: const CustomText(text: "Add"),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
