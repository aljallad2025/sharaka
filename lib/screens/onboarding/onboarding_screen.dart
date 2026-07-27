import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/common_widgets.dart';

class _OnboardData {
  final IconData icon;
  final String title;
  final String subtitle;
  const _OnboardData(this.icon, this.title, this.subtitle);
}

const _pages = [
  _OnboardData(
    Icons.rocket_launch_outlined,
    'اكتشف مشاريع واعدة',
    'تصفّح مشاريع ريادية موثّقة من قطاعات متنوعة في عُمان والخليج قبل ما تستثمر',
  ),
  _OnboardData(
    Icons.pie_chart_outline_rounded,
    'امتلك حصة حقيقية',
    'استثمر بأسهم حقيقية بأي مشروع يعجبك — بمبلغ يناسبك، تبدأ من حد أدنى بسيط',
  ),
  _OnboardData(
    Icons.trending_up_rounded,
    'تابع محفظتك بلحظتها',
    'راقب أداء استثماراتك، الأرباح، ونمو حصصك بكل شفافية من مكان واحد',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: () => context.go('/role-selection'),
                  child: const Text('تخطي'),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final p = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Icon(p.icon, size: 58, color: AppColors.gold),
                        ),
                        const SizedBox(height: 36),
                        Text(p.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        const SizedBox(height: 12),
                        Text(p.subtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14, height: 1.6, color: AppColors.textSecondary)),
                      ],
                    ),
                  );
                },
              ),
            ),
            SmoothPageIndicator(
              controller: _controller,
              count: _pages.length,
              effect: const ExpandingDotsEffect(
                dotColor: AppColors.border,
                activeDotColor: AppColors.gold,
                dotHeight: 7,
                dotWidth: 7,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: GoldButton(
                label: _index == _pages.length - 1 ? 'ابدأ الآن' : 'التالي',
                onPressed: () {
                  if (_index == _pages.length - 1) {
                    context.go('/role-selection');
                  } else {
                    _controller.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
