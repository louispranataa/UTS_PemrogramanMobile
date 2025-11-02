// lib/screens/result_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/custom_button.dart';
import 'welcome_screen.dart';

class ResultScreen extends StatelessWidget {
  // REVISI (Warning): Menggunakan super.key
  const ResultScreen({super.key});

  void _playAgain(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    final theme = Theme.of(context);
    final percentage = (provider.score / provider.questions.length) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Kuis"),
        automaticallyImplyLeading: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isTablet = constraints.maxWidth > 600;
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: isTablet
                  ? _buildTabletLayout(context, provider, theme, percentage)
                  : _buildMobileLayout(context, provider, theme, percentage),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, QuizProvider provider,
      ThemeData theme, double percentage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildResultContent(context, provider, theme, percentage),
        const SizedBox(height: 40),
        CustomButton(
          text: "Ulangi Kuis",
          onPressed: () => _playAgain(context),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, QuizProvider provider,
      ThemeData theme, double percentage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: _buildResultContent(context, provider, theme, percentage),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 1,
          child: CustomButton(
            text: "Ulangi Kuis",
            onPressed: () => _playAgain(context),
          ),
        ),
      ],
    );
  }

  Widget _buildResultContent(BuildContext context, QuizProvider provider,
      ThemeData theme, double percentage) {
    return Column(
      children: [
        Text(
          "Kuis Selesai, ${provider.userName ?? 'Pemain'}!",
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          "Skor Anda:",
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          "${provider.score} / ${provider.questions.length}",
          style: theme.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          "(${percentage.toStringAsFixed(0)}%)",
          style: theme.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}