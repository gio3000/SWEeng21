import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AdminListTile extends StatelessWidget {
  const AdminListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Sekretariat'),
      trailing:
          Row(children: [IconButton(onPressed: () {}, icon: Icon(Icons.abc))]),
    );
  }
}
