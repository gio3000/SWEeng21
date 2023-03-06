import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:frontend/models/grade_subject_mapper.dart';
import 'package:frontend/models/student_user.dart';
import 'package:frontend/provider/user.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import '../../utils/constants.dart' as constants;

class StudentGradeCalculator extends StatefulWidget {
  static const routeName = '/student/gradecalculator';
  const StudentGradeCalculator({super.key});

  @override
  State<StudentGradeCalculator> createState() => _StudentGradeCalculatorState();
}

class _StudentGradeCalculatorState extends State<StudentGradeCalculator> {
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  List<GradeSubjectMapper> grades = [];
  List<GradeSubjectMapper> allSubjects = [];
  double? neededMeanGrade;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notenrechner')),
      body: Padding(
        padding: const EdgeInsets.all(constants.cPadding),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      'Ihr aktueller Durchschnitt beträgt: ${getMeanGrade(grades).item1}'),
                  const SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null) return 'Bitte gib eine Zahl ein!';
                        if (double.tryParse(value) == null) {
                          return 'Bitte gib eine valide Gleitkommazahl mit . getrennt an!';
                        }
                        if (double.parse(value) < 1.0 ||
                            double.parse(value) > 5.0) {
                          return 'Bitte gib eine Zahl zwischen 1.0 und 5.0';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        setState(() {
                          neededMeanGrade = getNeededAverageGrade(
                              getMeanGrade(grades), double.parse(newValue!));
                        });
                      },
                      onFieldSubmitted: (_) {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                        }
                      },
                      decoration: const InputDecoration(
                        label: Text('Gewünschter Schnitt'),
                        hintText: '1.7',
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  neededMeanGrade == null
                      ? const SizedBox()
                      : neededMeanGrade! >= 1.0 && neededMeanGrade! <= 5.0
                          ? Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                      text:
                                          'Sie benötigen folgende Note im Durchschnitt: '),
                                  TextSpan(
                                      text: neededMeanGrade!.toStringAsFixed(2),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )
                          : Text(
                              'Du kannst diesen Schnitt nicht mehr erreichen!',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                ],
              ),
      ),
    );
  }

  ///returns the average grade and the amount of credits from these grades as a tuple
  Tuple2<double, int> getMeanGrade(List<GradeSubjectMapper> grades) {
    double sum = grades.fold<double>(
        0, (previousValue, element) => previousValue += element.grade);
    return Tuple2(
        sum / grades.length,
        grades.fold(0,
            (previousValue, element) => previousValue += element.creditPoints));
  }

  ///returns the grade a user needs to write in average in order to get the `desiredGrade`
  double getNeededAverageGrade(
      Tuple2<double, int> currentMean, double desiredGrade) {
    int allCreditPointsSum = allSubjects.fold(
        0, (previousValue, element) => previousValue += element.creditPoints);
    return (desiredGrade * allCreditPointsSum -
            currentMean.item2 * currentMean.item1) /
        (allCreditPointsSum - currentMean.item2);
  }

  ///loads data from `student`-provider
  void loadData() async {
    await (Provider.of<User>(context, listen: false) as Student)
        .getCompletedGrades()
        .then((value) {
      setState(() {
        grades = value;
      });
    });
    if (!mounted) return;
    (Provider.of<User>(context, listen: false) as Student)
        .getAllPossibleSubjects()
        .then((value) {
      setState(() {
        allSubjects = value;
        _isLoading = false;
      });
    });
  }
}
