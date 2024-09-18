import 'package:flutter/material.dart';

class InitialView extends StatelessWidget {
  const InitialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Establishing connection with DipMachine',
        style: Theme.of(context).textTheme.labelMedium,));
  }
}
