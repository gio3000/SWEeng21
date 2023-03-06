import 'package:frontend/models/grade_subject_mapper.dart';
import 'package:frontend/models/user_role.dart';
import 'package:frontend/provider/user.dart';

class Student extends User {
  final List<GradeSubjectMapper> grades = [];

  Student({
    required String id,
    required String firstName,
    required String lastName,
    required UserRole role,
    required String email,
  }) : super(
            id: id,
            firstName: firstName,
            lastName: lastName,
            role: role,
            email: email);

  Future<List<GradeSubjectMapper>> getGrades() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      GradeSubjectMapper(
        subjectName: 'Sysprog',
        grade: 5.0,
        examDate: DateTime.now(),
      ),
      GradeSubjectMapper(
        subjectName: 'Mathe',
        grade: 1.6,
        examDate: DateTime.now(),
      ),
      GradeSubjectMapper(
        subjectName: 'Python',
        grade: 3.0,
        examDate: DateTime.now(),
      ),
      GradeSubjectMapper(
        subjectName: 'C++',
        grade: 2.0,
        examDate: DateTime.now(),
      ),
    ];
  }
}
