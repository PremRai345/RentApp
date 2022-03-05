import 'package:flutter/material.dart';
import '../utils/size_config.dart';

var basePadding = EdgeInsets.symmetric(
  vertical: SizeConfig.height,
  horizontal: SizeConfig.width * 4,
);

class ImageConstant {
  static const _basePath = "assets/images";
  static const logo = "$_basePath/login.png";
}
