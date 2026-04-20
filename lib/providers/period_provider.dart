// lib/providers/period_provider.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/period.dart';

class PeriodProvider with ChangeNotifier {
  List<Period> _periods = [];
  static const _storageKey = 'periods_data';

  List<Period> get periods => List.unmodifiable(_periods);

  Period? get activePeriod {
    try {
      return _periods.firstWhere((p) => p.isActive);
    } catch (_) {
      return null;
    }
  }

  Period? get lastPeriod {
    final completed = _periods.where((p) => !p.isActive).toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
    return completed.isEmpty ? null : completed.first;
  }

  double get averageCycleLength {
    if (_periods.length < 2) return 28.0;
    final sorted = [..._periods]
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    int total = 0;
    for (int i = 1; i < sorted.length; i++) {
      total += sorted[i].startDate.difference(sorted[i - 1].startDate).inDays;
    }
    return total / (sorted.length - 1);
  }

  double get averagePeriodDuration {
    final completed = _periods.where((p) => p.duration != null).toList();
    if (completed.isEmpty) return 5.0;
    final total = completed.fold<int>(0, (sum, p) => sum + p.duration!);
    return total / completed.length;
  }

  DateTime? get nextPeriodDate {
    final last = lastPeriod ?? activePeriod;
    if (last == null) return null;
    return last.startDate.add(Duration(days: averageCycleLength.round()));
  }

  int? get daysUntilNextPeriod {
    if (nextPeriodDate == null) return null;
    return nextPeriodDate!.difference(DateTime.now()).inDays;
  }

  /// Returns the fertility window (ovulation ± 2 days)
  DateTimeRange? get fertilityWindow {
    final last = lastPeriod ?? activePeriod;
    if (last == null) return null;
    final ovulationDay = last.startDate.add(
      Duration(days: (averageCycleLength - 14).round()),
    );
    return DateTimeRange(
      start: ovulationDay.subtract(const Duration(days: 2)),
      end: ovulationDay.add(const Duration(days: 2)),
    );
  }

  String get cyclePhase {
    if (activePeriod != null) return 'menstrual';
    if (nextPeriodDate == null) return 'unknown';
    final now = DateTime.now();
    final fw = fertilityWindow;
    if (fw != null && now.isAfter(fw.start) && now.isBefore(fw.end)) {
      return 'ovulation';
    }
    final daysLeft = daysUntilNextPeriod ?? 99;
    if (daysLeft <= 5) return 'premenstrual';
    return 'follicular';
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);
    if (data != null) {
      final List decoded = jsonDecode(data);
      _periods = decoded.map((e) => Period.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(_periods.map((p) => p.toJson()).toList()),
    );
  }

  Future<void> startPeriod(DateTime date) async {
    // End active period if exists
    if (activePeriod != null) {
      await endPeriod(date.subtract(const Duration(days: 1)));
    }
    _periods.add(Period(startDate: date));
    notifyListeners();
    await _save();
  }

  Future<void> endPeriod(DateTime date) async {
    final idx = _periods.indexWhere((p) => p.isActive);
    if (idx == -1) return;
    _periods[idx] = _periods[idx].copyWith(endDate: date);
    notifyListeners();
    await _save();
  }

  Future<void> updatePeriod(int index, Period updated) async {
    _periods[index] = updated;
    notifyListeners();
    await _save();
  }

  Future<void> deletePeriod(int index) async {
    _periods.removeAt(index);
    notifyListeners();
    await _save();
  }

  bool isInPeriod(DateTime date) {
    return _periods.any((p) => p.containsDate(date));
  }

  bool isInFertilityWindow(DateTime date) {
    final fw = fertilityWindow;
    if (fw == null) return false;
    final d = DateTime(date.year, date.month, date.day);
    return d.isAfter(fw.start.subtract(const Duration(days: 1))) &&
        d.isBefore(fw.end.add(const Duration(days: 1)));
  }

  String get phaseDescription {
    switch (cyclePhase) {
      case 'menstrual':
        return 'Période menstruelle 🩸';
      case 'follicular':
        return 'Phase folliculaire 🌱';
      case 'ovulation':
        return 'Période d\'ovulation 🌸';
      case 'premenstrual':
        return 'Phase prémenstruelle 🌙';
      default:
        return 'Ajoutez votre première période';
    }
  }
}

class DateTimeRange {
  final DateTime start;
  final DateTime end;
  DateTimeRange({required this.start, required this.end});
}
