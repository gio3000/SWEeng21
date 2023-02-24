import 'package:flutter/material.dart';
import '../utils/constants.dart' as constants;

class ScreenSegment extends StatelessWidget {
  BoxConstraints? constraints;
  VoidCallback? onTap;
  final Widget child;

  ScreenSegment({
    required this.child,
    this.constraints,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(constants.cBorderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(constants.cBorderRadius),
        splashColor: Colors.black54,
        onTap: onTap,
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(constants.cPadding * 2),
            child: child,
          ),
        ),
      ),
    );
  }
}
