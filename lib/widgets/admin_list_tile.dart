import 'package:flutter/material.dart';

class AdminListTile extends StatelessWidget {
  const AdminListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Sekretariat'),
      trailing: Row(children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
        const Spacer(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.delete))
      ]),
    );
  }
}
