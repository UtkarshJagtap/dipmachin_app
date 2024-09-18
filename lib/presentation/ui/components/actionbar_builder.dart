import 'package:dipmachine/domain/machine_state.dart';
import 'package:dipmachine/presentation/ui/components/disconnect/disconnect_actionbar.dart';
import 'package:dipmachine/presentation/ui/components/done/done_actionbar.dart';
import 'package:dipmachine/presentation/ui/components/halt/halt_acitonbar.dart';
import 'package:dipmachine/presentation/ui/components/idle/idle_actionbar.dart';
import 'package:dipmachine/presentation/ui/components/initial/initial_actionbar.dart';
import 'package:dipmachine/presentation/ui/components/powerloss/powerloss_actionbar.dart';
import 'package:dipmachine/presentation/ui/components/working/working_actionbar.dart';
import 'package:flutter/widgets.dart';

class ActionbarBuilder extends StatelessWidget {
  const ActionbarBuilder({super.key, required this.machineStates});

  final MachineStates machineStates;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: switch(machineStates) {
        MachineStates.halt => const HaltActionbar(),
        MachineStates.initial => const InitialActionbar(),
        MachineStates.disconnect => const DisconnectActionbar(),
        MachineStates.idle => const IdleActionbar(),
        MachineStates.powerloss => const PowerLossActionbar(),
        MachineStates.working => const WorkingActionbar(),
        MachineStates.done => const DoneActionbar(),
      },
      
   );
  }
}
