import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/explore/explore_screen.dart';
import '../features/insights/insights_screen.dart';
import '../features/interests/interests_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/surface/surface_screen.dart';
import 'providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final onboardingCompletedAsync = ref.watch(onboardingCompletedProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isOnboarding = state.matchedLocation == '/onboarding';

      return onboardingCompletedAsync.when(
        data: (completed) {
          if (!completed && !isOnboarding) {
            return '/onboarding';
          }
          if (completed && isOnboarding) {
            return '/';
          }
          return null;
        },
        loading: () => null,
        error: (_, __) => null,
      );
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SurfaceScreen(),
      ),
      GoRoute(
        path: '/exposure/:id',
        builder: (context, state) {
          final exposureId = state.pathParameters['id'];
          return SurfaceScreen(exposureId: exposureId);
        },
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/interests',
        builder: (context, state) => const InterestsScreen(),
      ),
      GoRoute(
        path: '/explore/:interestId',
        builder: (context, state) {
          final interestId = state.pathParameters['interestId']!;
          return ExploreScreen(interestId: interestId);
        },
      ),
      GoRoute(
        path: '/insights',
        builder: (context, state) => const InsightsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
