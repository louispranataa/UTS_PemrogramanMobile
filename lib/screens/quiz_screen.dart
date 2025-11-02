// lib/screens/quiz_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/option_card.dart';
import 'result_screen.dart';

class QuizScreen extends StatelessWidget {
  // REVISI (Warning): Menggunakan super.key
  const QuizScreen({super.key});

  void _onOptionSelected(BuildContext context, int selectedIndex) {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    provider.answerQuestion(selectedIndex);

    if (provider.isQuizFinished) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResultScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kuis Berlangsung"),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<QuizProvider>(
        builder: (context, provider, child) {
          if (provider.isQuizFinished) {
            return const Center(child: CircularProgressIndicator());
          }

          final question = provider.currentQuestion;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Pertanyaan ${provider.currentQuestionIndex + 1} dari ${provider.questions.length}",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: size.height * 0.02),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          // REVISI (Warning): Ganti withOpacity(0.1)
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Text(
                      question.text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  ...List.generate(question.options.length, (index) {
                    return OptionCard(
                      optionText: question.options[index],
                      onTap: () => _onOptionSelected(context, index),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}