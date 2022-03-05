import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GeneralTextField extends StatefulWidget {
  const GeneralTextField({
    required this.title,
    required this.controller,
    required this.textInputType,
    required this.textInputAction,
    required this.validate,
    this.isObscure = false,
    Key? key,
    this.maxLength,
    this.inputFormatter,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final int? maxLength;
  final bool isObscure;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatter;
  final String? Function(String?)? validate;

  @override
  State<GeneralTextField> createState() => _GeneralTextFieldState();
}

class _GeneralTextFieldState extends State<GeneralTextField> {
  late bool toHide;

  @override
  void initState() {
    super.initState();
    toHide = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.textInputType,
      obscureText: toHide,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        suffixIcon: widget.isObscure
            ? IconButton(
                icon: Icon(
                  toHide
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    toHide = !toHide;
                  });
                },
              )
            : null,
        hintText: "Enter your ${widget.title}",
        counter: const SizedBox.shrink(),
      ),
      controller: widget.controller,
      inputFormatters: widget.inputFormatter,
      maxLength: widget.maxLength,
      validator: widget.validate,
    );
  }
}
