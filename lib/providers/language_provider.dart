// lib/providers/language_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  String _lang = 'fr';
  static const _key = 'app_language';

  String get lang => _lang;
  bool get isEnglish => _lang == 'en';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _lang = prefs.getString(_key) ?? 'fr';
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _lang = lang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, lang);
  }

  // ── Translations ──────────────────────────────────────────────────────────

  String get hello => isEnglish ? 'Hello!' : 'Hello!';
  String get monCycle => isEnglish ? 'My Cycle' : 'Mon Cycle';
  String get accueil => isEnglish ? 'Home' : 'Accueil';
  String get calendrier => isEnglish ? 'Calendar' : 'Calendrier';
  String get statistiques => isEnglish ? 'Statistics' : 'Statistiques';
  String get commencerPeriode =>
      isEnglish ? 'Start my period' : 'Commencer ma periode';
  String get terminerPeriode =>
      isEnglish ? 'End my period' : 'Terminer ma periode';
  String get ajouterSymptomes =>
      isEnglish ? 'Add symptoms' : 'Ajouter des symptomes';
  String get votreCycle => isEnglish ? 'Your cycle' : 'Votre cycle';
  String get prochainePeriode =>
      isEnglish ? 'Next period' : 'Prochaine periode';
  String get dureeCycle => isEnglish ? 'Cycle length' : 'Duree cycle';
  String get dureePeriode => isEnglish ? 'Period length' : 'Duree periode';
  String get fertilite => isEnglish ? 'Fertility' : 'Fertilite';
  String get aujourdhui => isEnglish ? 'Today' : "Aujourd'hui";
  String get aucunCycle => isEnglish ? 'No cycle' : 'Aucun cycle';
  String get jour => isEnglish ? 'Day' : 'Jour';
  String get sur => isEnglish ? 'of' : 'sur';
  String get jours => isEnglish ? 'days' : 'jours';
  String get dans => isEnglish ? 'In' : 'Dans';
  String get j => isEnglish ? 'd' : 'j';

  // Phase
  String get phaseMenstruelle =>
      isEnglish ? 'Menstrual Phase' : 'Phase Menstruelle';
  String get phaseMenstruelleDesc => isEnglish
      ? 'Take care of yourself. Rest and hydrate.'
      : 'Prenez soin de vous. Reposez-vous et hydratez-vous.';
  String get phaseFolliculaire =>
      isEnglish ? 'Follicular Phase' : 'Phase Folliculaire';
  String get phaseFolliculaireDesc => isEnglish
      ? 'Energy is rising! Great time for new projects.'
      : 'Energie en hausse! Bon moment pour les nouveaux projets.';
  String get ovulation =>
      isEnglish ? 'Ovulation Period' : "Periode d'Ovulation";
  String get ovulationDesc => isEnglish
      ? 'Fertility peak. You are at the top of your energy!'
      : 'Pic de fertilite. Vous etes au sommet de votre energie!';
  String get premenstruelle =>
      isEnglish ? 'Premenstrual Phase' : 'Phase Premenstruelle';
  String get premenstruelleDesc => isEnglish
      ? 'Be gentle and patient with yourself. PMS possible.'
      : 'Douceur et patience avec vous-meme. SPM possible.';
  String get commencezSuivi =>
      isEnglish ? 'Start tracking' : 'Commencez le suivi';
  String get commencezSuiviDesc => isEnglish
      ? 'Add your first period to see your data.'
      : 'Ajoutez votre premiere periode pour voir vos donnees.';

  // Dialogs
  String get commencerTitre =>
      isEnglish ? 'Start period' : 'Commencer la periode';
  String get commencerContenu => isEnglish
      ? "Do you want to record the start of your period today?"
      : "Voulez-vous enregistrer le debut de votre periode aujourd'hui?";
  String get terminerTitre => isEnglish ? 'End period' : 'Terminer la periode';
  String get terminerContenu => isEnglish
      ? "Do you want to mark the end of your period today?"
      : "Voulez-vous marquer la fin de votre periode aujourd'hui?";
  String get annuler => isEnglish ? 'Cancel' : 'Annuler';
  String get confirmer => isEnglish ? 'Confirm' : 'Confirmer';
  String get periodeCommencee =>
      isEnglish ? 'Period started' : 'Periode commencee';

  // Privacy
  String get privacyTitle => isEnglish ? 'Privacy Policy' : 'Confidentialite';
  String get privacyBody => isEnglish
      ? 'All your data is stored locally on your device. No personal information is shared with third parties. We do not collect, store, or transmit any personal health data.'
      : 'Toutes vos donnees sont stockees localement sur votre appareil. Aucune information personnelle n\'est partagee avec des tiers.';
  String get compris => isEnglish ? 'Got it' : 'Compris';

  // Stats
  String get statistiquesTitle => isEnglish ? 'Statistics' : 'Statistiques';
  String get cyclesEnregistres =>
      isEnglish ? 'Recorded\ncycles' : 'Cycles\nenregistres';
  String get cycleMoyen => isEnglish ? 'Average\ncycle' : 'Cycle\nmoyen';
  String get periodeMoyenne =>
      isEnglish ? 'Average\nperiod' : 'Periode\nmoyenne';
  String get dureeCyclesJours =>
      isEnglish ? 'Cycle length (days)' : 'Duree des cycles (jours)';
  String get historique => isEnglish ? 'History' : 'Historique';
  String get enCours => isEnglish ? 'In progress...' : 'En cours...';
  String get duree => isEnglish ? 'Duration' : 'Duree';
  String get fin => isEnglish ? 'end' : 'fin';

  // Calendar
  String get calendrierTitle => isEnglish ? 'Calendar' : 'Calendrier';
  String get legende => isEnglish ? 'Legend' : 'Legende';
  String get periode => isEnglish ? 'Period' : 'Periode';
  String get fenetreFertile => isEnglish ? 'Fertile window' : 'Fenetre fertile';
  String get prevision => isEnglish ? 'Forecast' : 'Prevision';
  String get prochainePeriodeTitle =>
      isEnglish ? 'Next period' : 'Prochaine periode';

  // Log
  String get journalTitle => isEnglish ? 'Daily journal' : 'Journal du jour';
  String get intensiteFlux =>
      isEnglish ? 'Flow intensity' : 'Intensite du flux';
  String get leger => isEnglish ? 'Light' : 'Leger';
  String get moyen => isEnglish ? 'Medium' : 'Moyen';
  String get fort => isEnglish ? 'Heavy' : 'Fort';
  String get symptomes => isEnglish ? 'Symptoms' : 'Symptomes';
  String get notes => isEnglish ? 'Notes' : 'Notes';
  String get notesHint => isEnglish
      ? 'How are you feeling today?'
      : 'Comment vous sentez-vous aujourd\'hui?';
  String get enregistrer => isEnglish ? 'Save' : 'Enregistrer';
  String get journalEnregistre =>
      isEnglish ? 'Journal saved' : 'Journal enregistre';

  List<String> get symptoms => isEnglish
      ? [
          'Cramps',
          'Headache',
          'Fatigue',
          'Bloating',
          'Mood swings',
          'Back pain',
          'Acne',
          'Food cravings',
          'Nausea',
          'Breast tenderness',
        ]
      : [
          'Crampes',
          'Maux de tete',
          'Fatigue',
          'Ballonnements',
          "Sautes d'humeur",
          'Douleurs dos',
          'Acne',
          'Envies alimentaires',
          'Nausees',
          'Seins sensibles',
        ];
}
