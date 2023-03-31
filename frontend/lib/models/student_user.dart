import 'package:frontend/models/grade_subject_mapper.dart';
import 'package:frontend/models/user_role.dart';
import 'package:frontend/provider/user.dart';
import '../utils/db_constants.dart' as db;
import '../utils/constants.dart' as c;

class Student extends User {
  final List<GradeSubjectMapper> dummyGrades = [];

  final int studentId;

  Student({
    required int userId,
    required String firstName,
    required String lastName,
    required UserRole role,
    required String email,
    required this.studentId,
  }) : super(
            id: userId,
            firstName: firstName,
            lastName: lastName,
            role: role,
            email: email);

  Future<List<GradeSubjectMapper>> getCompletedGrades() async {
    //TODO first idea of backend connection
    //fetch and filter exams
    // final res =
    //     await AuthHttp.get('http://homenetwork-test.ddns.net:5160/api/exam');
    // if (res.statusCode >= 400) return [];
    // List<dynamic> parsedAllExams = json.decode(res.body);
    // final completedStudentsExams = parsedAllExams
    //     .where((element) =>
    //         element[db.studentId] == studentId &&
    //         element[db.firstTryKey] != null)
    //     .toList();
    // List<GradeSubjectMapper> mappedExams = completedStudentsExams
    //     .map((e) => GradeSubjectMapper(
    //         subjectName: e[db.lectureTableName][db.lectureNameKey],
    //         grade: getCorrectGradeFromMap(e),
    //         creditPoints: e[db.lectureTableName]?[db.moduleTableName]
    //                 ?[db.ctsKey] as int? ??
    //             0,
    //         isCompleted: getCorrectGradeFromMap(e) > 0.9))
    //     .toList();
    // return mappedExams;

    await Future.delayed(const Duration(seconds: 1));
    return const [
      GradeSubjectMapper(
        subjectName: 'Sysprog',
        grade: 5.0,
        creditPoints: 5,
        isCompleted: true,
      ),
      GradeSubjectMapper(
        subjectName: 'Mathe',
        grade: 1.6,
        creditPoints: 3,
        isCompleted: true,
      ),
      GradeSubjectMapper(
        subjectName: 'Python',
        grade: 3.0,
        creditPoints: 4,
        isCompleted: true,
      ),
      GradeSubjectMapper(
        subjectName: 'C++',
        grade: 2.0,
        creditPoints: 9,
        isCompleted: true,
      ),
    ];
  }

  Future<List<GradeSubjectMapper>> getAllPossibleSubjects() async {
    //TODO first idea of backend connection
    // final res =
    //     await AuthHttp.get('http://homenetwork-test.ddns.net:5160/api/exam');
    // if (res.statusCode >= 400) return [];
    // List<dynamic> parsedAllExams = json.decode(res.body);
    // final completedStudentsExams = parsedAllExams
    //     .where((element) => element[db.studentId] == studentId)
    //     .toList();
    // List<GradeSubjectMapper> mappedExams = completedStudentsExams
    //     .map((e) => GradeSubjectMapper(
    //         subjectName: e[db.lectureTableName][db.lectureNameKey],
    //         grade: getCorrectGradeFromMap(e),
    //         creditPoints:
    //             e[db.lectureTableName][db.moduleTableName][db.ctsKey] as int? ??
    //                 0,
    //         isCompleted: getCorrectGradeFromMap(e) > 0.9))
    //     .toList();
    // return mappedExams;

    return const [
      GradeSubjectMapper(
        subjectName: 'Sysprog',
        grade: 5.0,
        creditPoints: 5,
        isCompleted: true,
      ),
      GradeSubjectMapper(
        subjectName: 'Mathe',
        grade: 1.6,
        creditPoints: 3,
        isCompleted: true,
      ),
      GradeSubjectMapper(
        subjectName: 'Python',
        grade: 3.0,
        creditPoints: 4,
        isCompleted: true,
      ),
      GradeSubjectMapper(
        subjectName: 'C++',
        grade: 2.0,
        creditPoints: 9,
        isCompleted: true,
      ),
      GradeSubjectMapper(
        subjectName: 'Workflow',
        grade: 0,
        creditPoints: 2,
        isCompleted: false,
      ),
      GradeSubjectMapper(
        subjectName: 'Datenbanken',
        grade: 0,
        creditPoints: 5,
        isCompleted: false,
      ),
      GradeSubjectMapper(
        subjectName: 'Elektronik',
        grade: 0,
        creditPoints: 3,
        isCompleted: false,
      ),
    ];
  }

  ///returns the latest grade of a lecture from the map
  ///if no grade is set zero is returned
  double getCorrectGradeFromMap(Map<String, Object?> map) {
    if (map[db.thirdTryKey] != null) {
      return c.percentageToGrade(map[db.thirdTryKey] as int? ?? 0);
    }
    if (map[db.secondTryKey] != null) {
      return c.percentageToGrade(map[db.secondTryKey] as int? ?? 0);
    }
    if (map[db.firstTryKey] != null) {
      return c.percentageToGrade(map[db.firstTryKey] as int? ?? 0);
    }
    return 0.0;
  }
}
