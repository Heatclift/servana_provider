import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:servana_cleaner_mobile/common/domain/routes/route_observer.dart';
import 'package:servana_cleaner_mobile/core/api/auth_token_holder.dart';
import 'package:servana_cleaner_mobile/features/availability/presentation/screens/availability_view.dart';
import 'package:servana_cleaner_mobile/features/calendar/presentation/screens/calendar_view.dart';
import 'package:servana_cleaner_mobile/features/earnings/presentation/screens/withdraw_review.dart';
import 'package:servana_cleaner_mobile/features/earnings/presentation/screens/withdraw_success.dart';
import 'package:servana_cleaner_mobile/features/earnings/presentation/screens/withdraw_tracking.dart';
import 'package:servana_cleaner_mobile/features/earnings/presentation/screens/withdraw_view.dart';
import 'package:servana_cleaner_mobile/features/forgot_password/forgot_password.dart';
import 'package:servana_cleaner_mobile/features/forgot_password/success_view.dart';
import 'package:servana_cleaner_mobile/features/homepage/presentation/screens/homepage_view.dart';
import 'package:servana_cleaner_mobile/features/homepage/presentation/screens/pages/job_details.dart';
import 'package:servana_cleaner_mobile/features/login/login_view.dart';
import 'package:servana_cleaner_mobile/features/messaging/presentation/screens/chat_view.dart';
import 'package:servana_cleaner_mobile/features/onboarding/onboarding_view.dart';
import 'package:servana_cleaner_mobile/features/signup/signup_view.dart';
import 'package:servana_cleaner_mobile/features/splash/splash_view.dart';

class MainRouter {
  static GoRouter router({required AuthTokenHolder authHolder}) {
    return GoRouter(
      initialLocation: SplashView.route,
      refreshListenable: authHolder,
      debugLogDiagnostics: kDebugMode,
      // errorBuilder: (context, state) {
      //   return const Dashboard();
      // },
      observers: [AnalyticsRouteObserver()],
      redirect: (context, state) {
        final loggedIn = authHolder.isLoggedIn;
        final loc = state.matchedLocation;

        final authFlowRoutes = <String>{
          SplashView.route,
          OnboardingView.route,
          LoginView.route,
          SignUpView.route,
          ForgotPassword.route,
          SuccessView.route,
        };

        if (loggedIn) {
          if (authFlowRoutes.contains(loc)) {
            return HomepageView.route;
          }
          return null;
        }

        if (!authFlowRoutes.contains(loc)) {
          return LoginView.route;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: SplashView.route,
          name: SplashView.routeName,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SplashView(),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return SlideTransition(
                  position: animation.drive(
                    Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeIn)),
                  ),
                  child: child);
            },
          ),
        ),
        GoRoute(
          path: OnboardingView.route,
          name: OnboardingView.routeName,
          builder: (context, state) => const OnboardingView(),
        ),
        GoRoute(
          path: LoginView.route,
          name: LoginView.routeName,
          builder: (context, state) => const LoginView(),
        ),
        GoRoute(
          path: SignUpView.route,
          name: SignUpView.routeName,
          builder: (context, state) => const SignUpView(),
        ),
        GoRoute(
          path: ForgotPassword.route,
          name: ForgotPassword.routeName,
          builder: (context, state) => const ForgotPassword(),
        ),
        GoRoute(
          path: SuccessView.route,
          name: SuccessView.routeName,
          builder: (context, state) => const SuccessView(),
        ),
        GoRoute(
          path: HomepageView.route,
          name: HomepageView.routeName,
          builder: (context, state) => const HomepageView(),
        ),
        GoRoute(
          path: JobDetailsView.route,
          name: JobDetailsView.routeName,
          builder: (context, state) => const JobDetailsView(),
        ),
        GoRoute(
          path: ChatView.route,
          name: ChatView.routeName,
          builder: (context, state) => ChatView(
            groupInfo: state.extra as Map<String, dynamic>,
          ),
        ),
        GoRoute(
          path: WithdrawView.route,
          name: WithdrawView.routeName,
          builder: (context, state) => const WithdrawView(),
        ),
        GoRoute(
          path: WithdrawSuccess.route,
          name: WithdrawSuccess.routeName,
          builder: (context, state) => const WithdrawSuccess(),
        ),
        GoRoute(
          path: WithdrawTracking.route,
          name: WithdrawTracking.routeName,
          builder: (context, state) => const WithdrawTracking(),
        ),
        GoRoute(
          path: WithdrawReview.route,
          name: WithdrawReview.routeName,
          builder: (context, state) => const WithdrawReview(),
        ),
        GoRoute(
          path: CalendarView.route,
          name: CalendarView.routeName,
          builder: (context, state) => const CalendarView(),
        ),
        GoRoute(
          path: AvailabilityView.route,
          name: AvailabilityView.routeName,
          builder: (context, state) => const AvailabilityView(),
        ),
      ],
    );
  }
}
