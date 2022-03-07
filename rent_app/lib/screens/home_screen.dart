import 'package:flutter/material.dart';
import 'package:rent_app/constants/constants.dart';
import 'package:rent_app/screens/profile_screen.dart';
import 'package:rent_app/utils/navigate.dart';
import 'package:rent_app/utils/size_config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Home!"),
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      drawer: Drawer(
          child: Column(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text(
              "Prem",
            ),
            accountEmail: Text(
              " prem@gmail.com",
            ),
          ),
          ListTile(
            title: Text("Profile"),
            trailing: Icon(Icons.person),
            onTap: navigate(context, ProfileScreen()),
          ),
        ],
      )),
      body: Container(
        height: SizeConfig.height * 100,
        width: SizeConfig.width * 100,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          color: Colors.white,
        ),
        padding: basePadding,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Rent App",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
