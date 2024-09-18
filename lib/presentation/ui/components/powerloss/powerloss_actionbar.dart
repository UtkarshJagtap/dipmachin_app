import 'dart:convert';

import 'package:dipmachine/domain/machine_state.dart';
import 'package:dipmachine/presentation/providers/websocket_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class PowerLossActionbar extends StatelessWidget {
  const PowerLossActionbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            width: 4,
            color: const Color.fromARGB(93, 150, 149, 149)
            ),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          boxShadow: const [
            BoxShadow(
               color: Color.fromARGB(78, 69, 68, 68),
               offset: Offset(3, 3),
               blurRadius: 10,
               spreadRadius: 8,
               blurStyle: BlurStyle.normal,
            )
          ]
         ),
      child: Stack(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 175),
          child: switch(context.select<PowerlossActionbarStateProvider, PowerlossActionbarStates>((value)=> value.state)) {
            PowerlossActionbarStates.def => const PowerlossABDefault(), 
            PowerlossActionbarStates.newStart => const PowerLossABNew(),
            PowerlossActionbarStates.recover => const PowerLossABRecover(),
            PowerlossActionbarStates.onesec => const PowerlossABDefault(),
          },
          )
          
        ],
      )
    );
  }
}




class PowerlossABDefault extends StatelessWidget {
  const PowerlossABDefault ({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[

      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
              boxShadow: [
                BoxShadow(
                 color: Colors.red.shade400,
                 offset: const Offset(0, 0),
                 blurRadius: 4,
                 spreadRadius: 2,
                 blurStyle: BlurStyle.normal,
                )],
              ),
            ),
          ),
        ),

      Positioned(
        top: 20,
        child: Padding(
          padding: const EdgeInsets.only( left:18.0),
          child: Text('Looks like your previous experiment \nwas Interrupted due to powerloss',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),
            ),
        ),
        ),

      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                      onPressed: () {
                        context
                            .read<PowerlossActionbarStateProvider>()
                            .changeTo(PowerlossActionbarStates.newStart);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              border:
                                  Border.all(color: Colors.blue.shade200, width: 1),
                              borderRadius: const BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 12, bottom: 12),
                            child: Text( 'New Start',
                              style: Theme.of(context).textTheme.titleMedium,),
                          )),
                    ),
          
                    TextButton(
                      onPressed: () {
                       context
                            .read<PowerlossActionbarStateProvider>()
                            .changeTo(PowerlossActionbarStates.recover);
                
                                                              },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              border:
                                  Border.all(color: Colors.orangeAccent.shade100, width: 1),
                              borderRadius: const BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.only(top:12.0,bottom: 12, right:24, left: 24),
                            child: Row(
                              children: [
                                Text('Recover',
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black),),
                              ],
                            ),
                          )),
                    )
            ],
            ),
        )
        )
      ]
      );
  }
}

class PowerLossABNew extends StatelessWidget {
  const PowerLossABNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[

      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
              boxShadow: [
                BoxShadow(
                 color: Colors.red.shade400,
                 offset: const Offset(0, 0),
                 blurRadius: 4,
                 spreadRadius: 2,
                 blurStyle: BlurStyle.normal,
                )],
              ),
            ),
          ),
        ),

      Positioned(
        top: 20,
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Text('Are you sure you want to start a new \nexperiment?',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(color:Colors.white),
            ),
        ),
        ),

      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                      onPressed: () {
                        context
                            .read<PowerlossActionbarStateProvider>()
                            .changeTo(PowerlossActionbarStates.def);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.white60, width: 1),
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
                            .read<PowerlossActionbarStateProvider>()
                            .changeTo(PowerlossActionbarStates.def);
                
                        Map<String, dynamic> temp = {"state": "new"};
                        String data = jsonEncode(temp);
                
                        context
                            .read<WebsocketDataProvider>()
                            .sendDataToWebscocket(data);
                                        },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              border:
                                  Border.all(color: Colors.blue.shade200, width: 1),
                              borderRadius: const BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.only(top:12.0,bottom: 12, right:20, left: 20),
                            child: Row(
                              children: [
                                Text('Affirmative',
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black),),
                              ],
                            ),
                          )),
                    )
            ],
            ),
        )
        )
      ]
      );
  }
}


class PowerLossABRecover extends StatelessWidget {
  const PowerLossABRecover({super.key});

    @override
  Widget build(BuildContext context) {
    return Stack(
      children:[

      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
              boxShadow: [
                BoxShadow(
                 color: Colors.red.shade400,
                 offset: const Offset(0, 0),
                 blurRadius: 4,
                 spreadRadius: 2,
                 blurStyle: BlurStyle.normal,
                )],
              ),
            ),
          ),
        ),

      Positioned(
        top: 20,
        child: Padding(
          padding: const EdgeInsets.only(left:18.0),
          child: Text('Are you sure you want to recover \nthe data and resume the experiment?',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),
            ),
        ),
        ),

      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                      onPressed: () {
                        context
                            .read<PowerlossActionbarStateProvider>()
                            .changeTo(PowerlossActionbarStates.def);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.white60, width: 1),
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
                            .read<PowerlossActionbarStateProvider>()
                            .changeTo(PowerlossActionbarStates.def);
                
                        Map<String, dynamic> temp = {"state": "recover"};
                        String data = jsonEncode(temp);
                
                        context
                            .read<WebsocketDataProvider>()
                            .sendDataToWebscocket(data);
                                        },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              border:
                                  Border.all(color: Colors.orange.shade200, width: 1),
                              borderRadius: const BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.only(top:12.0,bottom: 12, right:20, left: 20),
                            child: Row(
                              children: [
                                Text('Affirmative',
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black),),
                              ],
                            ),
                          )),
                    )
            ],
            ),
        )
        )
      ]
      );
  }
}


class PowerlossActionbarStateProvider extends ChangeNotifier{

  PowerlossActionbarStates _state = PowerlossActionbarStates.def;

  PowerlossActionbarStates get state => _state;

  void onUpdate(MachineStates state){

    if(state == MachineStates.powerloss) _state = PowerlossActionbarStates.def;
    notifyListeners();

  }

  changeTo(PowerlossActionbarStates state){
    _state = state;
    notifyListeners();
  }

  double getHeight(){
    switch(_state) {
      case PowerlossActionbarStates.def:
      case PowerlossActionbarStates.newStart:
      case PowerlossActionbarStates.recover:
        return 180;
      case PowerlossActionbarStates.onesec:
        return 120;
    }
  }

}

enum PowerlossActionbarStates{
def,
newStart,
recover,
onesec
}
