import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_app/constants/constants.dart';
import 'package:rent_app/utils/size_config.dart';
import 'package:rent_app/utils/validation_mixin.dart';
import 'package:rent_app/widgets/general_alert_dialog.dart';
import 'package:rent_app/widgets/general_text_field.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
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
                textInputAction: TextInputAction.next,
                validate: (value) => ValidationMixin().validatePassword(value!),
                onFieldSubmitted: (_) {},
              ),
              SizedBox(height: SizeConfig.height * 2),
              GeneralTextField(
                title: "Confirm Password",
                isObscure: true,
                controller: confirmPasswordController,
                textInputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                validate: (value) => ValidationMixin().validatePassword(
                    passwordController.text,
                    isConfirmPassword: true,
                    confirmValue: value!),
                onFieldSubmitted: (_) {
                  submit(context);
                },
              ),
              SizedBox(height: SizeConfig.height * 2),
              ElevatedButton(
                onPressed: () async {
                  await submit(context);
                },
                child: Text("Register"),
              ),
            ],
          ),
        )),
      ),
    );
  }

  submit(context) async {
    try {
      if (formKey.currentState!.validate()) {
        final firebaseAuth = FirebaseAuth.instance;
        GeneralAlertDialog().customLoadingDialog(context);
        await firebaseAuth.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);
      var message = "";
      if (ex.code == "email-already-in-use") {
        message = "The email address is already used";
      } else if (ex.code == "weak-password") {
        message = "The password is too weak";
      }
      await GeneralAlertDialog().customAlertDialog(context, message);
    } catch (ex) {
      Navigator.pop(context);
      await GeneralAlertDialog().customAlertDialog(context, ex.toString());
    }
  }
}
