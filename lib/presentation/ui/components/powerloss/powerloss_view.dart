import 'package:dipmachine/presentation/providers/machine_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PowerlossView extends StatelessWidget {
  const PowerlossView({super.key, required this.mstate});
  final String mstate;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: UniqueKey(),
      slivers: [
      const SliverAppBar(backgroundColor:Colors.transparent),

      const SliverToBoxAdapter(
        child: PowerlossTopCard(),
        ),

      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index){
            return PowerlossViewCard(index: index,);
          },
          childCount: context.select<MachineDataProvider, int>((value)=> value.numberOfBeakers)
          ),
        ),

      SliverToBoxAdapter(
        child: Container(
          height: 300,
          ),
        )
      ],
   );
  }
}

class PowerlossTopCard extends StatelessWidget {
  const PowerlossTopCard({super.key});

  String _getStoreIn(BuildContext context){
      int storeIn = context.select<MachineDataProvider, int>((value) => value.storeIn);
      if( storeIn == 0) return 'In air';
      return '$storeIn';

  } 
  String _getTimeLeft(BuildContext context) {
    int time = context.select<MachineDataProvider, int>((value) => value.time);

    if (time ~/ 60 >= 59) {
      return '${time ~/ 3600}hrs ${time % 60}mins';
    } else if (time ~/ 60 < 59 && time ~/ 60 >= 1) {
      return '${time ~/ 60}min ${time % 60}sec ';
    }

    return '$time sec ';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: Colors.black,
            width: 1,
            )
          ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('On Cycle',
                      style: Theme.of(context).textTheme.labelMedium),
                  ),
              
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                              color: Colors.black,
                              width: 0.5,
                            )
                          ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${context.read<MachineDataProvider>().onCycle} /${context.read<MachineDataProvider>().cycles}',
                          style: Theme.of(context).textTheme.labelMedium),
                      ),
                      ),
                  )
              
                ],
                ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Time Left',
                      style: Theme.of(context).textTheme.labelMedium),
                  ),
              
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                              color: Colors.black,
                              width: 0.5,
                            )
                          ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_getTimeLeft(context),
                          style: Theme.of(context).textTheme.labelMedium),
                      ),
                      ),
                  )
                ],
                ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Store In',
                      style: Theme.of(context).textTheme.labelMedium),
                  ),
              
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                              color: Colors.black,
                              width: 0.5,
                            )
                          ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_getStoreIn(context), 
                          style: Theme.of(context).textTheme.labelMedium),
                      ),
                      ),
                  )
              
                ],
                ),
            ),


          ],
          ),
      ),
    );
  }
}


class PowerlossViewCard extends StatelessWidget {
  const PowerlossViewCard({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 75,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
            width: 1,
            )
          ),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              ), 
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration( 
                  color: context.watch<MachineDataProvider>().beakerActive(index) ?? false ? Colors.green : Colors.transparent,
                  shape: BoxShape.circle,
                  ),
                )
              )
          ],
        ),
      ),
    );
  }
}
