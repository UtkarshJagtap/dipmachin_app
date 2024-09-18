import 'package:dipmachine/presentation/providers/machine_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HaltView extends StatelessWidget {
  const HaltView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('${context.select<MachineDataProvider, String>((value)=> value.errorMessage)}, and then recheck'),
      );
  }
}
