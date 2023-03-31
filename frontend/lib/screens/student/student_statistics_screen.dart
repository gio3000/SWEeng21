import 'package:flutter/material.dart';
import 'package:frontend/models/grade_subject_mapper.dart';
import 'package:frontend/models/student_user.dart';
import 'package:frontend/provider/user.dart';
import 'package:frontend/widgets/screen_segment.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tuple/tuple.dart';

import '../../utils/constants.dart' as constants;

class StudentStatisticsScreen extends StatefulWidget {
  static const routeName = '/student/statistics';
  const StudentStatisticsScreen({super.key});

  @override
  State<StudentStatisticsScreen> createState() =>
      _StudentStatisticsScreenState();
}

class _StudentStatisticsScreenState extends State<StudentStatisticsScreen> {
  bool _isLoading = true;
  int finishedSubjectsCount = 0;
  int allSubjectsCount = 1;
  List<GradeSubjectMapper> grades = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistiken')),
      body: Padding(
        padding: const EdgeInsets.all(constants.cPadding),
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              Row(
                children: [
                  //Abgeschlossene Module Chart
                  Expanded(
                    child: ScreenSegment(
                      child: SizedBox(
                        height: constraints.maxHeight / 2 - 50,
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : SfCircularChart(
                                title: ChartTitle(
                                  text: 'Abgeschlossene Module',
                                ),
                                series: [
                                  PieSeries<Tuple2<String, int>, String>(
                                    dataLabelSettings: const DataLabelSettings(
                                        isVisible: true),
                                    explode: false,
                                    radius: '90%',
                                    xValueMapper: (Tuple2 val, _) => val.item1,
                                    yValueMapper: (Tuple2 val, _) => val.item2,
                                    dataLabelMapper: (Tuple2 val, _) =>
                                        val.item1,
                                    dataSource: [
                                      Tuple2("Abgeschlossen",
                                          finishedSubjectsCount),
                                      Tuple2(
                                          "Nicht abgeschlossen",
                                          allSubjectsCount -
                                              finishedSubjectsCount),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  //verlauf chart
                  Expanded(
                    child: ScreenSegment(
                      child: SizedBox(
                        height: constraints.maxHeight / 2 - 50,
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator.adaptive())
                            : SfCartesianChart(
                                title: ChartTitle(text: 'Verlauf'),
                                primaryXAxis: CategoryAxis(),
                                series: [
                                  LineSeries<GradeSubjectMapper, String>(
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                              isVisible: true),
                                      xValueMapper:
                                          (GradeSubjectMapper mapper, _) =>
                                              mapper.subjectName,
                                      yValueMapper:
                                          (GradeSubjectMapper mapper, _) =>
                                              mapper.grade,
                                      dataLabelMapper: (GradeSubjectMapper
                                                  mapper,
                                              _) =>
                                          '${mapper.subjectName}: ${mapper.grade}',
                                      dataSource: grades),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: ScreenSegment(
                child: ScreenSegment(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : SizedBox(
                          height: constraints.maxHeight / 2 - 50,
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                )
                              : SfCartesianChart(
                                  title: ChartTitle(text: 'Gewichtung Module'),
                                  primaryXAxis: CategoryAxis(),
                                  series: [
                                    ColumnSeries<GradeSubjectMapper, String>(
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                              isVisible: true),
                                      xValueMapper:
                                          (GradeSubjectMapper mapper, _) =>
                                              mapper.subjectName,
                                      yValueMapper:
                                          (GradeSubjectMapper mapper, _) =>
                                              mapper.creditPoints,
                                      dataLabelMapper:
                                          (GradeSubjectMapper mapper, _) =>
                                              mapper.creditPoints.toString(),
                                      dataSource: grades,
                                    ),
                                  ],
                                ),
                        ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void loadData() async {
    await (Provider.of<User>(context, listen: false) as Student)
        .getAllPossibleSubjects()
        .then((value) {
      setState(() {
        allSubjectsCount = value.length;
        debugPrint(allSubjectsCount.toString());
      });
    });
    if (!mounted) return;
    await (Provider.of<User>(context, listen: false) as Student)
        .getCompletedGrades()
        .then((value) {
      setState(() {
        grades = value;
        finishedSubjectsCount = value.length;
        _isLoading = false;
        debugPrint(finishedSubjectsCount.toString());
      });
    });
  }
}
