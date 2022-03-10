import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_app/constants/constants.dart';
import 'package:rent_app/providers/user_provider.dart';
import 'package:rent_app/screens/profile_screen.dart';
import 'package:rent_app/utils/navigate.dart';
import 'package:rent_app/utils/size_config.dart';
import 'package:rent_app/widgets/curved_body_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final image =
      "https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/07/shiva-1594171271.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Home!"),
      ),
      drawer: Drawer(
          child: Column(
        children: [
          Consumer<UserProvider>(builder: (_, data, __) {
            // data.
            return UserAccountsDrawerHeader(
              accountName: Text(data.user.name ?? "No Name"),
              accountEmail: Text(
                data.user.email ?? "No Email",
              ),
              currentAccountPicture: Hero(
                tag: "image-url",
                child: SizedBox(
                  height: SizeConfig.height * 16,
                  width: SizeConfig.height * 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(SizeConfig.height * 8),
                    child: data.user.image == null
                        ? Image.network(
                            image,
                            fit: BoxFit.cover,
                          )
                        : Image.memory(
                            base64Decode(data.user.image!),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            );
          }),
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
