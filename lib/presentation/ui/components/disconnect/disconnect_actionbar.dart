import "package:flutter/material.dart";

class DisconnectActionbar extends StatelessWidget {
  const DisconnectActionbar({super.key});

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
      child: Stack(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 6,
                width: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color:Colors.red,
                  ),
                ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
            padding: const EdgeInsets.only( left: 16.0),
            child: Text('Disconnected from DipMachine',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),),
          ),
            ),
        ],
      )
    );
  }
}
