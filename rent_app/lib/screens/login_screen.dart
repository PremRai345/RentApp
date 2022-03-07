import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_app/constants/constants.dart';
import 'package:rent_app/models/firebase_user.dart';
import 'package:rent_app/screens/home_screen.dart';
import 'package:rent_app/screens/register_screen.dart';
import 'package:rent_app/utils/size_config.dart';
import 'package:rent_app/utils/validation_mixin.dart';
import 'package:rent_app/widgets/general_alert_dialog.dart';
import 'package:rent_app/widgets/general_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: basePadding,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Image.asset(
                  ImageConstants.logo,
                  width: SizeConfig.width * 40,
                  height: SizeConfig.height * 25,
                ),
                SizedBox(
                  height: SizeConfig.height,
                ),
                GeneralTextField(
                  title: "Email",
                  controller: emailController,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validate: (value) => ValidationMixin().validateEmail(value!),
                  onFieldSubmitted: (_) {},
                ),
                SizedBox(
                  height: SizeConfig.height * 2,
                ),
                GeneralTextField(
                  title: "Password",
                  isObscure: true,
                  controller: passwordController,
                  textInputType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  validate: (value) =>
                      ValidationMixin().validatePassword(value!),
                  onFieldSubmitted: (_) {
                    _submit(context);
                  },
                ),
                SizedBox(height: SizeConfig.height * 2),
                ElevatedButton(
                  onPressed: () {
                    _submit(context);
                  },
                  child: const Text("Login"),
                ),
                SizedBox(height: SizeConfig.height * 2),
                const Text("OR"),
                SizedBox(height: SizeConfig.height),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text("Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit(context) async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      final firebaseAuth = FirebaseAuth.instance;
      GeneralAlertDialog().customLoadingDialog(context);
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      final user = userCredential.user;
      if (user != null) {
        FirebaseUser(
          displayName: user.displayName ?? "",
          email: user.email ?? "",
          photoUrl: user.photoURL ?? "",
          uuid: user.uid,
        );
      }
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);
      var message = "";
      if (ex.code == "wrong-password") {
        message = "The password is incorrect";
      } else if (ex.code == "user-not-found") {
        message = "The user is not registered";
      }
      await GeneralAlertDialog().customAlertDialog(context, message);
    } catch (ex) {
      Navigator.pop(context);
      await GeneralAlertDialog().customAlertDialog(context, ex.toString());
    }
  }
}
