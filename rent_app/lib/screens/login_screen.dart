import 'package:flutter/material.dart';
import 'package:rent_app/constants/constant.dart';
import 'package:rent_app/screens/register_screen.dart';
import 'package:rent_app/utils/size_config.dart';
import 'package:rent_app/widgets/general_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: basePadding,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                ImageConstant.logo,
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
                validate: (value) {},
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
                validate: (value) {},
              ),
              SizedBox(height: SizeConfig.height * 2),
              ElevatedButton(
                onPressed: () {},
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
    );
  }
}
