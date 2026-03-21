import 'package:flutter/material.dart';
import '../models/quest.dart';
import '../database/quest_dao.dart';

class QuestProvider extends ChangeNotifier {
  final QuestDAO _questDAO = QuestDAO();

  List<Quest> _quests = [];
  bool _isLoading = false;
  String? _error;

  List<Quest> get quests => _quests;
  List<Quest> get activeQuests => _quests.where((q) => !q.isCompleted).toList();
  List<Quest> get completedQuests => _quests.where((q) => q.isCompleted).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadQuests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _quests = await _questDAO.getAllQuests();
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading quests: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createQuest(Quest quest) async {
    try {
      await _questDAO.insertQuest(quest);
      _quests.add(quest);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error creating quest: $e');
      notifyListeners();
    }
  }

  Future<void> completeQuest(String questId) async {
    try {
      await _questDAO.completeQuest(questId);
      final index = _quests.indexWhere((q) => q.id == questId);
      if (index != -1) {
        _quests[index] = _quests[index].copyWith(
          isCompleted: true,
          completedAt: DateTime.now(),
        );
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateQuest(Quest quest) async {
    try {
      await _questDAO.updateQuest(quest);
      final index = _quests.indexWhere((q) => q.id == quest.id);
      if (index != -1) {
        _quests[index] = quest;
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteQuest(String questId) async {
    try {
      await _questDAO.deleteQuest(questId);
      _quests.removeWhere((q) => q.id == questId);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> addMilestone(Milestone milestone) async {
    try {
      await _questDAO.insertMilestone(milestone);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> completeMilestone(String milestoneId) async {
    try {
      await _questDAO.completeMilestone(milestoneId);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<int> getCompletedQuestCount() async {
    try {
      return await _questDAO.getCompletedQuestCount();
    } catch (e) {
      debugPrint('Error getting completed quest count: $e');
      return 0;
    }
  }

  Future<int> getTotalXPEarned() async {
    try {
      return await _questDAO.getTotalXPEarned();
    } catch (e) {
      debugPrint('Error getting total XP: $e');
      return 0;
    }
  }
}