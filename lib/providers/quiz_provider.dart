// lib/providers/quiz_provider.dart

import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../data/dummy_questions.dart';

class QuizProvider with ChangeNotifier {
  String? _userName;
  final List<Question> _questions = dummyQuestions;
  int _currentQuestionIndex = 0;
  int _score = 0;

  // Getters
  String? get userName => _userName;
  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  bool get isQuizFinished => _currentQuestionIndex >= _questions.length;
  Question get currentQuestion => _questions[_currentQuestionIndex];

  // Setters
  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  // Logic
  void answerQuestion(int selectedOptionIndex) {
    if (isQuizFinished) return;

    if (selectedOptionIndex == currentQuestion.correctAnswerIndex) {
      _score++;
    }
    _currentQuestionIndex++;
    
    // Memberitahu UI untuk update
    notifyListeners();
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    // _userName tidak di-reset agar bisa dipakai lagi
    notifyListeners();
  }
}