import 'package:flutter/material.dart';
import 'package:rent_app/constants/constants.dart';
import 'package:rent_app/utils/size_config.dart';

class CurvedBodyWidget extends StatelessWidget {
  const CurvedBodyWidget({required this.widget, Key? key}) : super(key: key);

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.height * 100,
        width: SizeConfig.width * 100,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
          color: Colors.white,
        ),
        padding: basePadding,
        child: widget);
  }
}
