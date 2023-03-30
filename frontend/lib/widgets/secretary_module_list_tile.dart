import 'package:flutter/material.dart';
import 'package:frontend/utils/constants.dart' as constants;

class SecretaryModuleListTile extends StatelessWidget {
  final String moduleName;
  final int creditPoints;

  const SecretaryModuleListTile({
    required this.moduleName,
    required this.creditPoints,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(constants.cPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(constants.cPadding),
              child: Text(
                moduleName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Text('Credits: ${creditPoints.toString()}')
          ],
        ),
      ),
    );
  }
}
