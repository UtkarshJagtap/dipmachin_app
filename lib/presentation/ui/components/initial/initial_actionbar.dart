import "package:flutter/material.dart";

class InitialActionbar extends StatelessWidget {
  const InitialActionbar({super.key});

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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
          alignment: Alignment.topRight,
          child: Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.pink,
              boxShadow: [
                BoxShadow(
                 color: Colors.pink.shade400,
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
            child: Text('Initialising',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),),
          ),
        ],
      )
    );
  }
}
