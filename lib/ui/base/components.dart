import 'dart:io';

import 'package:flutter/material.dart';

Widget getTextField(
  String hint, {
  Function? onTextChanged,
  int maxLines = 1,
  TextEditingController? controller,
}) =>
    TextField(
      onChanged: (text) {
        onTextChanged?.call(text);
      },
      controller: controller,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
      ),
    );

Widget getDivider({double? height}) {
  return Divider(
    height: height,
  );
}

class BottomModalSheet extends StatelessWidget {
  const BottomModalSheet({
    Key? key,
    this.child,
    this.showHandle = true,
  }) : super(key: key);

  final Widget? child;
  final bool showHandle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: 8, left: 8, right: 8, bottom: Platform.isAndroid ? 8.0 : 4.0),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.all(Radius.circular(Platform.isAndroid ? 26.0 : 40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle) _buildHandle(context),
          if (child != null) child!
        ],
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    final theme = Theme.of(context);
    return FractionallySizedBox(
      widthFactor: 0.25,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          height: 5.0,
          decoration: BoxDecoration(
            color: theme.dividerColor,
            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
          ),
        ),
      ),
    );
  }
}

void showModal(context, Widget? child) {
  FocusScope.of(context).requestFocus(FocusNode());
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
    ),
    builder: (context) {
      return BottomModalSheet(
        child: SizedBox(
          child: child!,
          height: MediaQuery.of(context).size.height / 2,
        ),
      );
    },
  );
}
