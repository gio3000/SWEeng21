import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/models/grade_subject_mapper.dart';
import 'package:frontend/models/student_user.dart';
import 'package:frontend/provider/authorization_provider.dart';
import 'package:frontend/provider/user.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/student/student_grade_overview_screen.dart';
import 'package:frontend/screens/student/student_statistics_screen.dart';
import 'package:frontend/widgets/change_password.dart';
import 'package:frontend/widgets/grade_subject_list_tile.dart';
import 'package:frontend/widgets/screen_segment.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../utils/constants.dart' as constants;

class StudentScreen extends StatefulWidget {
  static const routeName = "/student";
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  static const _logoutValue = 'logout';
  static const _changePasswordValue = 'changePassword';
  late List<GradeSubjectMapper> gradeSubjectMapperList = [];
  bool _isLoading = true;

  @override
  void initState() {
    (Provider.of<User>(context, listen: false) as Student)
        .getCompletedGrades()
        .then((value) {
      setState(() {
        gradeSubjectMapperList = value;
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) => Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard - Student'),
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                if (value == _logoutValue) {
                  Provider.of<AuthorizationProvider>(context, listen: false)
                      .logout();
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                  return;
                }
                if (value == _changePasswordValue) {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const ChangePassowrd());
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: _changePasswordValue,
                  child: const Text('Passwort ändern'),
                  onTap: () {
                    //TODO
                  },
                ),
                const PopupMenuItem(
                  value: _logoutValue,
                  child: Text('Abmelden'),
                ),
              ],
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(constants.cPadding),
          child: Row(
            children: [
              SizedBox(
                  width: constraints.maxWidth / 2,
                  child: _buildLeftSide(context, constraints)),
              _buildRightSide(context),
            ],
          ),
        ),
      ),
    );
  }

  ///Build the right hand side of the screen
  Widget _buildRightSide(BuildContext context) {
    return Expanded(
      child: ScreenSegment(
        onTap: () {
          Navigator.of(context).pushNamed(StudentOverViewScreen.routeName);
        },
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Notenübersicht",
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FaIcon(
                    FontAwesomeIcons.arrowRight,
                    color: Colors.black54,
                  ),
                ]),
            _isLoading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  )
                : Expanded(
                    child: gradeSubjectMapperList.isEmpty
                        ? const Center(
                            child:
                                Text('Du hast noch keine Noten eingetragen!'),
                          )
                        : ListView(
                            children: gradeSubjectMapperList
                                .map((mapper) =>
                                    GradeSubjectListTile(mapper: mapper))
                                .toList()),
                  ),
          ],
        ),
      ),
    );
  }

  //Build the left hand side of the screen
  Widget _buildLeftSide(BuildContext context, BoxConstraints constraints) {
    return Column(
      children: [
        ScreenSegment(
          onTap: () => Navigator.of(context)
              .pushNamed(StudentStatisticsScreen.routeName),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Statistiken",
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FaIcon(
                  FontAwesomeIcons.arrowRight,
                  color: Colors.black54,
                ),
              ],
            ),
            _isLoading
                ? SizedBox(
                    height: constraints.maxHeight / 2 - 50,
                    child: const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  )
                : gradeSubjectMapperList.isEmpty
                    ? SizedBox(
                        height: constraints.maxHeight / 2 - 50,
                        child: const Center(
                          child: Text('Du hast noch keine Noten eingetragen!'),
                        ),
                      )
                    : GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushNamed(StudentStatisticsScreen.routeName),
                        child: SizedBox(
                          height: constraints.maxHeight / 2 - 50,
                          child: IgnorePointer(
                            ignoring: true,
                            child: SfCircularChart(
                              series: [
                                DoughnutSeries<GradeSubjectMapper, String>(
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                  explode: false,
                                  radius: '70%',
                                  xValueMapper:
                                      (GradeSubjectMapper mapper, _) =>
                                          mapper.subjectName,
                                  yValueMapper:
                                      (GradeSubjectMapper mapper, _) =>
                                          5.1 - mapper.grade,
                                  dataLabelMapper:
                                      (GradeSubjectMapper mapper, _) =>
                                          mapper.subjectName,
                                  dataSource: gradeSubjectMapperList,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
          ]),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ScreenSegment(
            onTap: () {
              //TODO
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Notendurchschnittsrechner',
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FaIcon(
                      FontAwesomeIcons.arrowRight,
                      color: Colors.black54,
                    ),
                  ],
                ),
                _isLoading
                    ? const Expanded(
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      )
                    : const Expanded(
                        child: Center(
                          child: FittedBox(
                            child: FaIcon(
                              FontAwesomeIcons.calculator,
                              color: Colors.black54,
                              size: 100,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
