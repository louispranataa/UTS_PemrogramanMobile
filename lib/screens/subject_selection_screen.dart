import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../providers/quiz_provider.dart';
import '../constants/subject_colors.dart';
import '../widgets/subject_card.dart';
import 'quiz_screen.dart';

class SubjectSelectionScreen extends StatefulWidget {
  const SubjectSelectionScreen({super.key});

  @override
  State<SubjectSelectionScreen> createState() => _SubjectSelectionScreenState();
}

class _SubjectSelectionScreenState extends State<SubjectSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final List<Map<String, dynamic>> subjects = [
    {
      'name': 'Matematika',
      'description': 'Logika & Perhitungan',
      'icon': Iconsax.calculator,
      'color': SubjectColors.math,
      'lightColor': SubjectColors.mathLight,
    },
    {
      'name': 'Biologi',
      'description': 'Ilmu Kehidupan',
      'icon': Iconsax.microscope,
      'color': SubjectColors.biology,
      'lightColor': SubjectColors.biologyLight,
    },
    {
      'name': 'Fisika',
      'description': 'Hukum Alam & Energi',
      // Ganti icon yang tidak tersedia
      'icon': Iconsax.code, // pengganti Iconsax.atom
      'color': SubjectColors.physics,
      'lightColor': SubjectColors.physicsLight,
    },
    {
      'name': 'Kimia',
      'description': 'Reaksi & Senyawa',
      // Ganti icon yang tidak tersedia
      'icon': Icons.science_outlined, // pengganti Iconsax.flask
      'color': SubjectColors.chemistry,
      'lightColor': SubjectColors.chemistryLight,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  void _onSubjectSelected(String subjectName) {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    provider.setSubject(subjectName);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: SubjectColors.getPrimaryColor(subjectName),
              ),
              const SizedBox(height: 16),
              Text(
                'Memuat pertanyaan...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );

    // Delay untuk efek loading
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return; // 🔹 Hindari context setelah async gap
      Navigator.pop(context); // Close dialog
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const QuizScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            final tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Mata Pelajaran'),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                'Halo, ${provider.userName ?? "Siswa"}! 👋',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pilih mata pelajaran yang ingin kamu pelajari hari ini',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 32),

              // Grid / List of Subjects
              LayoutBuilder(
                builder: (context, constraints) {
                  final isTablet = constraints.maxWidth > 600;

                  if (isTablet) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: subjects.length,
                      itemBuilder: (context, index) {
                        return _buildAnimatedCard(index, subjects[index]);
                      },
                    );
                  } else {
                    return Column(
                      children: List.generate(
                        subjects.length,
                        (index) => _buildAnimatedCard(index, subjects[index]),
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 32),

              // Info Box
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.1),
                      theme.colorScheme.secondary.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.info_circle,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Setiap kuis berisi 5 pertanyaan pilihan ganda',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(int index, Map<String, dynamic> subject) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: SubjectCard(
          name: subject['name'],
          description: subject['description'],
          icon: subject['icon'],
          color: subject['color'],
          lightColor: subject['lightColor'],
          onTap: () => _onSubjectSelected(subject['name']),
        ),
      ),
    );
  }
}
