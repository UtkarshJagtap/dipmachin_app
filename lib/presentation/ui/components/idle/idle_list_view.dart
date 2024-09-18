
import 'package:dipmachine/presentation/ui/components/idle/cycles_card.dart';
import 'package:dipmachine/presentation/ui/components/idle/idle_beaker_list.dart';
import 'package:dipmachine/presentation/ui/components/idle/idle_storein.dart';
import 'package:flutter/material.dart';


class IdleListView extends StatelessWidget {
  const IdleListView({
    super.key,
   
  });

  

  @override
  Widget build(BuildContext context) {
    return  CustomScrollView(
      slivers: [
        const SliverAppBar(
          backgroundColor: Colors.transparent ,
        ),

        //Number of cycles widget
        const CyclesCard(),

        

        //List of beakers
        
        const IdleBeakerList(),

        IdleStorein(),

        SliverToBoxAdapter(
          child: Container(
            height: 200,
          ),
        )

        


      ],
      );
  }
}


