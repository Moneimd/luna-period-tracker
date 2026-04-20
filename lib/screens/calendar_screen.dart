// lib/screens/calendar_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../providers/period_provider.dart';
import '../utils/theme.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PeriodProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Calendrier',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selected, focused) {
                    setState(() {
                      _selectedDay = selected;
                      _focusedDay = focused;
                    });
                    _showDayOptions(context, provider, selected);
                  },
                  onPageChanged: (focused) =>
                      setState(() => _focusedDay = focused),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppTheme.primaryLight.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    defaultTextStyle: const TextStyle(color: AppTheme.textDark),
                    weekendTextStyle: const TextStyle(
                      color: AppTheme.textMedium,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: AppTheme.primary,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: AppTheme.primary,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (ctx, day, focusedDay) =>
                        _buildDayCell(provider, day),
                    todayBuilder: (ctx, day, focusedDay) =>
                        _buildDayCell(provider, day, isToday: true),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Legend
            Text(
              'Légende',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _legendItem(AppTheme.primary, 'Période'),
                _legendItem(AppTheme.fertile, 'Fenêtre fertile'),
                _legendItem(AppTheme.primaryLight, 'Aujourd\'hui'),
                _legendItem(Colors.purple.shade200, 'Prévision'),
              ],
            ),
            const SizedBox(height: 20),

            // Upcoming
            if (provider.nextPeriodDate != null) ...[
              Text(
                'Prochaine période',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppTheme.primaryLight,
                    child: Icon(Icons.calendar_today, color: AppTheme.primary),
                  ),
                  title: Text(
                    DateFormat(
                      'dd MMMM yyyy',
                      'fr_FR',
                    ).format(provider.nextPeriodDate!),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    provider.daysUntilNextPeriod! > 0
                        ? 'Dans ${provider.daysUntilNextPeriod} jours'
                        : 'C\'est aujourd\'hui!',
                    style: const TextStyle(color: AppTheme.primary),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDayCell(
    PeriodProvider provider,
    DateTime day, {
    bool isToday = false,
  }) {
    final isPeriod = provider.isInPeriod(day);
    final isFertile = provider.isInFertilityWindow(day);

    Color? bgColor;
    Color textColor = AppTheme.textDark;

    if (isPeriod) {
      bgColor = AppTheme.primary;
      textColor = Colors.white;
    } else if (isFertile) {
      bgColor = AppTheme.fertile.withOpacity(0.7);
      textColor = Colors.white;
    } else if (isToday) {
      bgColor = AppTheme.primaryLight.withOpacity(0.5);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.all(4),
      decoration: bgColor != null
          ? BoxDecoration(color: bgColor, shape: BoxShape.circle)
          : null,
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: textColor,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: AppTheme.textMedium, fontSize: 13),
        ),
      ],
    );
  }

  void _showDayOptions(
    BuildContext context,
    PeriodProvider provider,
    DateTime day,
  ) {
    final isPeriod = provider.isInPeriod(day);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat('EEEE dd MMMM', 'fr_FR').format(day),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 16),
            if (!isPeriod)
              ListTile(
                leading: const Icon(Icons.water_drop, color: AppTheme.primary),
                title: const Text('Marquer comme début de période'),
                onTap: () {
                  provider.startPeriod(day);
                  Navigator.pop(ctx);
                },
              ),
            if (isPeriod)
              ListTile(
                leading: const Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryDark,
                ),
                title: const Text('Terminer la période ce jour'),
                onTap: () {
                  provider.endPeriod(day);
                  Navigator.pop(ctx);
                },
              ),
          ],
        ),
      ),
    );
  }
}
