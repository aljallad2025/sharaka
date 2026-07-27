import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/role_selection_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/kyc/kyc_screen.dart';
import '../../screens/investor/investor_shell.dart';
import '../../screens/investor/investor_home_screen.dart';
import '../../screens/investor/project_details_screen.dart';
import '../../screens/investor/invest_screen.dart';
import '../../screens/investor/portfolio_screen.dart';
import '../../screens/owner/owner_shell.dart';
import '../../screens/owner/owner_dashboard_screen.dart';
import '../../screens/owner/owner_projects_screen.dart';
import '../../screens/owner/add_project_screen.dart';
import '../../screens/owner/project_funding_tracking_screen.dart';
import '../../screens/admin/admin_dashboard_screen.dart';
import '../../screens/shared/notifications_screen.dart';
import '../../screens/shared/profile_screen.dart';

/// نظام التوجيه الكامل لتطبيق شراكة
/// كل الشاشات مرتبطة هنا بمسارات واضحة يسهل تتبعها وتوسيعها لاحقاً
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/role-selection', builder: (context, state) => const RoleSelectionScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterScreen(role: state.uri.queryParameters['role'] ?? 'investor'),
    ),
    GoRoute(path: '/kyc', builder: (context, state) => const KycScreen()),

    // === قسم المستثمر (Bottom Nav Shell) ===
    ShellRoute(
      builder: (context, state, child) {
        final location = state.uri.toString();
        int index = 0;
        if (location.startsWith('/investor/portfolio')) index = 1;
        if (location.startsWith('/investor/notifications')) index = 2;
        if (location.startsWith('/investor/profile')) index = 3;
        return InvestorShell(
          currentIndex: index,
          onTap: (i) {
            switch (i) {
              case 0:
                context.go('/investor/home');
                break;
              case 1:
                context.go('/investor/portfolio');
                break;
              case 2:
                context.go('/investor/notifications');
                break;
              case 3:
                context.go('/investor/profile');
                break;
            }
          },
          child: child,
        );
      },
      routes: [
        GoRoute(path: '/investor/home', builder: (context, state) => const InvestorHomeScreen()),
        GoRoute(path: '/investor/portfolio', builder: (context, state) => const PortfolioScreen()),
        GoRoute(path: '/investor/notifications', builder: (context, state) => const NotificationsScreen()),
        GoRoute(path: '/investor/profile', builder: (context, state) => const ProfileScreen()),
      ],
    ),
    GoRoute(
      path: '/investor/project/:id',
      builder: (context, state) => ProjectDetailsScreen(projectId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/investor/invest/:id',
      builder: (context, state) => InvestScreen(projectId: state.pathParameters['id']!),
    ),

    // === قسم صاحب المشروع (Bottom Nav Shell) ===
    ShellRoute(
      builder: (context, state, child) {
        final location = state.uri.toString();
        int index = 0;
        if (location.startsWith('/owner/projects')) index = 1;
        if (location.startsWith('/owner/notifications')) index = 2;
        if (location.startsWith('/owner/profile')) index = 3;
        return OwnerShell(
          currentIndex: index,
          onTap: (i) {
            switch (i) {
              case 0:
                context.go('/owner/dashboard');
                break;
              case 1:
                context.go('/owner/projects');
                break;
              case 2:
                context.go('/owner/notifications');
                break;
              case 3:
                context.go('/owner/profile');
                break;
            }
          },
          child: child,
        );
      },
      routes: [
        GoRoute(path: '/owner/dashboard', builder: (context, state) => const OwnerDashboardScreen()),
        GoRoute(path: '/owner/projects', builder: (context, state) => const OwnerProjectsScreen()),
        GoRoute(path: '/owner/notifications', builder: (context, state) => const NotificationsScreen()),
        GoRoute(path: '/owner/profile', builder: (context, state) => const ProfileScreen()),
      ],
    ),
    GoRoute(path: '/owner/add-project', builder: (context, state) => const AddProjectScreen()),
    GoRoute(
      path: '/owner/project-tracking/:id',
      builder: (context, state) => ProjectFundingTrackingScreen(projectId: state.pathParameters['id']!),
    ),

    // === قسم الإدارة ===
    GoRoute(path: '/admin/dashboard', builder: (context, state) => const AdminDashboardScreen()),
  ],
);
