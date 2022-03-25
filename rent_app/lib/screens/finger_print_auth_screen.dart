import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rent_app/constants/constants.dart';
import 'package:rent_app/screens/home_screen.dart';
import 'package:rent_app/utils/navigate.dart';
import 'package:rent_app/utils/size_config.dart';
import 'package:rent_app/widgets/curved_body_widget.dart';

class FingerPrintAuthScreen extends StatelessWidget {
  const FingerPrintAuthScreen({
    Key? key,
    required this.username,
    required this.password,
  }) : super(key: key);

  final String username;
  final String password;

  @override
  Widget build(BuildContext context) {
    storeCredentials(context, email: username, password: password);
    return Scaffold(
      appBar: AppBar(title: Text("Finger Print Screen")),
      body: GestureDetector(
        onTap: () {
          print("object");
          storeCredentials(context, email: username, password: password);
        },
        child: CurvedBodyWidget(
            widget: Center(
          child: Column(
            children: [
              Icon(
                Icons.fingerprint_outlined,
                color: Colors.black,
                size: SizeConfig.height * 25,
              ),
              SizedBox(
                height: SizeConfig.height,
              ),
              const Text("Touch the screen to add fingerprint"),
            ],
          ),
        )),
      ),
    );
  }

  storeCredentials(BuildContext context,
      {required String email, required String password}) async {
    final localAuth = LocalAuthentication();
    final authenticate = await localAuth.authenticate(
        localizedReason: "Please place your fingerprint on the sensor",
        biometricOnly: true);

    if (authenticate) {
      const flutterSecureStorage = FlutterSecureStorage();
      await flutterSecureStorage.write(
          key: SecureStorageConstants.emailKey, value: email);
      await flutterSecureStorage.write(
          key: SecureStorageConstants.passwordKey, value: password);
      navigate(context, const HomeScreen());
    }
  }
}
