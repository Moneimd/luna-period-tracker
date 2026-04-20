// lib/widgets/phase_banner.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../utils/theme.dart';

class PhaseBanner extends StatelessWidget {
  final String phase;
  const PhaseBanner({super.key, required this.phase});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>();
    final info = _getPhaseInfo(phase, t);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [info.color.withOpacity(0.15), info.color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: info.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(info.icon, color: info.color, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: info.color,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  info.description,
                  style: const TextStyle(
                    color: AppTheme.textMedium,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _PhaseInfo _getPhaseInfo(String phase, LanguageProvider t) {
    switch (phase) {
      case 'menstrual':
        return _PhaseInfo(
          icon: Icons.water_drop,
          title: t.phaseMenstruelle,
          description: t.phaseMenstruelleDesc,
          color: AppTheme.primary,
        );
      case 'follicular':
        return _PhaseInfo(
          icon: Icons.eco,
          title: t.phaseFolliculaire,
          description: t.phaseFolliculaireDesc,
          color: Colors.teal,
        );
      case 'ovulation':
        return _PhaseInfo(
          icon: Icons.spa,
          title: t.ovulation,
          description: t.ovulationDesc,
          color: AppTheme.fertile,
        );
      case 'premenstrual':
        return _PhaseInfo(
          icon: Icons.nightlight_round,
          title: t.premenstruelle,
          description: t.premenstruelleDesc,
          color: Colors.purple,
        );
      default:
        return _PhaseInfo(
          icon: Icons.add_circle_outline,
          title: t.commencezSuivi,
          description: t.commencezSuiviDesc,
          color: AppTheme.primaryLight,
        );
    }
  }
}

class _PhaseInfo {
  final IconData icon;
  final String title, description;
  final Color color;
  _PhaseInfo({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
