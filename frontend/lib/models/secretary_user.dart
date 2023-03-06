import 'package:frontend/models/user_role.dart';
import 'package:frontend/provider/user.dart';
import 'package:frontend/utils/authenticated_request.dart';

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

  Future<void> insertGrade() async {}

  Future<void> removeGrade() async {}
}
