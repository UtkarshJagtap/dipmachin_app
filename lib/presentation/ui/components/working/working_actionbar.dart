import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dipmachine/domain/machine_state.dart';
import 'package:dipmachine/presentation/providers/machine_data_provider.dart';
import 'package:dipmachine/presentation/providers/websocket_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkingActionbar extends StatelessWidget {
  const WorkingActionbar({super.key});

  @override  
  Widget build(BuildContext context) {

    return TapRegion(
      onTapOutside: (event){
        context.read<WorkingActionbarStateProvider>().changeTo(WorkingActionbarStates.working);
      },
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 175),
          decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                  width: 4, color: const Color.fromARGB(93, 150, 149, 149)),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(78, 69, 68, 68),
                  offset: Offset(3, 3),
                  blurRadius: 10,
                  spreadRadius: 8,
                  blurStyle: BlurStyle.normal,
                )
              ]),
          height: context.select<WorkingActionbarStateProvider, double>(
              (value) => value.height),
          child: Selector<WorkingActionbarStateProvider, WorkingActionbarStates>(
            selector: (context, value) {
              return value.state;
            },
            builder: (context, value, child) {
              switch (value) {
                case WorkingActionbarStates.working:
                  return const WorkingABWork();
                case WorkingActionbarStates.abort:
                  return const WorkingABAbort();
                case WorkingActionbarStates.onesec:
                  return const WorkingABOneSec();
              }
            },
          )),
    );
  }
}

enum WorkingActionbarStates { working, abort, onesec}

class WorkingActionbarStateProvider extends ChangeNotifier {
  WorkingActionbarStates _state = WorkingActionbarStates.working;

  void changeTo(WorkingActionbarStates state) {
    _state = state;
    developer.log('WorkingActionbarState: changed to $_state');
    notifyListeners();
  }

  void onUpdate(MachineStates machineState){
    if(machineState == MachineStates.working){
       changeTo(WorkingActionbarStates.working);
    }
  }

  WorkingActionbarStates get state => _state;
  double get height {
    switch (_state) {
      case WorkingActionbarStates.working:
        return 100;
      case WorkingActionbarStates.abort:
        return 160;
      case WorkingActionbarStates.onesec:
        return 100;
    }
  }
}

class WorkingABWork extends StatelessWidget {
  const WorkingABWork({super.key});

  String _getWorkingMessage(BuildContext context) {
    int time = context.select<MachineDataProvider, int>((value) => value.time);
    int onCycle =
        context.select<MachineDataProvider, int>((value) => value.onCycle);
int cycles =
        context.select<MachineDataProvider, int>((value) => value.cycles);


    if (time ~/ 60 >= 59) {
      return 'On Cycle $onCycle/$cycles and \n${time ~/ 3600}hrs ${time % 60}mins left';
    } else if (time ~/ 60 < 59 && time ~/ 60 >= 1) {
      return 'On Cycle $onCycle/$cycles  and \n${time ~/ 60}min ${time % 60}sec left';
    }

    return 'On Cycle $onCycle/$cycles and \n$time sec left';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
              boxShadow: [
                BoxShadow(
                 color: Colors.green.shade400,
                 offset: const Offset(0, 0),
                 blurRadius: 4,
                 spreadRadius: 2,
                 blurStyle: BlurStyle.normal,
                )],
              ),
            ),
          ),
        ),
    
        Padding(
          padding: const EdgeInsets.only(left:20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              iconSize: 34,
              color: Colors.white,
              icon: const Icon(Icons.arrow_drop_up),
              onPressed: () {
                context
                    .read<WorkingActionbarStateProvider>()
                    .changeTo(WorkingActionbarStates.abort);
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(_getWorkingMessage(context),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.white)),
        ),
      ],
    );
  }
}

class WorkingABAbort extends StatefulWidget {
  const WorkingABAbort({super.key});

  @override
  State<WorkingABAbort> createState() => _WorkingABAbortState();
}

class _WorkingABAbortState extends State<WorkingABAbort> {
  void changeToFalse() => setState(() {
        _insideState = false;
      });

  bool _insideState = true;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      
      duration: const Duration(milliseconds: 300),
      child: (_insideState)
          ? WorkingABAbort1(
              callback: changeToFalse,
            )
          : const WorkingABAbort2(),
    );
  }
}

class WorkingABAbort1 extends StatelessWidget {
  const WorkingABAbort1({super.key, required this.callback});

  final VoidCallback callback;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
        Align(
        alignment: Alignment.topRight,
        child: Container(
          height: 6,
          width: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
            boxShadow: [
              BoxShadow(
               color: Colors.green.shade400,
               offset: const Offset(0, 0),
               blurRadius: 4,
               spreadRadius: 2,
               blurStyle: BlurStyle.normal,
              )],
            ),
          ),
        ),

          Positioned(
            top: 4,
            child: Padding(
              padding: const EdgeInsets.only(left:14.0, top: 8),
              child: Text('Do you want to abort the current \nexperiment?',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(color:Colors.white),),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 36,
                    color: Colors.white,
                    onPressed: () {
                      context
                          .read<WorkingActionbarStateProvider>()
                          .changeTo(WorkingActionbarStates.working);
                    },
                  ),
                  TextButton(
                    onPressed: callback,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            border:
                                Border.all(color: Colors.red.shade100, width: 1),
                            borderRadius: const BorderRadius.all(Radius.circular(8))),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text('Abort',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(color: Colors.white)),
                              const Icon(Icons.north_east, color: Colors.white)
                            ],
                          ),
                        )),
                  )
                ],
              ))
        ],
      ),
    );
  }
}

class WorkingABAbort2 extends StatelessWidget {
  const WorkingABAbort2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
       Align(
        alignment: Alignment.topRight,
        child: Container(
          height: 6,
          width: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
            boxShadow: [
              BoxShadow(
               color: Colors.green.shade400,
               offset: const Offset(0, 0),
               blurRadius: 4,
               spreadRadius: 2,
               blurStyle: BlurStyle.normal,
              )],
            ),
          ),
        ),

          Positioned(
            top: 8,
            child: Padding(
              padding: const EdgeInsets.only( left: 12.0),
              child: Text('Are you sure you want to abort \nthe current experiment?', 
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(color:Colors.white),),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      context
                          .read<WorkingActionbarStateProvider>()
                          .changeTo(WorkingActionbarStates.working);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.grey.shade100, width: 1),
                            borderRadius: const BorderRadius.all(Radius.circular(8))),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 12, bottom: 12),
                          child: Text('Hold On',
                            style: Theme.of(context).textTheme.titleMedium,),
                        )),
                  ),

                  TextButton(
                    onPressed: () {
                     context
                          .read<WorkingActionbarStateProvider>()
                          .changeTo(WorkingActionbarStates.onesec);
      
                      Map<String, dynamic> temp = {"state": "abort"};
                      String data = jsonEncode(temp);
      
                      context
                          .read<WebsocketDataProvider>()
                          .sendDataToWebscocket(data);
                                      },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            border:
                                Border.all(color: Colors.blue.shade100, width: 1),
                            borderRadius: const BorderRadius.all(Radius.circular(8))),
                        child: Padding(
                          padding: const EdgeInsets.only(top:12.0,bottom: 12, right:20, left: 20),
                          child: Row(
                            children: [
                              Text('Confirm',
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black),)
                            , ],
                          ),
                        )),
                  )
                ],
              )
            )
        ],
      ),
    );
  }
}


class WorkingABOneSec extends StatelessWidget {
  const WorkingABOneSec ({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
              boxShadow: [
                BoxShadow(
                 color: Colors.green.shade400,
                 offset: const Offset(0, 0),
                 blurRadius: 4,
                 spreadRadius: 2,
                 blurStyle: BlurStyle.normal,
                )],
              ),
            ),
          ),
        ),
    
        
        Align(
          alignment: Alignment.center,
          child: Text('Aborting',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.white)),
        ),
      ],
    );

  }
}
