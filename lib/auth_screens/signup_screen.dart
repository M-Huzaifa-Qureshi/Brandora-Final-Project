import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:splash_practices/auth_screens/login_screen.dart';
import 'package:splash_practices/custom_widegets/customText.dart';
import 'package:splash_practices/custom_widegets/custom_button.dart';
import 'package:splash_practices/custom_widegets/custom_field.dart';
import 'package:splash_practices/model_classes/user_entity.dart';
import '../ui_screens/bottomnav_bar.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final _formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ClipPath(
                            clipper: WaveClipperOne(reverse:false),
                            child: CustomContainer(
                              alignment: Alignment.center,
                              conColor: Colors.purple,
                              height: 120,
                              // width: double.infinity,
                              child: CustomText(
                                text: "Create your Account",
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height*0.11),
                    CustomField(
                      controller: nameController,
                      border: const OutlineInputBorder(),
                      hinText: "Enter Your name",
                      labelText: "Name",
                      validator: (p0) {
                        if(p0!.isEmpty){
                          return "Enter your Name";

                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomField(
                      controller: emailController,
                      border: const OutlineInputBorder(),
                      hinText: "Enter your email",
                      labelText: "Email",
                      validator: (p0) {
                        if(p0!.isEmpty){
                          return "Enter your Email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomField(
                      controller: passwordController,
                      border: const OutlineInputBorder(),
                      hinText: "Enter Your Password",
                      labelText: "password",
                      validator: (p0) {
                        if(p0!.isEmpty){
                          return "Enter your password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        if(!_formkey.currentState!.validate()){
                          return;
                        }
                        setState(() {
                          setState(() {
                            isLoading = true;
                          });
                        });
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim());
                          String id = FirebaseAuth.instance.currentUser!.uid;
                          userEntity user = userEntity(
                              userId: id,
                              email: emailController.text.trim(),
                              userName: nameController.text.trim());
                          await userEntity.doc(userId: id).set(user);
                          if (FirebaseAuth.instance.currentUser!.email ==
                              "huzaifa@gmail.com") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BottomNavBar(),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BottomNavBar(),
                              ),
                            );
                          }
                        } catch (e) {
                          Text(e.toString());
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: isLoading
                          ? const CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            )
                          : CustomContainer(
                              alignment: Alignment.center,
                              conColor: Colors.purple,
                              height: height * 0.09,
                              width: double.infinity,
                              child: const CustomText(
                                  color: Colors.white, text: "Sign up")),
                    ),
                    SizedBox(height: height * 0.07),
                    Row(
                      children: [
                        Expanded(
                          child: ClipPath(
                            clipper: WaveClipperOne(reverse: true),
                            child: CustomContainer(
                              conColor: Colors.purple,
                              height: 120,
                              // width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const CustomText(
                                    text: "Login your Account?",
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>const LoginScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Login",
                                        style: TextStyle(color: Colors.white),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
        
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}


