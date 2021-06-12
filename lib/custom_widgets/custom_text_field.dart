import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextInput extends StatefulWidget {
  final String title;
  final TextEditingController textEditingController;
  final bool isPassword;

  const CustomTextInput({
    Key key,
    @required this.title,
    @required this.textEditingController,
    this.isPassword = false,
  }) : super(key: key);

  @override
  _CustomTextInput createState() => _CustomTextInput();
}

class _CustomTextInput extends State<CustomTextInput> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 5,
      child: TextField(
        enableSuggestions: false,
        autocorrect: false,
        obscureText: widget.isPassword ? !isVisible : isVisible,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: widget.isPassword
                ? IconButton(
                    icon: isVisible
                        ? const Icon(Icons.visibility, color: Colors.black)
                        : const Icon(Icons.visibility_off_outlined,
                            color: Colors.black),
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    color: Colors.black,
                  )
                : null,
          ),
          contentPadding: const EdgeInsets.all(18),
          hintText: widget.title,
          hintStyle: const TextStyle(
              color: Color.fromRGBO(169, 169, 169, 1),
              fontWeight: FontWeight.normal,
              fontSize: 18),
        ),
      ),
    );
  }
}
