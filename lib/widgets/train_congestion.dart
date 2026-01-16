import 'package:flutter/material.dart';

class TrainCongestion extends StatelessWidget {
  const TrainCongestion({super.key, required this.trainCarNo, required this.trainCongestion});

  final List<int> trainCarNo;
  final List<int> trainCongestion;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            const Icon(Icons.arrow_back),
            Row(
              children: [
                for(int i = 0; i < trainCarNo.length; i++)...{
                  Column(
                    children: [
                      Text('${trainCarNo[i]}', textAlign: TextAlign.center,),
                      Text('${trainCongestion[i]}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12),),
                    ],
                  ),
                  if(i != trainCarNo.length - 1)...{
                    const SizedBox(
                      height: 40,
                      child: VerticalDivider(),
                    ),
                  }
                }
              ],
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
