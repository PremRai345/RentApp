import 'package:flutter/material.dart';
import 'package:rent_app/constants/constants.dart';
import 'package:rent_app/screens/profile_screen.dart';
import 'package:rent_app/utils/navigate.dart';
import 'package:rent_app/utils/size_config.dart';
import 'package:rent_app/widgets/curved_body_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final image =
      "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Home!"),
      ),
      drawer: Drawer(
          child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Prem"),
            accountEmail: const Text(
              "prem@gmail.com",
            ),
            currentAccountPicture: Hero(
              tag: "image-url",
              child: CircleAvatar(
                backgroundImage: NetworkImage(image),
              ),
            ),
            // currentAccountPictureSize: Size.fromHeight(
            //   SizeConfig.height * 5,
            // ),
          ),
          ListTile(
            title: const Text("Profile"),
            trailing: const Icon(
              Icons.arrow_right_outlined,
            ),
            onTap: () => navigate(
              context,
              ProfileScreen(
                imageUrl: image,
              ),
            ),
          )
        ],
      )),
      body: CurvedBodyWidget(
        widget: SingleChildScrollView(
          child: Column(
            children: [
              Text("Rent App"),
            ],
          ),
        ),
      ),
    );
  }
}
