// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackpe/const.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/period_provider.dart';
import '../providers/language_provider.dart';
import '../utils/theme.dart';
import '../widgets/cycle_ring.dart';
import '../widgets/info_card.dart';
import '../widgets/phase_banner.dart';
import 'calendar_screen.dart';
import 'log_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
//https://sites.google.com/view/nxstunnel/home
  Future<void> _openPrivacy() async {
    final uri = Uri.parse('https://sites.google.com/view/nxstunnel/home');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Consumer<LanguageProvider>(
          builder: (context, t, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  children: [
                    Icon(Icons.language, color: AppTheme.primary),
                    SizedBox(width: 10),
                    Text(
                      'Language',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _LangTile(
                  label: 'Français',
                  sublabel: 'French',
                  selected: !t.isEnglish,
                  onTap: () {
                    t.setLanguage('fr');
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 8),
                _LangTile(
                  label: 'English',
                  sublabel: 'English',
                  selected: t.isEnglish,
                  onTap: () {
                    t.setLanguage('en');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>();

    final screens = [
      const _DashboardTab(),
      const CalendarScreen(),
      const StatsScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          screens[_currentIndex],
          Positioned(
            top: MediaQuery.of(context).padding.top + 4,
            right: 4,
            child: Row(
              children: [
                IconButton(
                  onPressed: _openPrivacy,
                  icon: const Icon(Icons.lock_outline, color: AppTheme.primary),
                  tooltip: t.privacyTitle,
                ),
                IconButton(
                  onPressed: () => _showLanguageSheet(context),
                  icon: const Icon(Icons.language, color: AppTheme.primary),
                  tooltip: 'Language',
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) {
          gAds.interInstance.showInterstitialAd();
          setState(() => _currentIndex = i);
        },
        backgroundColor: Colors.white,
        indicatorColor: AppTheme.primaryLight.withOpacity(0.3),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home, color: AppTheme.primary),
            label: t.accueil,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(
              Icons.calendar_month,
              color: AppTheme.primary,
            ),
            label: t.calendrier,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart, color: AppTheme.primary),
            label: t.statistiques,
          ),
        ],
      ),
    );
  }
}

// ── Language Tile ─────────────────────────────────────────────────────────────

class _LangTile extends StatelessWidget {
  final String label, sublabel;
  final bool selected;
  final VoidCallback onTap;
  const _LangTile({
    required this.label,
    required this.sublabel,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primary.withOpacity(0.08)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppTheme.primary : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? AppTheme.primary : AppTheme.textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  sublabel,
                  style: const TextStyle(
                    color: AppTheme.textMedium,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (selected)
              const Icon(Icons.check_circle, color: AppTheme.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Dashboard Tab ─────────────────────────────────────────────────────────────

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PeriodProvider>();
    final t = context.watch<LanguageProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.hello,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textMedium,
                    ),
                  ),
                  Text(
                    t.monCycle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Center(
              child: CycleRing(
                cycleLength: provider.averageCycleLength.round(),
                currentDay: provider.lastPeriod != null
                    ? DateTime.now()
                              .difference(provider.lastPeriod!.startDate)
                              .inDays +
                          1
                    : 0,
                phase: provider.cyclePhase,
                isActive: provider.activePeriod != null,
              ),
            ),
            const SizedBox(height: 16),

            PhaseBanner(phase: provider.cyclePhase),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: provider.activePeriod == null
                  ? ElevatedButton.icon(
                      onPressed: () {
                        gAds.rewardInstance.showRewardAd(() {
                          print('Rewarded ad shown');
                        });
                        _showLogDialog(context, provider, t);
                      },
                      icon: const Icon(Icons.add),
                      label: Text(t.commencerPeriode),
                    )
                  : ElevatedButton.icon(
                      onPressed: () {
                        gAds.rewardInstance.showRewardAd(() {
                          print('Rewarded ad shown');
                        });
                        _endPeriod(context, provider, t);
                      },
                      icon: const Icon(Icons.check),
                      label: Text(t.terminerPeriode),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryDark,
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  gAds.rewardInstance.showRewardAd(() {
                    print('Rewarded ad shown');
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LogScreen()),
                  );
                },
                icon: const Icon(Icons.edit_note, color: AppTheme.primary),
                label: Text(
                  t.ajouterSymptomes,
                  style: const TextStyle(color: AppTheme.primary),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              t.votreCycle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InfoCard(
                    icon: Icons.calendar_today,
                    title: t.prochainePeriode,
                    value: provider.daysUntilNextPeriod != null
                        ? provider.daysUntilNextPeriod! > 0
                              ? '${t.dans} ${provider.daysUntilNextPeriod} ${t.j}'
                              : t.aujourdhui
                        : '--',
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InfoCard(
                    icon: Icons.loop,
                    title: t.dureeCycle,
                    value: '${provider.averageCycleLength.round()} ${t.jours}',
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InfoCard(
                    icon: Icons.water_drop,
                    title: t.dureePeriode,
                    value:
                        '${provider.averagePeriodDuration.round()} ${t.jours}',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InfoCard(
                    icon: Icons.spa,
                    title: t.fertilite,
                    value: provider.fertilityWindow != null
                        ? 'J${(provider.fertilityWindow!.start.difference(provider.lastPeriod?.startDate ?? DateTime.now()).inDays + 1)}-J${(provider.fertilityWindow!.end.difference(provider.lastPeriod?.startDate ?? DateTime.now()).inDays + 1)}'
                        : '--',
                    color: AppTheme.fertile,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLogDialog(
    BuildContext context,
    PeriodProvider provider,
    LanguageProvider t,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          t.commencerTitre,
          style: const TextStyle(color: AppTheme.textDark),
        ),
        content: Text(t.commencerContenu),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              t.annuler,
              style: const TextStyle(color: AppTheme.textMedium),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              provider.startPeriod(DateTime.now());
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t.periodeCommencee),
                  backgroundColor: AppTheme.primary,
                ),
              );
            },
            child: Text(t.confirmer),
          ),
        ],
      ),
    );
  }

  void _endPeriod(
    BuildContext context,
    PeriodProvider provider,
    LanguageProvider t,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(t.terminerTitre),
        content: Text(t.terminerContenu),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.annuler),
          ),
          ElevatedButton(
            onPressed: () {
              provider.endPeriod(DateTime.now());
              Navigator.pop(ctx);
            },
            child: Text(t.confirmer),
          ),
        ],
      ),
    );
  }
}
