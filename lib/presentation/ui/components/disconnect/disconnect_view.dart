import 'package:flutter/material.dart';

class DisconnectView extends StatelessWidget {
  const DisconnectView({super.key, required this.mstate});
  final String mstate;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: UniqueKey(),
      slivers: [
      const SliverAppBar(backgroundColor:Colors.transparent),

      SliverList.list(children:[ 

        Padding(
        padding: const EdgeInsets.only( right: 12.0, left: 12,),
        child: Container(
          decoration: const BoxDecoration(
            //color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Here are some instructions that might help you get connected:',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 16),),
          )),
        ),


        Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: const BoxDecoration(
            //color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Ensure that your device is connected to the same network as the machine',
                style: Theme.of(context).textTheme.labelMedium,),
          )),
        ),

        Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: const BoxDecoration(
           // color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Check the indicator lights on the machine. If you see a pulsing pink light, connect to the access point named "Dip Machine" to operate it.',
                style: Theme.of(context).textTheme.labelMedium,),
          )),
        ),

        Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: const BoxDecoration(
            //color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Rarely the machine fails to connect to the stored WiFi networks, try restarting it a few times.',
                style: Theme.of(context).textTheme.labelMedium,),
          )),
        ),
      ]
        ),
    ],
   );
  }
}
