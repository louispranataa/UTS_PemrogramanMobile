import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../providers/quiz_provider.dart';
import '../constants/subject_colors.dart';
import '../widgets/custom_button.dart';
import 'quiz_screen.dart';
import 'subject_selection_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
  }

  // 🔧 FIX: Reset quiz tapi JANGAN hapus userName dan selectedSubject
  void _retryQuiz(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    provider.resetQuiz(); // Ini sudah benar, cuma reset score dan questions
    
    // Langsung ke QuizScreen lagi
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const QuizScreen()),
    );
  }

  // 🔧 FIX: Jangan panggil completeReset, cukup navigasi aja
  void _backToHome(BuildContext context) {
    // Jangan reset provider di sini, biar nama user tetap ada
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SubjectSelectionScreen(),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    final theme = Theme.of(context);
    final percentage = (provider.score / provider.totalQuestions) * 100;
    final subjectColor = SubjectColors.getPrimaryColor(
      provider.selectedSubject ?? '',
    );

    String emoji;
    String message;
    if (percentage >= 80) {
      emoji = '🎉';
      message = 'Luar Biasa!';
    } else if (percentage >= 60) {
      emoji = '👏';
      message = 'Bagus!';
    } else if (percentage >= 40) {
      emoji = '💪';
      message = 'Cukup Baik!';
    } else {
      emoji = '📚';
      message = 'Tetap Semangat!';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Kuis'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                const SizedBox(height: 20),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 80)),
                      const SizedBox(height: 16),
                      Text(
                        message,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 🧍 Info Pengguna
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: subjectColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: subjectColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.user, color: subjectColor),
                          const SizedBox(width: 8),
                          Text(
                            provider.userName ?? 'Siswa',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.book, size: 18, color: subjectColor),
                          const SizedBox(width: 6),
                          Text(
                            provider.selectedSubject ?? '',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: subjectColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 📊 Skor
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        subjectColor.withValues(alpha: 0.2),
                        subjectColor.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: subjectColor.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Skor Anda',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Text(
                          '${provider.score}',
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: subjectColor,
                            fontSize: 72,
                          ),
                        ),
                      ),
                      Text(
                        'dari ${provider.totalQuestions}',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${percentage.toStringAsFixed(0)}%',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: subjectColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ✅ Statistik Benar/Salah
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Iconsax.tick_circle,
                        label: 'Benar',
                        value: '${provider.correctAnswers}',
                        color: Colors.green,
                        theme: theme,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        icon: Iconsax.close_circle,
                        label: 'Salah',
                        value: '${provider.wrongAnswers}',
                        color: Colors.red,
                        theme: theme,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // 🔘 Tombol Aksi
                CustomButton(
                  text: 'Ulangi Kuis',
                  onPressed: () => _retryQuiz(context),
                  icon: Iconsax.refresh,
                  color: subjectColor,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Kembali ke Halaman Utama',
                  onPressed: () => _backToHome(context),
                  icon: Iconsax.home,
                  isOutlined: true,
                  color: subjectColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}