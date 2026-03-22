import 'package:flutter/material.dart';

class TrainCongestion extends StatelessWidget {
  TrainCongestion({super.key, required this.trainCarNo, required this.trainCongestion, required this.carTypes});

  final List<int> trainCarNo;
  final List<int> trainCongestion;
  final List<String> carTypes;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 60,
              child: VerticalDivider(),
            ),
            for(int i = 0; i < trainCarNo.length; i++)...{
              Column(
                children: [
                  Text('${trainCarNo[i]}', textAlign: TextAlign.center,),
                  // 混雑度が-1、999となっているときは-を表示する
                  if(trainCongestion[i] < 0 || 500 < trainCongestion[i])...{
                    const Text(' - ', textAlign: TextAlign.center, style: TextStyle(fontSize: 13),),
                  } else...{
                    Text(
                      '${trainCongestion[i]}%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: getCongestionColor(trainCongestion[i]),
                      ),
                    ),
                  },
                  const SizedBox(height: 5,),

                  if(carTypes[i].contains('1'))...{
                    const Text('A', style: TextStyle(fontSize: 12),),
                    const SizedBox(height: 5,),
                  }
                  else if(carTypes[i].contains('3'))...{
                    const Text('弱冷', style: TextStyle(fontSize: 12, color: Colors.blue),),
                    const SizedBox(height: 5,),
                  }
                  else if(carTypes[i].contains('4'))...{
                    const Text('女専', style: TextStyle(fontSize: 12, color: Color(0xffff5555)),),
                    const SizedBox(height: 5,),
                  },
                ],
              ),
              const SizedBox(
                height: 60,
                child: VerticalDivider(),
              ),
            },
            const SizedBox(width: 10,),
          ],
        ),
      )
    );
  }

  Color? getCongestionColor(int congestion) {
    if(congestion < 40) {
      return Colors.cyan;
    } else if(congestion < 60) {
      return Colors.green[700];
    } else if(congestion < 80) {
      return Colors.yellow[800];
    } else if(congestion < 100) {
      return Colors.red;
    } else {
      return Colors.deepPurple[800];
    }
  }
}
