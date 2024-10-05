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
        StatusIndicator(),

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

class StatusIndicator extends StatefulWidget {
  const StatusIndicator({
    super.key,
  });

  @override
  State<StatusIndicator> createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<StatusIndicator> with SingleTickerProviderStateMixin{

  late AnimationController _controller; 
  late Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
      );

    _animation = Tween<double>(begin: 0.0, end: 2.3).animate(_controller)
        ..addListener((){
          setState(() {
            
          });
        });
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
      alignment: Alignment.topRight,
      child:Container(
        height: 6,
        width: 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.pink,
          boxShadow: [
            BoxShadow(
             color: Colors.pink.shade300,
             blurRadius: 4,
             spreadRadius: _animation.value,
             blurStyle: BlurStyle.normal,
            )],
          ),
        ),
      ),
    );
  }
}
