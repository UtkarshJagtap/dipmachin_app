import 'package:flutter/material.dart';

class DoneView extends StatelessWidget {
  const DoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return 
        Center(
          child:Text('We are so done', 
            style: Theme.of(context).textTheme.labelMedium,)
          );
  }
}
