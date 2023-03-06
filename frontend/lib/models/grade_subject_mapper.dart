class GradeSubjectMapper {
  final String subjectName;
  final double grade;
  final DateTime examDate;
  final int creditPoints;
  final bool isCompleted;

  const GradeSubjectMapper({
    required this.subjectName,
    required this.grade,
    required this.examDate,
    required this.creditPoints,
    required this.isCompleted,
  });
}
