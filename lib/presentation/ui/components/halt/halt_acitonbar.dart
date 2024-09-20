import 'dart:convert';

import 'package:dipmachine/presentation/providers/machine_data_provider.dart';
import 'package:dipmachine/presentation/providers/websocket_data_provider.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class HaltActionbar extends StatelessWidget {
  const HaltActionbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
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
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 175),
        child: context.select<MachineDataProvider, bool>((value)=> value.haltRecheck) ? const HaltAB1() : const HaltAB2(),
      )
    );
  }
}



class HaltAB1 extends StatelessWidget {
  const HaltAB1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      //mainAxisAlignment: MainAxisAlignment.center,
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
    
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
          
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Recheck the sensors?',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),),
              ),
          
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    Map<String, dynamic> temp = {"state": "recheck"};
                    String data = jsonEncode(temp);
                    context.read<MachineDataProvider>().changeHaltRecheck(false);
                    context
                        .read<WebsocketDataProvider>()
                        .sendDataToWebscocket(data);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                          color: Colors.green.shade400,
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Recheck',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
          
            ],
          ),
        ),
      ],
    );
  }
}

class HaltAB2 extends StatelessWidget {
  const HaltAB2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      //mainAxisAlignment: MainAxisAlignment.center,
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
    
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all( 24.0),
            child: Text('Checking with DipMachine',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),),
          ),
        ),
      ],
    );
  }
}
