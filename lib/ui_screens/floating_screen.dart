import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:splash_practices/custom_widegets/customText.dart';
import 'package:splash_practices/custom_widegets/custom_button.dart';
import 'package:splash_practices/custom_widegets/custom_field.dart';
import 'package:splash_practices/model_classes/pics_entity.dart';
import 'package:splash_practices/ui_screens/home_screen.dart';

class FloatingScreen extends StatefulWidget {
  const FloatingScreen({super.key});
  @override
  State<FloatingScreen> createState() => _FloatingScreenState();
}

class _FloatingScreenState extends State<FloatingScreen> {
  bool isloading  = false;
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final descController = TextEditingController();
  String? imageUrl;
  File? pickedImage;
  Future<void> getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    setState(() {
      if (image != null) {
        pickedImage = File(image.path);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    getImage(ImageSource.gallery);
                  },
                  child: pickedImage != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(pickedImage!),
                          radius: 50,
                        )
                      : const CircleAvatar(
                          child: Icon(Icons.add_a_photo),
                          radius: 50,
                        ),
                ),
                const SizedBox(height: 20),
                CustomField(
                  border: OutlineInputBorder(),
                  controller: _nameController,
                  labelText: 'Enter your name',
                  hinText: 'Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomField(
                  border: OutlineInputBorder(),
                  controller: _priceController,
                  labelText: 'Enter the price',
                  hinText: 'Price',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomField(
                  maxLines: 6,
                  border: OutlineInputBorder(),
                  controller: descController,
                  hinText: 'Description',
                  labelText: "Type here",
                  validator: (p0) {},
                ),
                const SizedBox(height: 60),
                InkWell(
                  onTap: ()async {
                    setState(() {
                      isloading= true;
                    });

                      try {
                        String id = PicsEntity.collection().doc().id;
                        // Upload image to Firebase Storage
                        final ref = FirebaseStorage.instance.ref('/PicsImages/$id');
                        await ref.putFile(pickedImage!);
                        imageUrl = await ref.getDownloadURL();
                        print('Image uploaded: $imageUrl');
                        // Create and upload PicsEntity to Firestore
                        PicsEntity pics = PicsEntity(
                          name: _nameController.text.trim(),
                          price: double.tryParse(_priceController.text.trim()),
                          image: imageUrl!,
                          descController: descController.text.trim(),
                          userId: id,
                        );
                        await PicsEntity.doc(picsId: id).set(pics);
                        print('Data uploaded to Firestore');
                        _nameController.clear();
                        _priceController.clear();
                        imageUrl = "";
                        descController.clear();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));
                      } catch (e) {
                        print('Error: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                      finally{
                        setState(() {
                          isloading=false;
                        });
                      }
                    },
                  child: CustomContainer(
                    width: double.infinity,
                    alignment: Alignment.center,
                    height: height * 0.07,
                    borderRadius: BorderRadius.circular(30),
                    conColor: Colors.purple,
                    child: isloading?const CircularProgressIndicator(backgroundColor: Colors.white,):const CustomText(
                      text: "Submit",
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
