import 'package:flutter/material.dart';
import 'package:mad/data.dart';

class ReloadButton extends StatefulWidget
{
  const ReloadButton({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ReloadButtonState();
  }
}

class _ReloadButtonState extends State<ReloadButton>
{
  int numberOfTaps = 0;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text('MBox')
    );
  }
  

  void onPressed() {
    ++numberOfTaps;
    if(numberOfTaps == 5)
    {
      numberOfTaps = 0;
      database.deleteAll();
    }
  }
}