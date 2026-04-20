// lib/screens/stats_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/period_provider.dart';
import '../utils/theme.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PeriodProvider>();
    final sorted = [...provider.periods]
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistiques',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 20),

            // Summary cards
            _buildSummaryRow(provider),
            const SizedBox(height: 24),

            if (sorted.length >= 2) ...[
              Text(
                'Durée des cycles (jours)',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(height: 200, child: _buildCycleChart(sorted)),
                ),
              ),
              const SizedBox(height: 24),
            ],

            Text(
              'Historique',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (provider.periods.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Aucune période enregistrée encore.\nCommencez à suivre votre cycle!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textMedium),
                    ),
                  ),
                ),
              )
            else
              ...sorted.reversed.take(6).map((p) => _buildPeriodTile(p)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(PeriodProvider provider) {
    return Row(
      children: [
        _statCard(
          'Cycles\nenregistrés',
          '${provider.periods.length}',
          Icons.history,
          Colors.indigo,
        ),
        const SizedBox(width: 12),
        _statCard(
          'Cycle\nmoyen',
          '${provider.averageCycleLength.round()}j',
          Icons.loop,
          AppTheme.primary,
        ),
        const SizedBox(width: 12),
        _statCard(
          'Période\nmoyenne',
          '${provider.averagePeriodDuration.round()}j',
          Icons.water_drop,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textMedium,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCycleChart(List periods) {
    final spots = <FlSpot>[];
    for (int i = 1; i < periods.length; i++) {
      final days = periods[i].startDate
          .difference(periods[i - 1].startDate)
          .inDays;
      spots.add(FlSpot(i.toDouble(), days.toDouble()));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (v) =>
              FlLine(color: Colors.grey.shade100, strokeWidth: 1),
          getDrawingVerticalLine: (v) =>
              FlLine(color: Colors.grey.shade100, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (v, _) => Text(
                '${v.round()}',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.textMedium,
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) => Text(
                'C${v.round()}',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.textMedium,
                ),
              ),
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppTheme.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.primary.withOpacity(0.1),
            ),
            dotData: FlDotData(
              getDotPainter: (spot, __, ___, ____) => FlDotCirclePainter(
                radius: 5,
                color: AppTheme.primary,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodTile(dynamic p) {
    final fmt = DateFormat('dd MMM yyyy', 'fr_FR');
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryLight.withOpacity(0.3),
          child: const Icon(
            Icons.water_drop,
            color: AppTheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          fmt.format(p.startDate),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: p.endDate != null
            ? Text(
                'Durée: ${p.duration} jours · fin: ${fmt.format(p.endDate!)}',
                style: const TextStyle(
                  color: AppTheme.textMedium,
                  fontSize: 12,
                ),
              )
            : const Text(
                'En cours...',
                style: TextStyle(color: AppTheme.primary),
              ),
        trailing: p.duration != null
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${p.duration}j',
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
