
import 'package:dipmachine/presentation/providers/machine_data_provider.dart';
import 'package:dipmachine/presentation/providers/machine_state_provider.dart';
import 'package:dipmachine/presentation/providers/network_data_provider.dart';
import 'package:dipmachine/presentation/providers/websocket_data_provider.dart';
import 'package:dipmachine/presentation/ui/components/component_providers/beaker_card_state_provider.dart';
import 'package:dipmachine/presentation/ui/components/idle/idle_actionbar.dart';
import 'package:dipmachine/presentation/ui/components/working/working_actionbar.dart';
import 'package:dipmachine/presentation/ui/components/powerloss/powerloss_actionbar.dart';
import 'package:dipmachine/presentation/ui/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:dipmachine/presentation/ui/text_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create:(context)=> NetworkDataProvider(),
          lazy: false,
          ),

        ChangeNotifierProxyProvider<NetworkDataProvider,WebsocketDataProvider>(
          create: (context)=> WebsocketDataProvider(networkDataProvider: context.read<NetworkDataProvider>()),
          update: (context, networkdata, previouswebsocketdata){
            previouswebsocketdata!.onNewNetworkState(networkdata);
            return previouswebsocketdata;
          },
          lazy: false,
          ),

        ChangeNotifierProxyProvider2<NetworkDataProvider, WebsocketDataProvider, MachineStateProvider>(
          create: (context)=> MachineStateProvider(
            networkDataProvider: context.read<NetworkDataProvider>(),
            websocketDataProvider: context.read<WebsocketDataProvider>()
            ),
          update: (context, networkData, webSocketData, previousMachineState){
            previousMachineState!.onSomethingChanged(networkData, webSocketData);
            return previousMachineState;
          }, 
          lazy: false,
          ),
        
        ChangeNotifierProxyProvider<WebsocketDataProvider, MachineDataProvider>(
          create: (context)=> MachineDataProvider(),
          update: (context, websocketProvider, previousMachineData){
            previousMachineData!.onNewData(websocketProvider.newData);
            return previousMachineData;
          },
          lazy: false,
          ),

        ChangeNotifierProxyProvider<MachineDataProvider, BeakerCardStateProvider>(
          create: (context) => BeakerCardStateProvider(machineDataProvider: context.read<MachineDataProvider>()),
          update:(context, machinedataprovider, previousbeakercardstate){
            previousbeakercardstate!.onUpdate(machinedataprovider);
            return previousbeakercardstate;
          },
          lazy: false,

          ),

          ChangeNotifierProvider<IdleActionbarStateProvider>(
            create: (context)=> IdleActionbarStateProvider()
          ),

          ChangeNotifierProxyProvider< MachineStateProvider,WorkingActionbarStateProvider>(
            create: (context)=> WorkingActionbarStateProvider(),
            update: (context, value, previous) {
              previous!.onUpdate(value.state);
              return previous;
            },
          ),

          ChangeNotifierProxyProvider< MachineStateProvider,PowerlossActionbarStateProvider>(
            create: (context)=> PowerlossActionbarStateProvider(),
            update: (context, value, previous) {
              previous!.onUpdate(value.state);
              return previous;
            },
          )
          

      ],
      child: MaterialApp(
        theme: ThemeData(
          textTheme: dipTextTheme,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Skeleton(),
      ),
    );
  }
}

class WidgetThatHoldsSkeleton extends StatelessWidget {
  const WidgetThatHoldsSkeleton({super.key});


  @override
  Widget build(BuildContext context) {
    return Selector<MachineStateProvider, String>(
      selector: (_, machinestate) => machinestate.state.name,
      builder: (con,state, _)=> const Skeleton(),
      );
  }
}
