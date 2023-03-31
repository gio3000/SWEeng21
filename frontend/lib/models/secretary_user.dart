import 'package:frontend/models/grade_subject_mapper.dart';
import 'package:frontend/models/user_role.dart';
import 'package:frontend/provider/user.dart';

class Secretary extends User {
  List<String> dummyCourses = ['TIT21', 'TEM22', 'TEK25'];
  List<String> dummyStudents = [
    '123456789',
    '98456789',
    '23456780',
    '18392841',
    '22020202'
  ];

  final int secretaryId;

  final List<String> lecturers = [];

  Secretary({
    required this.secretaryId,
    required int userId,
    required String firstName,
    required String lastName,
    required UserRole role,
    required String email,
  }) : super(
            id: userId,
            firstName: firstName,
            lastName: lastName,
            role: role,
            email: email);

  Future<List<String>> getCourses() async {
    return dummyCourses;
  }

  //TODO add backend connection url
  Future<List<String>> getStudentsFor(String courseName) async {
    return dummyStudents;
  }

  //TODO add backend connection url
  Future<void> removeStudentFromCourse(
      {required String studentName, required String courseName}) async {
    dummyStudents.removeWhere(
      (element) => studentName == element,
    );
    notifyListeners();
  }

  //TODO add backend connection url
  void addStudentToCourse(String matrikelNr, String courseName) async {
    dummyStudents.add(matrikelNr);
    notifyListeners();
  }

  //TODO add backend connection
  void createStudent({
    required String firstName,
    required String lastName,
    required String email,
    required String location,
    required String matrikelNr,
  }) async {
    addStudentToCourse(matrikelNr, '');
  }

  //TODO add backend connection
  Future<void> addCourse({required String courseTitle}) async {
    dummyCourses.add(courseTitle);
    notifyListeners();
  }

  //TODO add backend connection
  Future<void> removeCourse({required String courseTitle}) async {
    dummyCourses.removeWhere((element) => element == courseTitle);
    notifyListeners();
  }

  //TODO add backend connection
  Future<List<String>> getLecturers() async {
    return lecturers;
  }

  //TODO add backend connection
  Future<void> addLecturer({required String lecturerName}) async {
    lecturers.add(lecturerName);
    notifyListeners();
  }

  //TODO add backend connection
  Future<void> removeLecturer({required String lecturerName}) async {
    lecturers.removeWhere((element) => element == lecturerName);
    notifyListeners();
  }

  //TODO add backend connection
  Future<List<GradeSubjectMapper>> getAllModules() async {
    return [
      GradeSubjectMapper(
        subjectName: 'Sysprog',
        grade: 0,
        examDate: DateTime.now(),
        creditPoints: 3,
        isCompleted: true,
      ),
      GradeSubjectMapper(
        subjectName: 'Mathe',
        grade: 0,
        examDate: DateTime.now(),
        creditPoints: 9,
        isCompleted: true,
      ),
      GradeSubjectMapper(
        subjectName: 'Python',
        grade: 0,
        examDate: DateTime.now(),
        creditPoints: 5,
        isCompleted: true,
      ),
    ];
  }

  //TODO add backend connection
  Future<void> insertGrade(
      String studentName, GradeSubjectMapper newGradeMapper) async {}

  //TODO add backend connection
  Future<void> removeGrade(
      String studentName, GradeSubjectMapper toRemoveGradeData) async {}
}
