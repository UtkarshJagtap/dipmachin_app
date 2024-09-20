import 'dart:convert';
import 'package:dipmachine/domain/machine_data.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class MachineDataProvider extends ChangeNotifier implements MachineData {
  Map<String, dynamic> newData = {};

  @override
  int cycles;

  @override
  int time;

  @override
  int numberOfBeakers;

  @override
  List<Beaker> beakers = [];

  List<int> setDipDuration = [];
  List<int> setDipRPM = [];
  List<int> setDipTemperature = [];

  int onCycle = 0;
  int storeIn = 0;
  bool haltRecheck = true;
  String errorMessage = '';

  MachineDataProvider()
      : cycles = 1,
        time = 6,
        numberOfBeakers = 3 {
    beakers = List.generate(numberOfBeakers, (index) => Beaker(index: index+1));
    developer.log('MachineDataProvider Created');
  }

  double beakerTemp(int index){
    if(index> beakers.length-1) {
      return 1;
    }
    return beakers[index].temp;
  }

  int beakerIndex(int index){
    if(index> beakers.length-1){
    return 0;
    }
    return beakers[index].index;
  }

  int beakerRPM(int index) {
    if (index > beakers.length-1) {
      return 0;
    }
    return beakers[index].rpm;
  }

  int beakerDipDuration(int index) {
    if (index > beakers.length-1) {
      return 0;
    }
    return beakers[index].dipDuration;
  }
 bool? beakerActive(int index) {
    if (index > beakers.length-1) {
      return false;
    }
    return beakers[index].isActive;
  }

  void resetMachineData(){
    cycles = 1;
    time = 6;
    numberOfBeakers = 6; 
    beakers = List.generate(numberOfBeakers, (index) => Beaker(index: index+1));
    notifyListeners();
  }

  void tempFromSlider(int index, int temp) {
    beakers[index].temp = temp.toDouble();
 
    notifyListeners();
  }

  void rpm(int index, int rpm) {
    beakers[index].rpm = rpm;
    notifyListeners();
  }

  void dipDuration(int index, int dipDuration) {
    beakers[index].dipDuration = dipDuration;
    notifyListeners();
  }

  set noOfCyclesFromUI(int x){
    cycles = x;
    notifyListeners();
  }

  set noOfBeakersfromUI(int x) {
    if (x < 1 || x > 6) {
      throw ArgumentError('invalid argument for numberOfBeakers');
    } else if(x>numberOfBeakers) {
      int morebeak = x - numberOfBeakers;
      
      beakers =[...beakers, 
      ...List.generate(morebeak, (index) => Beaker(index: numberOfBeakers+index+1))];
     numberOfBeakers =x;
     notifyListeners();
     // numberOfBeakers = x;
     // beakers = [];
     // beakers = List.generate(numberOfBeakers, (index) => Beaker(index: index));
      //notifyListeners();
    }else if(x<numberOfBeakers){
      beakers =[...beakers.sublist(0, x)];
      numberOfBeakers = x;
      notifyListeners();
    }
  }

  set noOfBeakers(int x) {
    if (x < 1 || x > 6) {
      throw ArgumentError('invalid argument for numberOfBeakers');
    } else {
      //if(x>numberOfBeakers){}
      numberOfBeakers = x;
      beakers = [];
      beakers = List.generate(numberOfBeakers, (index) => Beaker(index: index+1));
      notifyListeners();
    }
  }
  set storein(int store) {
    
     storeIn = store;
     developer.log('changed to $storeIn');
     notifyListeners();
  }

  void calculateTime() {
    int ts = 0;
    developer.log('number of beakers $numberOfBeakers');
    for (int i = 0; i < numberOfBeakers; i++) {
      
      ts += beakers[i].dipDuration;
    }

    developer.log('the ts $ts');

    //TODO:change this using correct fromula
    developer.log('$cycles');
    time = (ts * cycles) + (numberOfBeakers * 20) + 900;
    developer.log('newly calculated time is $time');
    notifyListeners();
  }

  void onNewData(Map<String, dynamic> newD) {
    newData = newD;
    developer.log('MachineDataProvider has called onNewData: Now we will check if its either working or powerloss');

    if(newData['state']=='IDLE'){
      errorMessage = '';
    }

    if (newData['state'] == 'POWERLOSS' || newData['state'] == 'WORKING' ) {
      developer.log('MachineDataProvider has detected state to be either powerloss or working, now we will updatemachinedata');
      updateMachineData();
    }

    if(newData['state'] == 'HALT'){
      developer.log('Halt state detected');
      errorMessage = newData['error'];
      changeHaltRecheck(true);
    }
  }

  void updateMachineData() {
    if(numberOfBeakers != newData['activeBeakers']){
    noOfBeakers = newData['activeBeakers'];
    }
    
    time = newData['timeLeft'];
    
    cycles = newData['setCycles'];
    onCycle = newData['onCycle'];
    developer.log('cycles left: $onCycle');

    if (newData['state'] == 'POWERLOSS') {

      developer.log('MachineDataProvider has detected state to be powerloss');
      for (int i = 0; i < numberOfBeakers; i++) {
        developer.log('Updating beaker $i');
        beakers[i].rpm = newData['setDipRPM'][i];
        beakers[i].temp = newData['setDipTemperature'][i].toDouble();
        beakers[i].dipDuration = newData['setDipDuration'][i];
        beakers[i].isActive = false;
      }

      beakers[newData['onBeaker']-1].isActive = true;
    }

    if (newData['state'] == 'WORKING') { 
      developer.log('MachineDataProvider has detected state to be working');
      for (int i = 0; i < numberOfBeakers; i++) {
        developer.log('Updating beaker $i');
        beakers[i].rpm = newData['setDipRPM'][i];
        beakers[i].temp = newData['currentTemp'][i].toDouble();
        beakers[i].dipDuration = newData['setDipDuration'][i];
        beakers[i].isActive = false;
      }
      

      beakers[newData['onBeaker']].isActive = true;
      for(int i =0; i< numberOfBeakers; i++){
        developer.log(' beaker $i isActive : ${beakers[i].isActive}');
      }
    }
    developer.log('MachineDataProvder: eof');
    notifyListeners();
  }

  void changeHaltRecheck(bool state){
    haltRecheck = state;
    notifyListeners();
  }
  Future<void> convertBeakersinLists() async {
    setDipDuration =[];
    setDipRPM=[];
    setDipTemperature=[];
    for (var i = 0; i < numberOfBeakers; i++) {
      setDipDuration.add(beakers[i].dipDuration);
      setDipRPM.add(beakers[i].rpm);
      setDipTemperature.add(beakers[i].temp.toInt());
    }
  }


  Map<String, dynamic> toJson() => {
        'state': "start",
        'setCycles': cycles,
        'activeBeakers': numberOfBeakers,
        'setDipDuration': setDipDuration,
        'setDipRPM': setDipRPM,
        'setDipTemperature': setDipTemperature,
        'storeIn' : storeIn
      };


  Future<String> getsendData() async {
    // String data
    await convertBeakersinLists();
    String data = jsonEncode(this);
    return data;
  }

}
