import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:splash_practices/auth_screens/signup_screen.dart';
import 'package:splash_practices/custom_widegets/customText.dart';
import 'package:splash_practices/custom_widegets/custom_button.dart';
import 'package:splash_practices/custom_widegets/custom_field.dart';
import 'package:splash_practices/model_classes/user_entity.dart';
import 'package:splash_practices/ui_screens/bottomnav_bar.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isLoading1 = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipPath(
                    clipper: WaveClipperOne(),
                    child: const CustomContainer(
                      alignment: Alignment.center,
                      height: 120,
                      conColor: Colors.purple,
                      width: double.infinity,
                      child: CustomText(
                        text: "Login",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.11),
                  const CustomText(
                    text: "Login Your Account",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 30),
                  CustomField(
                    controller: emailController,
                    labelText: "Enter your email",
                    hinText: "Email",
                    border: OutlineInputBorder(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your Email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomField(
                    controller: passwordController,
                    border: const OutlineInputBorder(),
                    hinText: 'Enter your password',
                    labelText: "Password",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your Password";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () async {
                      if (!_formKey.currentState!.validate()) return;
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BottomNavBar(),
                          ),
                        );
                      } catch (e) {
                        print('Error during email/password sign-in: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Login failed: ${e.toString()}')),
                        );
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    child: CustomContainer(
                      alignment: Alignment.center,
                      conColor: Colors.purple,
                      height: height * 0.07,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(30),
                      child: isLoading
                          ? CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      )
                          : CustomText(
                        text: "Login",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      await _signInWithGoogle();
                    },
                    child:CustomContainer(
                      alignment: Alignment.center,
                      conColor: Colors.purple,
                      height: height * 0.07,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(30),
                      child: isLoading1
                          ? const CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      )
                          : ListTile(
                        leading:Image.asset('images/goo.png'),
                        title: CustomText(text: "Login With Google",color: Colors.white,),
                      ),
                    )
                  ),

                  SizedBox(height: height * 0.06),
                  Row(
                    children: [
                      Expanded(
                        child: ClipPath(
                          clipper: WaveClipperOne(reverse: true),
                          child: CustomContainer(
                            conColor: Colors.purple,
                            height: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CustomText(
                                  text: "Don't have an account?",
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const SignUp(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "SignUp",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      isLoading1 = true;
    });
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          isLoading1 = false;
        });
        return; // User cancelled the sign-in process
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('userEntity').doc(user.uid).get();
        if (!docSnapshot.exists) {
          userEntity newUser = userEntity(
            userId: user.uid,
            email: user.email!,
            userName: user.displayName!,
          );
          await FirebaseFirestore.instance.collection('userEntity').doc(user.uid).set(newUser.toJson());
        }

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavBar(),
            ),
          );
        }
      }
    } catch (e) {
      print('Error during Google sign-in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading1= false;
      });
    }
  }
}
