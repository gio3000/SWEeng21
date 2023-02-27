import 'package:flutter/material.dart';
import '../utils/constants.dart' as constants;

class CourseListTile extends StatelessWidget {
  final String title;
  const CourseListTile({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(constants.cBorderRadius),
      child: Card(
        elevation: 2,
        child: InkWell(
            onTap: () {
              //TODO
            },
            borderRadius: BorderRadius.circular(constants.cBorderRadius),
            child: Padding(
              padding: const EdgeInsets.all(constants.cPadding * 2),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87),
                ),
              ),
            )),
      ),
    );
  }
}
