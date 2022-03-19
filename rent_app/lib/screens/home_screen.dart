import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_app/constants/constants.dart';
import 'package:rent_app/providers/room_provider.dart';
import 'package:rent_app/providers/user_provider.dart';
import 'package:rent_app/screens/list_room_screen.dart';
import 'package:rent_app/screens/profile_screen.dart';
import 'package:rent_app/screens/room_screen.dart';
import 'package:rent_app/screens/utilities_price_screen.dart';
import 'package:rent_app/utils/navigate.dart';
import 'package:rent_app/utils/size_config.dart';
import 'package:rent_app/widgets/curved_body_widget.dart';
import 'package:rent_app/widgets/general_alert_dialog.dart';
import 'package:rent_app/widgets/general_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final image =
      "https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/07/shiva-1594171271.jpg";

  @override
  Widget build(BuildContext context) {
    final future =
        Provider.of<RoomProvider>(context, listen: false).fetchRoom(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Home!"),
        actions: [
          IconButton(
            onPressed: () async {
              final roomName =
                  await GeneralBottomSheet().customBottomSheet(context);
              // print(roomName);
              if (roomName != null) {
                try {
                  GeneralAlertDialog().customLoadingDialog(context);
                  await Provider.of<RoomProvider>(context, listen: false)
                      .addRoom(context, roomName);
                  Navigator.pop(context);
                  Navigator.pop(context);
                } catch (ex) {
                  Navigator.pop(context);
                  GeneralAlertDialog()
                      .customAlertDialog(context, ex.toString());
                }
              }
            },
            icon: const Icon(
              Icons.add_outlined,
            ),
          )
        ],
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
          buildListTile(
            context,
            label: "Profile",
            widget: ProfileScreen(imageUrl: image),
          ),
          SizedBox(
            height: SizeConfig.height,
          ),
          buildListTile(
            context,
            label: "Utilities Price",
            widget: UtilitiesPriceScreen(),
          ),
          SizedBox(
            height: SizeConfig.height,
          ),
          buildListTile(
            context,
            label: "List of Rooms",
            widget: ListRoomScreen(),
          ),
        ],
      )),
      body: CurvedBodyWidget(
        widget: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final listOfRoom = Provider.of<RoomProvider>(
                context,
              ).listOfRoom;
              return listOfRoom.isEmpty
                  ? const Center(
                      child: Text("You do not have any rooms!"),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Rooms",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          SizedBox(
                            height: SizeConfig.height,
                          ),
                          GridView.builder(
                            itemCount: listOfRoom.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 2,
                              mainAxisSpacing: SizeConfig.height,
                              crossAxisSpacing: SizeConfig.width * 4,
                            ),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () => navigate(context,
                                    RoomScreen(room: listOfRoom[index])),
                                child: Card(
                                  color: Colors.red.shade200,
                                  child: Center(
                                    child: Text(
                                      listOfRoom[index].name,
                                    ),
                                  ),
                                ),
                              );
                            },
                            shrinkWrap: true,
                          )
                        ],
                      ),
                    );
            }),
      ),
    );
  }

  Widget buildListTile(
    BuildContext context, {
    required String label,
    required Widget widget,
  }) {
    return ListTile(
      title: Text(label),
      trailing: const Icon(
        Icons.arrow_right_outlined,
      ),
      onTap: () => navigate(context, widget),
    );
  }
}
