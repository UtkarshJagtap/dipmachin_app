import 'dart:developer' as developer;
import 'package:dipmachine/presentation/providers/machine_data_provider.dart';
import 'package:dipmachine/presentation/providers/websocket_data_provider.dart';
import 'package:dipmachine/presentation/ui/components/component_providers/beaker_card_state_provider.dart';
import 'package:dipmachine/presentation/ui/thick_slider_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


 

class IdleActionbar extends StatelessWidget {
  const IdleActionbar ({super.key});

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (c){
      context.read<IdleActionbarStateProvider>().changeTo(IdleActionbarState.idle);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 175),
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
        height: context.select<IdleActionbarStateProvider, double>((value)=>value.height),
        child: Selector<IdleActionbarStateProvider, IdleActionbarState>(
          selector:(context,value) {
          return value.actionbarState;
          },
      
          builder: (context, value, child)  {
            switch(value) {
              case IdleActionbarState.idle:
                return const IdleDefaultAB();
              case IdleActionbarState.start:
                return const IdleStartAB();
              case IdleActionbarState.settings:
                return const IdleSettingsAB();
            }
          },
        
        )
      ),
    );
  }
}

class IdleDefaultAB extends StatelessWidget {
  const IdleDefaultAB({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                color: Colors.white,
                boxShadow: [ BoxShadow(
                              color: Colors.white70,
                              offset: Offset(0, 0),
                              blurRadius: 4,
                              spreadRadius: 2,
                              blurStyle: BlurStyle.normal,
                            )],

                ),),
          )
          ),
        Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: InkWell(borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              onTap: (){
                context.read<MachineDataProvider>().calculateTime();
                context.read<BeakerCardStateProvider>().collapseAll();
                context.read<IdleActionbarStateProvider>().changeTo(IdleActionbarState.start);
                
              },
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text('Tap here to begin',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right:14.0),
            child: IconButton(icon: const Icon(Icons.settings),
              iconSize: 30,
              color: Colors.white,
              onPressed: (){
                context.read<IdleActionbarStateProvider>().changeTo(IdleActionbarState.settings);
              },
            ),
          ),
        )
        
      ],
    );
  }
}

class IdleStartAB extends StatelessWidget {
  const IdleStartAB({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [ BoxShadow(
                              color: Colors.white70,
                              offset: Offset(0, 0),
                              blurRadius: 4,
                              spreadRadius: 2,
                              blurStyle: BlurStyle.normal,
                            )],
              ),
            ),
          ),

          Positioned(
            top: 15,
            child: Padding(
              padding : const EdgeInsets.only(left: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text('Check the values and tap on Start ',
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                  Row(
                    
                    children: [
                      Text('for now estimated time is: ${context.select<MachineDataProvider, int>((v)=>v.time)~/60} mins',
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize:18,color:  Colors.white),  )
                    ],
                  )
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white,),
                  onPressed: (){
                    context.read<IdleActionbarStateProvider>().changeTo(IdleActionbarState.idle);
                  },
                ),
            
                TextButton(
                  onPressed: ()async{
                    final websocketservice = context.read<WebsocketDataProvider>();
                    final idleactionbarsate = context.read<IdleActionbarStateProvider>();
                    final data = await context.read<MachineDataProvider>().getsendData();
                    websocketservice.sendDataToWebscocket(data);
                    idleactionbarsate.changeTo(IdleActionbarState.idle);
                  },
                  child: Container(
                           decoration: BoxDecoration(
                             color: Colors.green.shade700,
                             borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                             border: Border.all(
                              width: 2.3,
                              color:Colors.green.shade400,
                              ),
                            //  boxShadow: [
                            //  BoxShadow(
                            //    color: Colors.green.shade200,
                            //    blurStyle: BlurStyle.inner,
                               
                            //    blurRadius: 4,
                            //    spreadRadius: 4,
                            //    )
                            //  ], 
                            

                           ),
                           child: Padding(
                             padding: const EdgeInsets.all(12.0),
                             child: Row(
                               children: [
                                 Text('Start', 
                                   style:Theme.of(context).textTheme.headlineMedium!.copyWith(color:Colors.white)),
                                 const Icon(Icons.north_east,
                                   color: Colors.white,)
                             
                               ],
                             ),
                           ),
                   ),
            
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IdleSettingsAB extends StatelessWidget {
  const IdleSettingsAB({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(  right:50.0, left: 12 ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select Number of Beakers', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: Colors.greenAccent,
                        width: 1,
                        )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text('${context.select<MachineDataProvider, int>((value)=>(value.numberOfBeakers))}',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),),
                        ),
                      ),
                    
                  ],
                ),
                
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Column(
                    children: [
                      StatefulBuilder(builder: (context, state){
                           return SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                            thumbShape: ThickThumbShape(enabledThumbRadius: 10.0),
                            thumbColor: Colors.greenAccent,
                            trackShape: ThickTrackShape(),
                            overlayShape: SliderComponentShape.noOverlay,
                            trackHeight: 8.0,
                            activeTrackColor: Colors.greenAccent.shade200,
                            inactiveTrackColor: Colors.white30,
                          ),
                          child: Slider(
                              value: context.watch<MachineDataProvider>().numberOfBeakers.toDouble(), 
                              min: 1,
                              divisions: 5,
                              max: 6,
                              onChanged: (value){
                                context.read<MachineDataProvider>().noOfBeakersfromUI = value.toInt();
                              }),
                            );
                          }),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('1', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),),
                          Text('2', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),),
                          Text('3', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),),
                          Text('4', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),),
                          Text('5', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),),
                          Text('6', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),),
                      
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),

         Align(
          alignment: Alignment.bottomRight,
           child: IconButton(
            style: const ButtonStyle(
              shape: WidgetStatePropertyAll(CircleBorder()),
            ),
                      icon: const Icon(Icons.arrow_drop_down),
                      color: Colors.white,
                      onPressed: (){
                        context.read<IdleActionbarStateProvider>().changeTo(IdleActionbarState.idle);
                      },
                      ),
         )
      ],
    );

  }
}

class IdleActionbarStateProvider extends ChangeNotifier{

IdleActionbarState actionbarState = IdleActionbarState.idle;

void changeTo(IdleActionbarState state){
  if(actionbarState != state){
  developer.log('IdleActionbarStateProvider:state changed to $state');
  actionbarState = state;
  notifyListeners();
  }
}

double get height {
  switch(actionbarState) {
    case IdleActionbarState.idle:
      return 100;
    case IdleActionbarState.start:
      return 160;
    case IdleActionbarState.settings:
      return 140;
  }
}

}

enum IdleActionbarState{
  idle,
  start,
  settings
}
