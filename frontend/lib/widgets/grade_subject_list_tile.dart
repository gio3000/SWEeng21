import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart' as constants;
import 'package:frontend/models/grade_subject_mapper.dart';

class GradeSubjectListTile extends StatelessWidget {
  final GradeSubjectMapper mapper;
  const GradeSubjectListTile({
    required this.mapper,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(constants.cBorderRadius),
      ),
      elevation: 2,
      child: ListTile(
        title: Text(mapper.subjectName),
        subtitle: Text(
          DateFormat.yMd().format(mapper.examDate),
        ),
        trailing: Text(
          mapper.grade.toString(),
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
    );
  }
}
