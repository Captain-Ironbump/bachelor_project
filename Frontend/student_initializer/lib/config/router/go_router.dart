import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_initializer/presentation/_widgets/scaffold_with_navbar.dart';
import 'package:student_initializer/presentation/cubits/learner/get_learners/get_learners_cubit.dart';
import 'package:student_initializer/presentation/view/home_view.dart';
import 'package:student_initializer/presentation/view/observations_view.dart';
import 'package:student_initializer/presentation/view/settings_view.dart';
import 'package:student_initializer/providers/learner_use_case_provider.dart';
import 'package:student_initializer/providers/observation_use_case_provider.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _homeShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'home_shell');
final GlobalKey<NavigatorState> _observationsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'observations_shell');
final GlobalKey<NavigatorState> _settingsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'settings_shell');

class GoRouterCustom {
  final GoRouter router = GoRouter(
      initialLocation: '/home',
      navigatorKey: _rootNavigatorKey,
      routes: <RouteBase>[
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) => ScaffoldWithNavBar(
            navigationShell: navigationShell,
          ),
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
                initialLocation: '/home',
                navigatorKey: _homeShellNavigatorKey,
                routes: <GoRoute>[
                  GoRoute(
                    path: '/home',
                    name: 'Home',
                    builder: (context, state) => const HomeView(title: 'Home'),
                  )
                ]),
            StatefulShellBranch(
                navigatorKey: _observationsNavigatorKey,
                routes: <GoRoute>[
                  GoRoute(
                    path: '/observations',
                    name: 'Observations',
                    builder: (context, state) {
                      final container = ProviderScope.containerOf(context);
                      return MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => container.read(getLearnersCubitProvider)..getAllLearnerDetails(),
                            ),
                            BlocProvider(
                              create: (context) => container.read(getObservationsCountProvider),
                            )
                          ], 
                          child: BlocListener<GetLearnersCubit, GetLearnersState>(
                            listenWhen: (previous, current) =>
                                current is GetLearnersLoaded && previous is GetLearnersLoading
                            listener: (context, state) {
                              if (state is GetLearnersLoaded) {
                                final learners = state.learners!;
                              }; 
                            }, ));

                      return BlocProvider(
                        create: (_) => container.read(getLearnersCubitProvider)
                          ..getAllLearnerDetails(),
                        child: const ObservationsView(title: 'Observations'),
                      );
                    },
                  ),
                  GoRoute(
                      path: '/observations/learners/:id',
                      name: 'ObservationLearner',
                      builder: (context, state) => const Center(
                            child: Text('Here'),
                          ))
                ]),
            StatefulShellBranch(
                navigatorKey: _settingsNavigatorKey,
                routes: <GoRoute>[
                  GoRoute(
                    path: '/settings',
                    name: 'Settings',
                    builder: (context, state) => const SettingsView(
                      title: 'Settings',
                    ),
                  )
                ])
          ],
        )
      ]);
}
