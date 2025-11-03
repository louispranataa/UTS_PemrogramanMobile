// lib/providers/quiz_provider.dart

import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../data/math_questions.dart';
import '../data/biology_questions.dart';
import '../data/physics_questions.dart';
import '../data/chemistry_questions.dart';

class QuizProvider with ChangeNotifier {
  // User & Subject Info
  String? _userName;
  String? _selectedSubject;

  // Quiz State
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;

  // Getters
  String? get userName => _userName;
  String? get selectedSubject => _selectedSubject;
  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  int get correctAnswers => _correctAnswers;
  int get wrongAnswers => _wrongAnswers;
  bool get isQuizFinished => _currentQuestionIndex >= _questions.length;
  
  Question get currentQuestion {
    if (_questions.isEmpty || _currentQuestionIndex >= _questions.length) {
      return Question(text: "", options: [], correctAnswerIndex: 0);
    }
    return _questions[_currentQuestionIndex];
  }

  int get totalQuestions => _questions.length;

  // Set user name
  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  // Set selected subject and load questions
  void setSubject(String subject) {
    _selectedSubject = subject;
    _loadQuestions(subject);
    notifyListeners();
  }

  // Load questions based on subject
  void _loadQuestions(String subject) {
    switch (subject.toLowerCase()) {
      case 'matematika':
        _questions = mathQuestions;
        break;
      case 'biologi':
        _questions = biologyQuestions;
        break;
      case 'fisika':
        _questions = physicsQuestions;
        break;
      case 'kimia':
        _questions = chemistryQuestions;
        break;
      default:
        _questions = [];
    }
  }

  // Answer question
  void answerQuestion(int selectedOptionIndex) {
    if (isQuizFinished || _questions.isEmpty) return;

    // Check if answer is correct
    if (selectedOptionIndex == currentQuestion.correctAnswerIndex) {
      _score++;
      _correctAnswers++;
    } else {
      _wrongAnswers++;
    }

    _currentQuestionIndex++;
    notifyListeners();
  }

  // Reset quiz (keep subject and user name)
  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _correctAnswers = 0;
    _wrongAnswers = 0;
    // Reload questions for current subject
    if (_selectedSubject != null) {
      _loadQuestions(_selectedSubject!);
    }
    notifyListeners();
  }

  // Complete reset (back to welcome screen)
  void completeReset() {
    _userName = null;
    _selectedSubject = null;
    _questions = [];
    _currentQuestionIndex = 0;
    _score = 0;
    _correctAnswers = 0;
    _wrongAnswers = 0;
    notifyListeners();
  }
}