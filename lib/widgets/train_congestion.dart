import 'package:flutter/material.dart';

class TrainCongestion extends StatelessWidget {
  const TrainCongestion({super.key, required this.trainCarNo, required this.trainCongestion});

  final List<int> trainCarNo;
  final List<int> trainCongestion;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const Icon(Icons.arrow_back),
              const SizedBox(width: 10,),
              for(int i = 0; i < trainCarNo.length; i++)...{
                Column(
                  children: [
                    Text('${trainCarNo[i]}', textAlign: TextAlign.center,),
                    // 混雑度が-1、999となっているときは-を表示する
                    if(trainCongestion[i] < 0 || 500 < trainCongestion[i])...{
                      const Text(' - ', textAlign: TextAlign.center, style: TextStyle(fontSize: 12),),
                    } else...{
                      Text('${trainCongestion[i]}%', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12),),
                    },
                    const SizedBox(height: 10,),
                  ],
                ),
                if(i != trainCarNo.length - 1)...{
                  const SizedBox(
                    height: 40,
                    child: VerticalDivider(),
                  ),
                },
              },
              const SizedBox(width: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
