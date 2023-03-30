import 'package:flutter/material.dart';
import 'package:frontend/screens/secretary/secretary_single_course_module_screen.dart';
import 'package:frontend/screens/secretary/secretary_single_course_students_screen.dart';

class SecretarySingleCourseScreen extends StatefulWidget {
  static const routeName = '/secretary/singlecourse';
  final String? courseName;
  const SecretarySingleCourseScreen({required this.courseName, super.key});

  @override
  State<SecretarySingleCourseScreen> createState() =>
      _SecretarySingleCourseScreenState();
}

class _SecretarySingleCourseScreenState
    extends State<SecretarySingleCourseScreen> {
  int currentWidgetIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [
      SecretarySingleCourseStudentsScreen(courseName: widget.courseName ?? ''),
      const SecretarySingleCourseModuleScreen(),
    ];
    return widget.courseName == null
        ? _drawErrorScreen(context)
        : DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.courseName!),
                bottom: TabBar(
                    onTap: (value) => setState(() {
                          currentWidgetIndex = value;
                        }),
                    tabs: const [
                      Tab(
                        child: Text('Studierende'),
                      ),
                      Tab(
                        child: Text('Module'),
                      ),
                    ]),
              ),
              body: widgets[currentWidgetIndex],
            ),
          );
  }

  ///Draws the local error screen. Is called if no courseScreen was called
  Scaffold _drawErrorScreen(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Ein Fehler ist aufgetreten!',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Zurück'),
          ),
        ],
      )),
    );
  }
}
