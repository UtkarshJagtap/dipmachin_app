import 'package:dipmachine/domain/machine_state.dart';
import 'package:dipmachine/presentation/ui/components/disconnect/disconnect_view.dart';
import 'package:dipmachine/presentation/ui/components/done/done_view.dart';
import 'package:dipmachine/presentation/ui/components/halt/halt_view.dart';
import 'package:dipmachine/presentation/ui/components/initial/initial_view.dart';
import 'package:dipmachine/presentation/ui/components/powerloss/powerloss_view.dart';
import 'package:dipmachine/presentation/ui/components/working/working_view.dart';
import 'package:flutter/material.dart';

import 'idle/idle_list_view.dart';

class BodyBuilder extends StatelessWidget {
  const BodyBuilder({super.key, required this.mstate});
  final MachineStates mstate;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: switch (mstate) {
          MachineStates.halt => const HaltView(),
          MachineStates.initial => const InitialView(),
          MachineStates.disconnect => DisconnectView(mstate: mstate.name),
          MachineStates.idle => const IdleListView(),
          MachineStates.powerloss => PowerlossView(mstate: mstate.name),
          MachineStates.working => WorkingView(mstate: mstate.name),
          MachineStates.done => const DoneView(),
        });
  }
}


