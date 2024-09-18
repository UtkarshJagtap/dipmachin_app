abstract class MachineState {

  MachineStates state = MachineStates.disconnect;


 

}

enum MachineStates {
  halt,
  initial,
  disconnect,
  idle,
  powerloss,
  working,
  done
}
