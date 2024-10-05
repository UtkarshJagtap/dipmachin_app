
import 'package:dipmachine/presentation/providers/machine_data_provider.dart';
import 'package:dipmachine/presentation/ui/components/component_providers/beaker_card_state_provider.dart';
import 'package:dipmachine/presentation/ui/thin_slider_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class IdleBeakerList extends StatelessWidget {
  const IdleBeakerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<MachineDataProvider, int>(
      key: UniqueKey(),
      selector: (_,machine) => machine.numberOfBeakers,
      builder:(context,value,ch) { 
        developer.log('IdleBeakerList: builder called rebuilding list, numberOfBeakers: $value');
        return SliverList(
        delegate: SliverChildBuilderDelegate(
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          childCount: value,
          (context, index){
            developer.log('IdleBeakerList: delegate called for $index');
            return IdleBeakerCard(index: index);
          }
        ),
      );
      }
    );
  }
}

class IdleBeakerCard extends StatelessWidget {
  
  const IdleBeakerCard({super.key, required this.index});

  final int index;
  @override
  Widget build(BuildContext context) {
      
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: AnimatedContainer(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 0.5,
              ),
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(8))
            ),
            duration: const Duration(milliseconds: 200),
            height: context.select<BeakerCardStateProvider, bool>((value)=> value.isExpanded(index)) ? 430 : 75,
            //height: value.$5 ? 430 :75,
            curve: Curves.fastOutSlowIn,
            child: context.select<BeakerCardStateProvider, bool>((value)=>value.isExpanded(index)) ? ExpandedCardView(index: index,) : CollapsedCardView(index: index),
           // child: value.$5 ? ExpandedCardView(index: index) : CollapsedCardView(index: index),
          ),
        );
    
  }
}
class CollapsedCardView extends StatelessWidget {
  const CollapsedCardView({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text('${context.select<MachineDataProvider, int>((value)=>value.beakerIndex(index))}',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text('${context.select<MachineDataProvider, double>((value)=>value.beakerTemp(index))} °C',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black),
              ),
            ), 
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text('${context.select<MachineDataProvider, int>((value)=>value.beakerRPM(index))} RPM',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black),
              ),
            ), 
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text('${context.select<MachineDataProvider, int>((value)=>value.beakerDipDuration(index))} sec',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black),
              ),
            ),           Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_drop_down),
              onPressed:(){
                 context.read<BeakerCardStateProvider>().changeTo(index,true);
                },
              ),
          )
        ],
      ),
    );
  }
}

class ExpandedCardView extends StatelessWidget {
  const ExpandedCardView({
    super.key,
    required this.index,
  });
  final int index;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder:(context, state) => SingleChildScrollView(
        child: Padding(
          key: UniqueKey(),
          padding: const EdgeInsets.only( left:12, right:10.0, top:10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              
                  Text('Beaker ${context.select<MachineDataProvider, int>((value)=>value.beakerIndex(index))}',
                    style: Theme.of(context).textTheme.titleMedium),
              
                  IconButton(
                    icon: const Icon(Icons.arrow_drop_up),
                    onPressed:(){
                      context.read<BeakerCardStateProvider>().changeTo(index,false);
                    },
                  ),
                ],
              ),
          
             
        
        
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 14.0, bottom: 14),
                      child: Column(
                        children: [
                          Padding(
                             padding: const EdgeInsets.only(bottom: 12.0),
                             child: StatefulBuilder(
                                builder:(context,state)=> Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                   Text('Temperature', 
                                     style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black),),
                                   Container(
                                     decoration: BoxDecoration(
                                       borderRadius: const BorderRadius.all(Radius.circular(8)),
                                       border: Border.all(color: Colors.black, width: 0.5) ),
                                     child: Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: Text('${context.watch<MachineDataProvider>().beakerTemp(index)} °C',
                                         style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black) ,),
                                     ),
                                   )
                                         
                                 ],
                              ),
                                             ),
                           ),
                          StatefulBuilder(
                            builder:(context,state)=> SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                              thumbShape: ThinThumbShape(enabledThumbRadius: 6.0),
                              thumbColor: Colors.black,
                              trackShape: ThinTrackShape(),
                              overlayShape: SliderComponentShape.noOverlay,
                              trackHeight: 4.0,
                              activeTrackColor: Colors.black54,
                              inactiveTrackColor: Colors.black12,
                                ),
                              child: Slider(
                                  value: context.watch<MachineDataProvider>().beakerTemp(index),
                                  max: 100,
                                  min: 1,
                                  //divisions: 99,
                                  onChanged:(value){
                                   
                                    context.read<MachineDataProvider>().tempFromSlider(index, value.toInt());
                                  } ,
                                ),
                              
                            ),
                          ),
                              
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                             Text('1',
                               style:Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black) ,),
                             Text('100',
                               style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black) ,)
                           ],
                          ),
                        ],
                      ),
                    ),
                    
                    
                    
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 20.0,bottom: 14),
                      child: Column(
                        children: [
                          Padding(
                             padding: const EdgeInsets.only(bottom: 12.0),
                             child: StatefulBuilder(
                                builder:(context,state)=> Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                   Text('RPM',
                                     style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black) ,),
                                   Container(
                                     decoration: BoxDecoration(
                                       color: Colors.white,
                                       border: Border.all(width: 0.5),
                                       borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                       ),
                                     child: Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: Text('${context.watch<MachineDataProvider>().beakerRPM(index)} RPM',
                                         style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black),),
                                     ))
                                         
                                 ],
                              ),
                            ),
                           ),
                          StatefulBuilder(
                            builder:(context,state)=> SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                              thumbShape: ThinThumbShape(enabledThumbRadius: 6.0),
                              thumbColor: Colors.black,
                              trackShape: ThinTrackShape(),
                              overlayShape: SliderComponentShape.noOverlay,
                              trackHeight: 4.0,
                              activeTrackColor: Colors.black54,
                              inactiveTrackColor: Colors.black12,
                                ),
                              child: Slider(
                                  value: context.watch<MachineDataProvider>().beakerRPM(index).toDouble(),
                                  max: 600,
                                  min: 0,
                                  divisions: 12,
                                  onChanged:(value){
                                   
                                    context.read<MachineDataProvider>().rpm(index, value.toInt());
                                  } ,
                                ),
                              
                            ),
                          ),
                              
                         Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                             Text('0',style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black) ,), 
                             Text('600', 
                               style:Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black) ,)
                           ],
                          ),
                        ],
                      ),
                    ),
                    
                    
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 20.0,bottom: 14.0),
                      child: Column(
                        children: [
                          Padding(
                             padding: const EdgeInsets.only(bottom: 12.0),
                             child: StatefulBuilder(
                                builder:(context,state)=> Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Dip Duration',
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black),),
                                   Container(
                                     decoration: BoxDecoration(
                                       
                                       border: Border.all(width: 0.5),
                                       borderRadius: const BorderRadius.all(Radius.circular(8.0)),),
                                     child: Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child:  Text('${context.select<MachineDataProvider, int>((value)=> value.beakerDipDuration(index))} sec',
                                           style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black)),
                                       ),
                                   )
                                         
                                 ],
                              ),
                                             ),
                           ),
                          StatefulBuilder(
                            builder:(context,state)=> SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                              thumbShape: ThinThumbShape(enabledThumbRadius: 6.0),
                              thumbColor: Colors.black,
                              trackShape: ThinTrackShape(),
                              overlayShape: SliderComponentShape.noOverlay,
                              trackHeight: 4.0,
                              activeTrackColor: Colors.black54,
                              inactiveTrackColor: Colors.black12,
                                ),
                              child: Slider(
                                  value: context.watch<MachineDataProvider>().beakerDipDuration(index).toDouble(),
                                  max: 100,
                                  min: 0,
                                  //divisions: 99,
                                  onChanged:(value){
                                   
                                    context.read<MachineDataProvider>().dipDuration(index, value.toInt());
                                  } ,
                                ),
                              
                            ),
                          ),
                              
                            Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                             Text('0',style: Theme.of(context).textTheme.labelMedium!.copyWith(color:Colors.black) ,), 
                             Text('100', style: Theme.of(context).textTheme.labelMedium!.copyWith(color:Colors.black),)
                           ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        
              
            ],
          ),//column
        ),
      ),
    );
  }
}

//lass CollapsedCardView extends StatelessWidget {
// const CollapsedCardView({
//   super.key,
//   required this.index,
// });
//
// final int index;
//
// @override
// Widget build(BuildContext context) {
//   return Padding(
//     key: UniqueKey(),
//     padding: const EdgeInsets.all(10.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 12.0),
//           child: Text('${context.select<MachineDataProvider, int >((value) => value.beakers[index].index)}',
//           style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left:8.0),
//           child: Text('${context.select<MachineDataProvider, int>((value)=> value.beakers[index].temp.toInt())}°C',
//           style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left:8.0),
//           child: Text('${context.select<MachineDataProvider,int>((value)=> value.beakers[index].rpm)} RPM',
//           style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: Text('${context.select<MachineDataProvider, int>((value)=> value.beakers[index].dipDuration)} sec',
//           style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: IconButton(
//             icon: const Icon(Icons.arrow_drop_down),
//             onPressed:(){
//                context.read<BeakerCardStateProvider>().changeTo(index,true);
//               },
//             ),
//         )
//       ],
//     ),
//   );
// }
//
//
//lass ExpandedCardView extends StatelessWidget {
// const ExpandedCardView({
//   super.key,
//   required this.index,
// });
// final int index;
// @override
// Widget build(BuildContext context) {
//   return StatefulBuilder(
//     builder:(context, state) => SingleChildScrollView(
//       child: Padding(
//         key: UniqueKey(),
//         padding: const EdgeInsets.only( left:12, right:10.0, top:10),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//             
//                 Text('Beaker ${context.select<MachineDataProvider, int>((value)=>value.beakers[index].index)}',
//                   style: Theme.of(context).textTheme.titleMedium),
//             
//                 IconButton(
//                   icon: const Icon(Icons.arrow_drop_up),
//                   onPressed:(){
//                     context.read<BeakerCardStateProvider>().changeTo(index,false);
//                   },
//                 ),
//               ],
//             ),
//         
//            
//       
//       
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(right: 8.0, top: 14.0, bottom: 14),
//                     child: Column(
//                       children: [
//                         Padding(
//                            padding: const EdgeInsets.only(bottom: 12.0),
//                            child: StatefulBuilder(
//                               builder:(context,state)=> Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                  Text('Temperature', 
//                                    style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black),),
//                                  Container(
//                                    decoration: BoxDecoration(
//                                      borderRadius: BorderRadius.all(Radius.circular(8)),
//                                      border: Border.all(color: Colors.black, width: 0.5) ),
//                                    child: Padding(
//                                      padding: const EdgeInsets.all(8.0),
//                                      child: Text('${context.watch<MachineDataProvider>().beakers[index].temp} °C',
//                                        style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black) ,),
//                                    ),
//                                  )
//                                        
//                                ],
//                             ),
//                                            ),
//                          ),
//                         StatefulBuilder(
//                           builder:(context,state)=> SliderTheme(
//                             data: SliderTheme.of(context).copyWith(
//                             thumbShape: ThinThumbShape(enabledThumbRadius: 6.0),
//                             thumbColor: Colors.black,
//                             trackShape: ThinTrackShape(),
//                             overlayShape: SliderComponentShape.noOverlay,
//                             trackHeight: 4.0,
//                             activeTrackColor: Colors.black54,
//                             inactiveTrackColor: Colors.black12,
//                               ),
//                             child: Slider(
//                                 value: context.watch<MachineDataProvider>().beakers[index].temp,
//                                 max: 100,
//                                 min: 1,
//                                 //divisions: 99,
//                                 onChanged:(value){
//                                  
//                                   context.read<MachineDataProvider>().tempFromSlider(index, value.toInt());
//                                 } ,
//                               ),
//                             
//                           ),
//                         ),
//                             
//                          Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: [
//                            Text('1',
//                              style:Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black) ,),
//                            Text('100',
//                              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black) ,)
//                          ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   
//                   
//                   
//                   Padding(
//                     padding: const EdgeInsets.only(right: 8.0, top: 20.0,bottom: 14),
//                     child: Column(
//                       children: [
//                         Padding(
//                            padding: const EdgeInsets.only(bottom: 12.0),
//                            child: StatefulBuilder(
//                               builder:(context,state)=> Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                  Text('RPM',
//                                    style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black) ,),
//                                  Container(
//                                    decoration: BoxDecoration(
//                                      color: Colors.white,
//                                      border: Border.all(width: 0.5),
//                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                                      ),
//                                    child: Padding(
//                                      padding: const EdgeInsets.all(8.0),
//                                      child: Text('${context.watch<MachineDataProvider>().beakers[index].rpm} RPM',
//                                        style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black),),
//                                    ))
//                                        
//                                ],
//                             ),
//                                            ),
//                          ),
//                         StatefulBuilder(
//                           builder:(context,state)=> SliderTheme(
//                             data: SliderTheme.of(context).copyWith(
//                             thumbShape: ThinThumbShape(enabledThumbRadius: 6.0),
//                             thumbColor: Colors.black,
//                             trackShape: ThinTrackShape(),
//                             overlayShape: SliderComponentShape.noOverlay,
//                             trackHeight: 4.0,
//                             activeTrackColor: Colors.black54,
//                             inactiveTrackColor: Colors.black12,
//                               ),
//                             child: Slider(
//                                 value: context.watch<MachineDataProvider>().beakers[index].rpm.toDouble(),
//                                 max: 600,
//                                 min: 0,
//                                 divisions: 6,
//                                 onChanged:(value){
//                                  
//                                   context.read<MachineDataProvider>().rpm(index, value.toInt());
//                                 } ,
//                               ),
//                             
//                           ),
//                         ),
//                             
//                        Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: [
//                            Text('0',style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black) ,), 
//                            Text('600', 
//                              style:Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black) ,)
//                          ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   
//                   
//                   Padding(
//                     padding: const EdgeInsets.only(right: 8.0, top: 20.0,bottom: 14.0),
//                     child: Column(
//                       children: [
//                         Padding(
//                            padding: const EdgeInsets.only(bottom: 12.0),
//                            child: StatefulBuilder(
//                               builder:(context,state)=> Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text('Dip Duration',
//                                 style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black),),
//                                  Container(
//                                    decoration: BoxDecoration(
//                                      
//                                      border: Border.all(width: 0.5),
//                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),),
//                                    child: Padding(
//                                      padding: const EdgeInsets.all(8.0),
//                                      child: Text('${context.watch<MachineDataProvider>().beakers[index].dipDuration} sec',
//                                        style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black)),
//                                    ),
//                                  )
//                                        
//                                ],
//                             ),
//                                            ),
//                          ),
//                         StatefulBuilder(
//                           builder:(context,state)=> SliderTheme(
//                             data: SliderTheme.of(context).copyWith(
//                             thumbShape: ThinThumbShape(enabledThumbRadius: 6.0),
//                             thumbColor: Colors.black,
//                             trackShape: ThinTrackShape(),
//                             overlayShape: SliderComponentShape.noOverlay,
//                             trackHeight: 4.0,
//                             activeTrackColor: Colors.black54,
//                             inactiveTrackColor: Colors.black12,
//                               ),
//                             child: Slider(
//                                 value: context.watch<MachineDataProvider>().beakers[index].dipDuration.toDouble(),
//                                 max: 100,
//                                 min: 0,
//                                 //divisions: 99,
//                                 onChanged:(value){
//                                  
//                                   context.read<MachineDataProvider>().dipDuration(index, value.toInt());
//                                 } ,
//                               ),
//                             
//                           ),
//                         ),
//                             
//                           Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: [
//                            Text('0',style: Theme.of(context).textTheme.labelMedium!.copyWith(color:Colors.black) ,), 
//                            Text('100', style: Theme.of(context).textTheme.labelMedium!.copyWith(color:Colors.black),)
//                          ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//       
//             
//           ],
//         ),//column
//       ),
//     ),
//   );
// }
//
