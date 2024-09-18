import 'package:dipmachine/presentation/providers/machine_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


class IdleStorein extends StatelessWidget {
  IdleStorein({super.key});

  final List<String> _storeInList = ['in air', '1', '2', '3', '4', '5', '6'];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: Colors.black,
              width: 0.8,
            )
          ),
          height: 130,
          child: Padding(
            padding: const EdgeInsets.only(top:16, right: 8, left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Where do you want slide after the experiment? in the air? or in the beaker?',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                )),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer<MachineDataProvider>(
                      builder: (context, provider, child) {
                        int storeIn = provider.storeIn;
                        Set<String> selected = {storeIn.toString()};
                        
                        return SegmentedButton<String>(
                          multiSelectionEnabled: false,
                          showSelectedIcon: false,
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )
                            ),
                            backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                              if (states.contains(WidgetState.selected)) {
                                return Colors.white;
                              }
                              return Colors.transparent;
                            })
                          ),
                          segments: List.generate(7, (index) {
                            return ButtonSegment<String>(
                              label: Center(
                                child: Text(_storeInList[index],
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 12)
                                ),
                              ),
                              value: index.toString(),
                            );
                          }),
                          selected: selected,
                          onSelectionChanged: (Set<String> value) {
                            provider.storein = int.parse(value.first);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}