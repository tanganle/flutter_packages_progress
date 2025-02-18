import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_progress/component/cicular_progress.dart';

class Progress extends StatelessWidget {
  const Progress({
    super.key,
    this.jsonData = const {},
  });
  final Map<String, dynamic> jsonData;

  @override
  Widget build(BuildContext context) {
    double value = 5; //进度条的值
    Color backgroundColor = Colors.grey.shade300; //背景颜色
    Color fillColor = Colors.blue.shade400; //填充颜色
    bool isRounded = true; //是否有线帽
    bool overlapEndCaps = false; //是否为重叠线帽

    double size = 200; //圆形进度条的宽高
    double strokeWidth = 15; //圆形进度条的线宽
    double startAngle = 0; //圆形进度条的开口角度
    String openDirection = "up"; //圆形进度条的开口方向
    bool showTicks = false; //是否显示刻度
    int tickCount = 60;
    int tickInterval = 1;
    double tickLongLength = 10;
    Color tickLongColor = Colors.black;
    double tickLongWidth = 2;
    double tickLongInterval = 5;
    double tickLowLength = 5;
    Color tickLowColor = Colors.black;
    double tickLowWidth = 1;

    double pointerLength = size - 2 * strokeWidth - 5;

    bool showPointer = true; //是否显示指针

    Color pointerColor = Colors.black; //长刻度线的颜色
    double pointerWidth = 2;

    // totalValue 剩余的总进度大小
    /// fillValue 是剩余总进度的占比
    ///
    ///  startAngle 圆形进度条的开口角度
    double totalValue = (360 - startAngle);
    double fillValue = (totalValue * value) / 100;

    double startAngleNum = startAngle / 2;
    double pointerNum = startAngle / 2;
    switch (openDirection) {
      case "down":
        startAngleNum = startAngle + 180 - startAngleNum;

        /// 圆环的起点角度 + 滑动的调度  减去偏差的90°
        pointerNum = (startAngle / 2 + fillValue) * pi / 180 - pi / 2;
        break;
      case "up":
        startAngleNum = startAngleNum;
        pointerNum = (startAngle / 2 + fillValue - 180) * pi / 180 - pi / 2;

        break;
      case "left":
        startAngleNum = startAngle + 270 - startAngleNum;
        pointerNum = (startAngle / 2 + fillValue + 90) * pi / 180 - pi / 2;

        break;
      case "right":
        startAngleNum = startAngle + 90 - startAngleNum;
        pointerNum = (startAngle / 2 + fillValue - 90) * pi / 180 - pi / 2;

        break;

      default:
        startAngleNum = startAngle + 180 - startAngleNum;
        pointerNum = (fillValue - startAngleNum) * pi / 180 - pi;
    }

    if (!overlapEndCaps) {
      //不能重叠
      if (startAngle > 0) {
        overlapEndCaps = true;
      }
    }
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          //背景圆环
          CicularProgress(
            isRounded: isRounded,
            size: size,
            strokeWidth: strokeWidth,
            color: backgroundColor,
            gapAngle: totalValue,
            startAngle: startAngleNum,
            showTicks: showTicks,

            /// 刻度内容要放在背景圆环中
            tickCount: tickCount,
            tickLongLength: tickLongLength,
            tickLowLength: tickLowLength,
            tickLongColor: tickLongColor,
            tickLongInterval: tickLongInterval,
            tickInterval: tickInterval,
            tickLongWidth: tickLongWidth,
            tickLowColor: tickLowColor,
            tickLowWidth: tickLowWidth,
            overlapEndCaps: true,
          ),
          //圆环的填充内容
          CicularProgress(
            isRounded: isRounded,
            overlapEndCaps: overlapEndCaps,
            size: size,
            strokeWidth: strokeWidth,
            color: fillColor,
            gapAngle: fillValue,
            startAngle: startAngleNum,
            gradient: const SweepGradient(
              colors: [
                Color(0xfff1a17f),
                Color(0xffdcd57d),
                Color(0xff48eca9),
                Color(0xfff6528f),
                Color(0xfff1a17f)
              ],
              stops: [0, 0.4, 0.746, 0.746, 1],
              center: Alignment.center,
              startAngle: pi / 180 * 5,
              endAngle: 6.283185307179586,
            ),
            child: showPointer
                ? SizedBox(
                    width: jsonData["pointerLength"] == ""
                        ? size - 2 * strokeWidth - 5
                        : pointerLength,
                    height: jsonData["pointerLength"] == ""
                        ? size - 2 * strokeWidth - 5
                        : pointerLength,
                    child: Transform.rotate(
                      angle: pointerNum,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: pointerWidth,
                              color: pointerColor,
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
