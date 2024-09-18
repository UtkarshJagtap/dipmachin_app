class Beaker{

  final int index;
  double temp= 1.0;
  int rpm = 0;
  int dipDuration =0;
  bool? isActive;

  
  Beaker({required this.index});

 

}



abstract class MachineData {

  int time = 0;
  int cycles = 1;
  List<Beaker> beakers = [];
  int numberOfBeakers = 6;

 



}



