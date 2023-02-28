import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants.dart' as constants;

class DeleteListTile extends StatelessWidget {
  final String title;
  final Function onDelete; //Parameter: BuildContext, String title

  ///Creates a simple ListTile with a text on the left side and a delete button on the
  ///right side
  ///`onDelete` is called if the delete button is clicked. It needs `BuildContext` and
  ///`title` as parameters
  const DeleteListTile({
    required this.title,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(constants.cBorderRadius),
      child: Card(
        elevation: 2,
        child: InkWell(
            onTap: () {
              //TODO
            },
            borderRadius: BorderRadius.circular(constants.cBorderRadius),
            child: Padding(
              padding: const EdgeInsets.all(constants.cPadding * 2),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87),
                    ),
                    IconButton(
                        onPressed: () => onDelete(context, title),
                        icon: FaIcon(
                          FontAwesomeIcons.trash,
                          color: Theme.of(context).colorScheme.error,
                          size: 17,
                        ))
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
