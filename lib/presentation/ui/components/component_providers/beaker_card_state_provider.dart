import 'package:dipmachine/presentation/providers/machine_data_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

class BeakerCardStateProvider extends ChangeNotifier{

MachineDataProvider machineDataProvider;
List<bool> beakerCardState = <bool>[];
int numberOfBeakers;

BeakerCardStateProvider({required this.machineDataProvider})
: numberOfBeakers = 6
{
  beakerCardState = List.generate(machineDataProvider.numberOfBeakers, (index) => false);
  numberOfBeakers = machineDataProvider.numberOfBeakers;
  developer.log('BeakerCardStateProvider: the cunstructor is called created with $numberOfBeakers beakers and list beakersCardState is of length ${beakerCardState.length}');


}

bool isExpanded(int index){
  if(index > beakerCardState.length -1){
    return false;
  }
  return beakerCardState[index];
}

void onUpdate(MachineDataProvider machineDataProvider){
  developer.log('BeakerCardStateProvider: onUpdate is called checking for numberOfBeakers');
  if(machineDataProvider.numberOfBeakers != numberOfBeakers){ 
    developer.log('BeakerCardStateProvider: numberOfBeakers changed from $numberOfBeakers to ${machineDataProvider.numberOfBeakers}');
    beakerCardState = List.generate(machineDataProvider.numberOfBeakers, (index) => false);
    numberOfBeakers = machineDataProvider.numberOfBeakers;
    notifyListeners();
  }
}

void changeTo(int index, bool state){
  beakerCardState[index] = state;
  notifyListeners();
}

void collapseAll(){
  beakerCardState = List.generate(numberOfBeakers, (index) => false);
  notifyListeners();
}



}
