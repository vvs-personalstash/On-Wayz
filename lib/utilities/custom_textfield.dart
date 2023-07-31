import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String label;
  final IconData iconData;
  final String hint;
  final dynamic Keyboard;
  // final VoidCallback onTap;

  const CustomTextField({
    required this.textEditingController,
    required this.label,
    required this.iconData,
    // required this.onTap,
    this.hint = '',
    this.Keyboard = TextInputType.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: Icon(
                iconData,
                color: Color.fromARGB(255, 242, 209, 213),
              )),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                label: Text(label),
                hintStyle: Theme.of(context).textTheme.bodySmall,
                hintText: hint,
              ),
              controller: textEditingController,
              autofillHints: gethints(label),
              keyboardType: Keyboard,
            ),
          ),
        ],
      ),
    );
  }
}

Iterable<String> gethints(String label) {
  if (label == 'Email') {
    return [AutofillHints.email];
  } else if (label == 'Full Name') {
    return [AutofillHints.name];
  } else {
    return [];
  }
}
