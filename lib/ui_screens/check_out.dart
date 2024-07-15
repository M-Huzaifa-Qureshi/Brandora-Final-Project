import 'dart:async';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:splash_practices/custom_widegets/customText.dart';
import 'package:splash_practices/custom_widegets/custom_button.dart';
import 'package:splash_practices/custom_widegets/custom_field.dart';
import 'package:splash_practices/model_classes/checkout_model.dart';
import 'package:splash_practices/model_classes/pics_entity.dart';
import '../provider_classes/add_cart.dart';
class CheckOut extends StatefulWidget {
  final PicsEntity? cardData;
  const CheckOut({this.cardData, super.key});
  @override
  State<CheckOut> createState() => _CheckOutState();
}
class _CheckOutState extends State<CheckOut> {
  bool isLoading = false;
  File? pickImage;
  String? imageUrl;
  String? notificationTitle;
  final _form = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final contactNoController = TextEditingController();
  final emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    fetchData();
  }
  Future<void> fetchData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('userEntity') // Assuming your user collection is named 'users'
          .doc(uid)
          .get();
      setState(() {
        notificationTitle = userDoc['userName']; // Fetching notification title
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
  Future<void> getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        pickImage = File(image.path);
      }
    });
  }
  void showNotification(String title) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        actionType: ActionType.Default,
        title: title,
        body: 'Your order was successfully placed!',
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    AddCart providerCart = Provider.of<AddCart>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Check Out"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    getImage();
                  },
                  child: pickImage != null
                      ? CircleAvatar(
                    foregroundColor: Colors.deepPurple,
                    backgroundImage: FileImage(pickImage!),
                    radius: 100,
                  )
                      : const CircleAvatar(
                    radius: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo),
                        Text("Your Profile Picture")
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomField(
                  controller: nameController,
                  labelText: "Full Name",
                  hinText: "Enter Full Name",
                  border:OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                validator: (value){
                  if(value!.isEmpty){
                    return "Enter your Email ";
                  }
                  return null;
                },
                ),
                const SizedBox(height: 10),
                CustomField(
                  controller: emailController,
                  labelText: "Email",
                  hinText: "Enter your Email",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter your Email ";
                    }if(!EmailValidator.validate(value)){
                      return "Please Enter valid Email";
                    }return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomField(
                  controller: contactNoController,
                  labelText: "Contact",
                  hinText: "Enter your contact number",
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
               validator: (value){
                 if(value!.isEmpty){
                   return "Enter your Email ";
                 }
                 return null;
               },
                ),
                const SizedBox(height: 10),
                CustomField(
                  controller: addressController,
                  labelText: "Address",
                  hinText: "Enter your address",
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                validator: (value){
                  if(value!.isEmpty){
                    return "Enter your Email ";
                  }
                  return null;
                },
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    if(!_form.currentState!.validate()){
                      return ;
                    }
                    String uid = FirebaseAuth.instance.currentUser!.uid;
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      final ref =
                      FirebaseStorage.instance.ref('/CheckImages/$uid');
                      await ref.putFile(pickImage!);
                      imageUrl = await ref.getDownloadURL();
                      String id = PicsEntity.collection().id;
                      Check order = Check(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          address: addressController.text.trim(),
                          contactNo: contactNoController.text.trim(),
                          nicImage: imageUrl!,
                          checkID: uid,
                          selectedItem: providerCart.cartItems.map((item) {
                            return {
                              "Date": DateTime.now(),
                              'image': item.imageUrl,
                              'total price': item.price,
                              'name': item.name,
                              'quantity': item.quantity
                            };
                          }).toList());
                      await Check.doc(checkId: id).set(order);
                      setState(() {
                        isLoading = false;
                      });
                      showNotification(notificationTitle ?? 'Order Notification');
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Order placed successfully!")));
                    } catch (e) {
                      print(e.toString());
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: CustomContainer(
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(30),
                    conColor: Colors.purple,
                    height: height * 0.08,
                    width: double.infinity,
                    child: isLoading
                        ? const CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    )
                        : const CustomText(
                      text: "Order Now",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
