// lib/screens/quiz_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../providers/quiz_provider.dart';
import '../constants/subject_colors.dart';
import '../widgets/option_card.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int? _selectedOptionIndex;
  bool _isAnswering = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  /// NOTE:
  /// - capture the provider and navigator BEFORE any `await`/async gap
  /// - check `mounted` after await to avoid using a disposed context
  Future<void> _onOptionSelected(BuildContext context, int selectedIndex) async {
    if (_isAnswering) return;

    setState(() {
      _selectedOptionIndex = selectedIndex;
      _isAnswering = true;
    });

    // Capture provider & navigator BEFORE the async gap
    final provider = Provider.of<QuizProvider>(context, listen: false);
    final navigator = Navigator.of(context);

    // short delay for visual feedback
    await Future.delayed(const Duration(milliseconds: 600));

    // Ensure widget still mounted
    if (!mounted) return;

    // Use the captured provider & navigator (not `context`) after await
    provider.answerQuestion(selectedIndex);

    if (provider.isQuizFinished) {
      // navigate to result
      navigator.pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ResultScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else {
      // reset selection and replay animation
      setState(() {
        _selectedOptionIndex = null;
        _isAnswering = false;
      });
      _animationController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Consumer<QuizProvider>(
          builder: (context, provider, child) {
            return Text(provider.selectedSubject ?? 'Kuis');
          },
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Consumer<QuizProvider>(
                builder: (context, provider, child) {
                  final color = SubjectColors.getPrimaryColor(
                      provider.selectedSubject ?? '');
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${provider.currentQuestionIndex + 1}/${provider.totalQuestions}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Consumer<QuizProvider>(
        builder: (context, provider, child) {
          if (provider.isQuizFinished || provider.questions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final question = provider.currentQuestion;
          final subjectColor = SubjectColors.getPrimaryColor(
            provider.selectedSubject ?? '',
          );

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (provider.currentQuestionIndex + 1) /
                            provider.totalQuestions,
                        minHeight: 8,
                        backgroundColor: subjectColor.withValues(alpha: 0.2),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(subjectColor),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),

                    // Question number
                    Row(
                      children: [
                        Icon(Iconsax.message_question, color: subjectColor),
                        const SizedBox(width: 8),
                        Text(
                          'Pertanyaan ${provider.currentQuestionIndex + 1}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: subjectColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),

                    // Question card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            subjectColor.withValues(alpha: 0.1),
                            subjectColor.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: subjectColor.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        question.text,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),

                    // Options
                    ...List.generate(question.options.length, (index) {
                      final isSelected = _selectedOptionIndex == index;
                      final isCorrect = index == question.correctAnswerIndex;

                      return OptionCard(
                        optionText: question.options[index],
                        optionNumber: index + 1,
                        onTap: _isAnswering
                            ? null
                            : () => _onOptionSelected(context, index),
                        isSelected: isSelected,
                        showFeedback: _isAnswering && isSelected,
                        isCorrect: isCorrect,
                        subjectColor: subjectColor,
                      );
                    }),

                    SizedBox(height: size.height * 0.02),

                    // Hint text
                    if (!_isAnswering)
                      Center(
                        child: Text(
                          'Pilih salah satu jawaban',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
