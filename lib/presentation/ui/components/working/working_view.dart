import 'package:dipmachine/presentation/providers/machine_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkingView extends StatelessWidget {
  const WorkingView({super.key, required this.mstate});
  final String mstate;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: UniqueKey(),
      slivers: [
      const SliverAppBar(backgroundColor:Colors.transparent),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index){
            return WorkingViewListCard(index: index,);
          },
          childCount: context.select<MachineDataProvider, int>((value)=> value.numberOfBeakers)
          ),
        ),
      const SliverToBoxAdapter(
        child: WorkingInfoCard(),
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


class WorkingViewListCard extends StatelessWidget {
  const WorkingViewListCard({super.key, required this.index});
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
              child: Text('${context.select<MachineDataProvider, double>((value)=>value.beakerTemp(index)).toStringAsFixed(2)} °C',
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
              child: WorkingStatusIndicator(index: index,),
              // child: Container(
              //   height: 8,
              //   width: 8,
              //   decoration: BoxDecoration( 
              //     color: context.watch<MachineDataProvider>().beakerActive(index) ?? false ? Colors.green : Colors.transparent,
              //     shape: BoxShape.circle,
              //     ),
              //   )
              )
          ],
        ),
      ),
    );
  }
}


class WorkingInfoCard extends StatelessWidget {
  const WorkingInfoCard({super.key});

  String _getStoreIn(BuildContext context){
      int storeIn = context.select<MachineDataProvider, int>((value) => value.storeIn);
      if( storeIn == 0) return 'In air';
      return '$storeIn';

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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Store In:',
                  style: Theme.of(context).textTheme.labelMedium,),
              ),
          
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(_getStoreIn(context)),
                  ),
                  ),
              )
              ],
            ),
        ),
      ),
    );
  }
}

class WorkingStatusIndicator extends StatefulWidget {
   const WorkingStatusIndicator({
    super.key,
    required this.index,
  });

 final int index;

  @override
  State<WorkingStatusIndicator> createState() => _WorkingStatusIndicatorState();
}

class _WorkingStatusIndicatorState extends State<WorkingStatusIndicator> with SingleTickerProviderStateMixin{

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

    _animation = Tween<double>(begin: 0.0, end: 2.0).animate(_controller)
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
    return Container(
      height: 6,
      width: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.watch<MachineDataProvider>().beakerActive(widget.index) ?? false ? Colors.green : Colors.transparent,
        boxShadow: [
          BoxShadow(
           color: context.watch<MachineDataProvider>().beakerActive(widget.index) ?? false ? Colors.green : Colors.transparent,
           blurRadius: 4,
           spreadRadius: _animation.value,
           blurStyle: BlurStyle.normal,
          )],
        ),
      );
  }
}