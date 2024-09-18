import 'package:dipmachine/presentation/ui/thin_slider_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dipmachine/presentation/providers/machine_data_provider.dart';
class CyclesCard extends StatelessWidget {
  const CyclesCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Padding(
      padding: const EdgeInsets.only(top:0.0, left: 15, right: 15, bottom: 25),
      child: Container(
        height: 125,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1) ,
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
    
        child:  Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Number of Cycles', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black),),
                Container(
                  decoration: const BoxDecoration(color: Colors.white, 
                  borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Selector<MachineDataProvider, int>(
                    selector: (_,machinedataProvider) => machinedataProvider.cycles,
                    builder: (context,cycles,_) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('$cycles', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black),),
                    ),
                    ),
                  )
                ],
              ),
          
               Padding(
                 padding: const EdgeInsets.only(top:15.0),
                 child: SliderTheme(
                   data: SliderTheme.of(context).copyWith(
                     thumbShape: ThinThumbShape(enabledThumbRadius: 8.0),
                     thumbColor: Colors.black,
                     trackShape: ThinTrackShape(),
                     overlayShape: SliderComponentShape.noOverlay,
                     trackHeight: 4.0,
                     activeTrackColor: Colors.black54,
                     inactiveTrackColor: Colors.black12,
                     ),
                   child: Slider(
                     value: context.watch<MachineDataProvider>().cycles.toDouble(),
                     max: 150,
                     min: 1,
                     divisions: 150,
                     onChanged:(value){
                       context.read<MachineDataProvider>().noOfCyclesFromUI = value.toInt();
                     } ,
                   ),
                 ),
               ),
    
               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                 children: [
                   Text('1', style: Theme.of(context).textTheme.labelMedium,),
                    Text('150',style: Theme.of(context).textTheme.labelMedium,)
                 ],
                 )
            ],
          ),
        )),
    ));
  }
}
