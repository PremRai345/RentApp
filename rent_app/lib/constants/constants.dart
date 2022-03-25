import 'package:flutter/material.dart';
import 'package:rent_app/utils/size_config.dart';

var basePadding = EdgeInsets.symmetric(
  vertical: SizeConfig.height,
  horizontal: SizeConfig.width * 4,
);

class ImageConstants {
  static const _basePath = "assets/images";
  static const logo = "$_basePath/logo.png";
  static const pdfDownload = "$_basePath/pdf_download.png";

  static const notificationIcon = "notification";
}

class UserConstants {
  static const userCollection = "user";
  static const userId = "uuid";
}

class UtilitiesPriceConstant {
  static const utilityPriceCollection = "utilities-price";
  static const userId = "uuid";
}

class RoomConstant {
  static const roomCollection = "room";
  static const userId = "uuid";
}

class RoomRentConstant {
  static const roomRentCollection = "room-rent";
  static const roomId = "roomId";
}

class MonthConstant {
  static const monthList = [
    "Baisakh",
    "Jestha",
    "Ashar",
    "Sharwan",
    "Bhadra",
    "Ashoj",
    "Kartik",
    "Mangsir",
    "Poush",
    "Magh",
    "Falgun",
    "Chaitra"
  ];
}

class SecureStorageConstants {
  static const emailKey = "email";
  static const passwordKey = "password";
}
