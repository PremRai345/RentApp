import 'package:flutter/material.dart';
import 'package:rent_app/utils/size_config.dart';

var basePadding = EdgeInsets.symmetric(
  vertical: SizeConfig.height,
  horizontal: SizeConfig.width * 4,
);

class ImageConstants {
  static const _basePath = "assets/images";
  static const logo = "$_basePath/login.jpg";
}
