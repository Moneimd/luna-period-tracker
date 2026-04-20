// lib/screens/log_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../utils/theme.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final Set<String> _selected = {};
  int _flow = 2;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.journalTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flow intensity
            Text(
              t.intensiteFlux,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _flowButton(1, t.leger, Icons.water_drop_outlined),
                const SizedBox(width: 8),
                _flowButton(2, t.moyen, Icons.water_drop),
                const SizedBox(width: 8),
                _flowButton(3, t.fort, Icons.bloodtype),
              ],
            ),
            const SizedBox(height: 24),

            // Symptoms
            Text(
              t.symptomes,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: t.symptoms.map((s) {
                final isSelected = _selected.contains(s);
                return FilterChip(
                  label: Text(s),
                  selected: isSelected,
                  onSelected: (v) => setState(
                    () => v ? _selected.add(s) : _selected.remove(s),
                  ),
                  selectedColor: AppTheme.primaryLight.withOpacity(0.4),
                  checkmarkColor: AppTheme.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.primary : AppTheme.textMedium,
                    fontSize: 13,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Notes
            Text(
              t.notes,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: t.notesHint,
                hintStyle: const TextStyle(color: AppTheme.textMedium),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppTheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _save(context, t),
                child: Text(t.enregistrer),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _flowButton(int level, String label, IconData icon) {
    final isSelected = _flow == level;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _flow = level),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppTheme.primary : Colors.grey.shade200,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppTheme.textMedium,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textMedium,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save(BuildContext context, LanguageProvider t) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.journalEnregistre),
        backgroundColor: AppTheme.primary,
      ),
    );
    Navigator.pop(context);
  }
}
