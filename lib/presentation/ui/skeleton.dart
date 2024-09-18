import 'package:dipmachine/domain/machine_state.dart';
import 'package:dipmachine/presentation/providers/machine_state_provider.dart';
import 'package:dipmachine/presentation/ui/components/actionbar_builder.dart';
import 'package:dipmachine/presentation/ui/components/body_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//this widget will determine the background image of the app and will switch the
//body and the action bar depending on the state
class Skeleton extends StatelessWidget {
  const Skeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      body: Stack(
        children: [

          Selector<MachineStateProvider, String>(
            selector: (_, machinestateprovider) =>
                machinestateprovider.state.name,
            builder: (_, mstate, ch) => Container(
              decoration: BoxDecoration(image: _decorationImage()),
            ),
          ),

          Selector<MachineStateProvider, MachineStates>(
            selector: (con, machinestateprovider) =>
                machinestateprovider.state,
            builder: (con, mstate, ch) => BodyBuilder(mstate: mstate,),
          ),

          Positioned(
            bottom: 40,
            right: 12,
            left: 12,
            child: Selector<MachineStateProvider, MachineStates>(
              selector: (con, machinestateprovider) =>
                  machinestateprovider.state,
              builder: (con, mstate, ch) => ActionbarBuilder(machineStates: mstate),
              ),
          ),//Positioned
        ],
      ), //stack
    );
  }
}

DecorationImage _decorationImage() {
    return const DecorationImage(
          image: AssetImage('lib/presentation/assets/images/dip.png'),
          fit: BoxFit.fill);
}

//class IdleAc extends StatelessWidget {
//  const IdleAc({
//    super.key,
//    required this.mstate
//  });
//
//  final String mstate;
//
//  @override
//  Widget build(BuildContext context) {
//    return AnimatedContainer(
//      decoration: BoxDecoration(
//          color: Colors.black,
//          boxShadow: const [
//            BoxShadow(
//              color: Color.fromARGB(78, 69, 68, 68),
//              offset: Offset(3, 3),
//              blurRadius: 10,
//              spreadRadius: 8,
//              blurStyle: BlurStyle.normal,
//            )
//          ],
//          border: Border.all(
//              width: 4, color: const Color.fromARGB(93, 150, 149, 149)),
//          borderRadius: BorderRadius.all(Radius.circular(11))),
//      height: 100,
//      duration: Duration(milliseconds: 300,),
//      child: Center(
//          child: Text(
//        '$mstate',
//        style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),
//      )),
//    );
//  }
//}
//

