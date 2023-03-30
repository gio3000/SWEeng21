import 'package:frontend/models/grade_subject_mapper.dart';
import 'package:frontend/models/user_role.dart';
import 'package:frontend/provider/user.dart';

class Student extends User {
  final List<GradeSubjectMapper> dummyGrades = [];

  //TODO set id when backend works
  int studentId = -1;

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

  Future<List<GradeSubjectMapper>> getCompletedGrades() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      GradeSubjectMapper(
        subjectName: 'Sysprog',
        grade: 5.0,
        examDate: DateTime.now(),
        creditPoints: 5,
        isCompleted: true,
      ),
      GradeSubjectMapper(
        subjectName: 'Mathe',
        grade: 1.6,
        examDate: DateTime.now().subtract(const Duration(days: 20)),
        creditPoints: 3,
        isCompleted: true,
      ),
      GradeSubjectMapper(
        subjectName: 'Python',
        grade: 3.0,
        examDate: DateTime.now().add(const Duration(days: 30)),
        creditPoints: 4,
        isCompleted: true,
      ),
      GradeSubjectMapper(
        subjectName: 'C++',
        grade: 2.0,
        examDate: DateTime.now().add(const Duration(days: 60)),
        creditPoints: 9,
        isCompleted: true,
      ),
    ];
  }

  Future<List<GradeSubjectMapper>> getAllPossibleSubjects() async {
    return [
      GradeSubjectMapper(
        subjectName: 'Sysprog',
        grade: 5.0,
        examDate: DateTime.now(),
        creditPoints: 5,
        isCompleted: true,
      ),
      GradeSubjectMapper(
        subjectName: 'Mathe',
        grade: 1.6,
        examDate: DateTime.now(),
        creditPoints: 3,
        isCompleted: true,
      ),
      GradeSubjectMapper(
        subjectName: 'Python',
        grade: 3.0,
        examDate: DateTime.now(),
        creditPoints: 4,
        isCompleted: true,
      ),
      GradeSubjectMapper(
        subjectName: 'C++',
        grade: 2.0,
        examDate: DateTime.now(),
        creditPoints: 9,
        isCompleted: true,
      ),
      GradeSubjectMapper(
        subjectName: 'Workflow',
        grade: 0,
        examDate: DateTime.now(),
        creditPoints: 2,
        isCompleted: false,
      ),
      GradeSubjectMapper(
        subjectName: 'Datenbanken',
        grade: 0,
        examDate: DateTime.now(),
        creditPoints: 5,
        isCompleted: false,
      ),
      GradeSubjectMapper(
        subjectName: 'Elektronik',
        grade: 0,
        examDate: DateTime.now(),
        creditPoints: 3,
        isCompleted: false,
      ),
    ];
  }
}
