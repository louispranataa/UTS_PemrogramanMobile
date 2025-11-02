// lib/data/dummy_questions.dart

import '../models/question_model.dart';

// 8. Data cukup bersifat lokal atau dummy
final List<Question> dummyQuestions = [
  Question(
    text: "Widget utama apa yang digunakan untuk membangun layout di Flutter?",
    options: ["View", "Component", "Widget", "Element"],
    correctAnswerIndex: 2,
  ),
  Question(
    text: "Manakah yang merupakan 'State Management' bawaan Flutter?",
    options: ["Provider", "Bloc", "StatefulWidget", "GetX"],
    correctAnswerIndex: 2,
  ),
  Question(
    text: "Perintah untuk menjalankan aplikasi Flutter adalah...",
    options: ["flutter start", "flutter run", "npm start", "flutter build"],
    correctAnswerIndex: 1,
  ),
  Question(
    text: "Apa nama file untuk mendeklarasikan dependensi project Flutter?",
    options: ["package.json", "build.gradle", "pubspec.yaml", "config.xml"],
    correctAnswerIndex: 2,
  ),
  Question(
    text: "Widget apa yang digunakan untuk membuat daftar yang bisa di-scroll?",
    options: ["Column", "Row", "Stack", "ListView"],
    correctAnswerIndex: 3,
  ),
];