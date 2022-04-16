import 'package:flutter/material.dart';
import 'package:mad/data.dart';

class ReloadButton extends StatefulWidget {
  final Function update;
  const ReloadButton(this.update, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ReloadButtonState();
  }
}

class _ReloadButtonState extends State<ReloadButton> {
  int numberOfTaps = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextButton(
            onPressed: onPressed,
            child: const Text(
              'MBox',
              style: TextStyle(color: Colors.white, fontSize: 20),
            )));
  }

  void onPressed() {
    ++numberOfTaps;
    if (numberOfTaps >= 10) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  const Text('Are you sure you want to refresh the database?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'No'),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () async {
                    print("del");
                    await database.deleteAll();
                    print("delet");
                    database.state = DatabaseState.Uninitialized;
                    widget.update();
                    print("delete");
                    Navigator.pop(context, 'Yes');
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          });

      numberOfTaps = 0;
    }
  }
}
