import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hele_app/model/rating.dart';

// 评分图表
class RatingGraph extends StatelessWidget {
  const RatingGraph({
    super.key,
    required this.count,
  });

  final Count count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    List<int> ratingCountList = count.toList();

    // 设置动态范围
    int max = ratingCountList.reduce((a, b) => a > b ? a : b);
    int min = ratingCountList.reduce((a, b) => a < b ? a : b);
    int range = max - min;
    double ratio;

    // 动态比例
    if (range <= 100) {
      ratio = 0.3;
    } else if (range <= 500) {
      ratio = 0.15;
    } else if (range <= 1000) {
      ratio = 0.075;
    } else {
      ratio = 0.05;
    }

    // 动态最大值
    double dynamic = range * ratio;
    double maxY = max + dynamic <= 0 ? 5.0 : max + dynamic;
    log(maxY.toString());

    return BarChart(
      BarChartData(
        barGroups: List.generate(10, (i) {
          return makeGroupData(
            i,
            double.parse(ratingCountList[i].toString()),
            maxY: maxY,
            colorScheme: colorScheme,
          );
        }),
        maxY: maxY,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipRoundedRadius: 12.sp,
            getTooltipColor: (_) => colorScheme.primary,
          ),
          // 触摸回调
          touchCallback: (FlTouchEvent event, barTouchResponse) {},
        ),
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        // 隐藏网格
        gridData: const FlGridData(show: false),
        // 隐藏边框
        borderData: FlBorderData(show: false),
      ),
      swapAnimationDuration: const Duration(milliseconds: 1000),
      swapAnimationCurve: Curves.linearToEaseOut,
    );
  }

  /// 每条数据
  BarChartGroupData makeGroupData(
    int x,
    double y, {
    List<int> showTooltips = const [],
    required double maxY,
    required ColorScheme colorScheme,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: y,
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.4)],
          ),
          width: 32.w,
          borderRadius: BorderRadius.circular(14.w),
          backDrawRodData: BackgroundBarChartRodData(show: true, color: colorScheme.onPrimary, fromY: maxY),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}
