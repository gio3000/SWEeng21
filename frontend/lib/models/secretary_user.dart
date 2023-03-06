import 'package:frontend/models/grade_subject_mapper.dart';
import 'package:frontend/models/user_role.dart';
import 'package:frontend/provider/user.dart';

class Secretary extends User {
  List<String> courses = ['TIT21', 'TEM22', 'TEK25'];
  final List<String> lecturers = [];

  Secretary({
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

  Future<List<String>> getCourses() async {
    // await AuthHttp.get('TODO');
    return courses;
  }

  Future<List<String>> getStudentsFor(String courseName) async {
    return ['123456789', '12456789', '2345678', '345', '22'];
  }

  Future<void> removeStudentFromCourse(
      {required String studentName, required String courseName}) async {
    //TODO AuthHttp
    notifyListeners();
  }

  void addStudentToCourse(String studentName, String courseName) async {
    //TODO AuthHttp
    notifyListeners();
  }

  void createStudent({
    required String firstName,
    required String lastName,
    required String email,
    required String location,
    required String matrikelNr,
  }) async {
    //TODO AuthHttp.post();
  }

  Future<void> addCourse({required String courseTitle}) async {
    // await AuthHttp.post('TODO');
    courses.add(courseTitle);
    notifyListeners();
  }

  Future<void> removeCourse({required String courseTitle}) async {
    // await AuthHttp.post('TODO');
    courses.removeWhere((element) => element == courseTitle);
    notifyListeners();
  }

  Future<List<String>> getLecturers() async {
    // await AuthHttp.post('TODO');
    return lecturers;
  }

  Future<void> addLecturer({required String lecturerName}) async {
    // await AuthHttp.post('TODO');
    lecturers.add(lecturerName);
    notifyListeners();
  }

  Future<void> removeLecturer({required String lecturerName}) async {
    // await AuthHttp.post('TODO');
    lecturers.removeWhere((element) => element == lecturerName);
    notifyListeners();
  }

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

  Future<void> insertGrade() async {}

  Future<void> removeGrade() async {}
}
