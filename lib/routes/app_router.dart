import 'package:go_router/go_router.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/demo/demo_menu_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/kyc_screen.dart';
import '../screens/owner/owner_dashboard_screen.dart';
import '../screens/owner/add_project_screen.dart';
import '../screens/owner/project_investors_screen.dart';
import '../screens/investor/browse_projects_screen.dart';
import '../screens/investor/project_details_screen.dart';
import '../screens/investor/invest_screen.dart';
import '../screens/investor/portfolio_screen.dart';
import '../screens/common/notifications_screen.dart';
import '../screens/common/profile_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const demo = '/demo';
  static const login = '/login';
  static const register = '/register';
  static const kyc = '/kyc';

  static const ownerDashboard = '/owner';
  static const addProject = '/owner/add-project';
  static const projectInvestors = '/owner/project/:id/investors';

  static const investorHome = '/investor';
  static const projectDetails = '/investor/project/:id';
  static const invest = '/investor/project/:id/invest';
  static const portfolio = '/investor/portfolio';

  static const notifications = '/notifications';
  static const profile = '/profile';
  static const admin = '/admin';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (c, s) => const SplashScreen()),
    GoRoute(path: AppRoutes.demo, builder: (c, s) => const DemoMenuScreen()),
    GoRoute(path: AppRoutes.login, builder: (c, s) => const LoginScreen()),
    GoRoute(path: AppRoutes.register, builder: (c, s) => const RegisterScreen()),
    GoRoute(path: AppRoutes.kyc, builder: (c, s) => const KycScreen()),

    GoRoute(path: AppRoutes.ownerDashboard, builder: (c, s) => const OwnerDashboardScreen()),
    GoRoute(path: AppRoutes.addProject, builder: (c, s) => const AddProjectScreen()),
    GoRoute(
      path: AppRoutes.projectInvestors,
      builder: (c, s) => ProjectInvestorsScreen(projectId: s.pathParameters['id']!),
    ),

    GoRoute(path: AppRoutes.investorHome, builder: (c, s) => const BrowseProjectsScreen()),
    GoRoute(
      path: AppRoutes.projectDetails,
      builder: (c, s) => ProjectDetailsScreen(projectId: s.pathParameters['id']!),
    ),
    GoRoute(
      path: AppRoutes.invest,
      builder: (c, s) => InvestScreen(projectId: s.pathParameters['id']!),
    ),
    GoRoute(path: AppRoutes.portfolio, builder: (c, s) => const PortfolioScreen()),

    GoRoute(path: AppRoutes.notifications, builder: (c, s) => const NotificationsScreen()),
    GoRoute(path: AppRoutes.profile, builder: (c, s) => const ProfileScreen()),
    GoRoute(path: AppRoutes.admin, builder: (c, s) => const AdminDashboardScreen()),
  ],
);
