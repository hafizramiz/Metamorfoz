// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfoz/ui/metamorfoz/metamorfoz_screen.dart';
import 'package:provider/provider.dart';

import '../data/repositories/auth/auth_repository.dart';
import '../ui/activities/view_models/activities_viewmodel.dart';
import '../ui/activities/widgets/activities_screen.dart';
import '../ui/auth/login/view_models/login_viewmodel.dart';
import '../ui/auth/login/widgets/login_screen.dart';
import '../ui/booking/widgets/booking_screen.dart';
import '../ui/booking/view_models/booking_viewmodel.dart';
import '../ui/home/view_models/home_viewmodel.dart';
import '../ui/home/widgets/home_screen.dart';
import '../ui/results/view_models/results_viewmodel.dart';
import '../ui/results/widgets/results_screen.dart';
import '../ui/search_form/view_models/search_form_viewmodel.dart';
import '../ui/search_form/widgets/search_form_screen.dart';
import 'routes.dart';

int counter = 0;

/// Top go_router entry point.
///
/// Listens to changes in [AuthTokenRepository] to redirect the user
/// to /login when the user logs out.
GoRouter router(
    AuthRepository authRepository,
    ) =>
    GoRouter(
      initialLocation: Routes.home,

      ///  [debugLogDiagnostics]: true, yaparak routerin calisma durumunu goruntuleyebiliriz
      debugLogDiagnostics: true,
      redirect: _redirect,
      refreshListenable: authRepository,
      routes: [
        /// Login screen

        GoRoute(
          path: Routes.login,
          builder: (context, state) {
            return LoginScreen(
              viewModel: LoginViewModel(
                authRepository: context.read(),
              ),
            );
          },
        ),

        /// Home screen
        GoRoute(
          path: Routes.home,

          /// Burda page builder yerine builder'da kullanilabilir. Tek farki
          /// pageBuilder ile platform spesficik bir safya gecisi yapilabilir

          /// Nested route'a giderken ana route'daki metotlar da calisiyor.
          /// Orasini da yeniden rebuild ediyor.
          /// Giderken rebuild ediyor. Peki geri gelirken ne yapiyor.
          /// Geri gelirken de yeniden calistiriyor.

          builder: (context, state) {
            print("home screen invoked! Home screen parent route'dur.");
            final viewModel = HomeViewModel(
              bookingRepository: context.read(),
              userRepository: context.read(),
            );
            return HomeScreen(viewModel: viewModel);
          },
          routes: [
            /// Nested routes
            GoRoute(
                path: Routes.searchRelative,
                builder: (context, state) {
                  print(
                      "Search screen invoked! Search screen nested route'dur.");

                  final viewModel = SearchFormViewModel(
                    continentRepository: context.read(),
                    itineraryConfigRepository: context.read(),
                  );
                  return SearchFormScreen(viewModel: viewModel);
                },
                routes: [
                  GoRoute(
                    path: Routes.resultsRelative,
                    builder: (context, state) {
                      print(
                          "Search screen invoked! Search screen nested route'dur.");

                      final viewModel = SearchFormViewModel(
                        continentRepository: context.read(),
                        itineraryConfigRepository: context.read(),
                      );
                      return SearchFormScreen(viewModel: viewModel);
                    },
                  )
                ]),
            GoRoute(
              path: Routes.resultsRelative,
              builder: (context, state) {
                final viewModel = ResultsViewModel(
                  destinationRepository: context.read(),
                  itineraryConfigRepository: context.read(),
                );
                return ResultsScreen(
                  viewModel: viewModel,
                );
              },
            ),
            GoRoute(
              path: Routes.activitiesRelative,
              builder: (context, state) {
                final viewModel = ActivitiesViewModel(
                  activityRepository: context.read(),
                  itineraryConfigRepository: context.read(),
                );
                return ActivitiesScreen(
                  viewModel: viewModel,
                );
              },
            ),
            GoRoute(
              path: Routes.bookingRelative,
              builder: (context, state) {
                final viewModel = BookingViewModel(
                  itineraryConfigRepository: context.read(),
                  createBookingUseCase: context.read(),
                  shareBookingUseCase: context.read(),
                  bookingRepository: context.read(),
                );

                // When opening the booking screen directly
                // create a new booking from the stored ItineraryConfig.
                viewModel.createBooking.execute();

                return BookingScreen(
                  viewModel: viewModel,
                );
              },
              routes: [
                /// Burda path'ni degistirip ayni sayfayi bir daha aciyor.
                /// Sayfa ayni ama path degisti. Ayni sayfasi nested route olarak acti.
                /// Bu sayfada back deyince de bir oncekine yani kendine degil de daha oncesine
                /// home'a atiyor.
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final id = int.parse(state.pathParameters['id']!);
                    final viewModel = BookingViewModel(
                      itineraryConfigRepository: context.read(),
                      createBookingUseCase: context.read(),
                      shareBookingUseCase: context.read(),
                      bookingRepository: context.read(),
                    );

                    /// Burda mesela view model'e id aktarmamis
                    /// burda farkli id'ye gore execute yapip yapmaycagimiza karar veririz.
                    /// Ynai boyama ise 222 o zaman execute etme. Ama diger durumlarda et deriz.
                    // When opening the booking screen with an existing id
                    // load and display that booking.
                    viewModel.loadBooking.execute(id);

                    /// Ekranin burda id'yi almasina gerek yok. Direk vide modele id veriyoruz,
                    return BookingScreen(
                      viewModel: viewModel,
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        /// Yeni eklediklerim

        GoRoute(
          path: Routes.metamorfoz,
          builder: (context, state) {
            final viewModel = HomeViewModel(
              bookingRepository: context.read(),
              userRepository: context.read(),
            );
            return MetamorfozScreen(viewModel: viewModel);
          },
        ),
      ],
    );

/// Login redirection logic burda yonetilir.
/// redirect iki defa calisiyor
///  @override
//   Future<bool> get isAuthenticated async {
//     print("isAuthenticated: $_isAuthenticated ");
//     // Status is cached
//     if (_isAuthenticated != null) {
//       return _isAuthenticated!;
//     }
//     // No status cached, fetch from storage
//     await _fetch();
//     return _isAuthenticated ?? false;
//   }
/// Ilk acilista redirection 4 defa cagriliyor. Bu durumu engellemek icin

/// Bunun boyle yazilmasinin sebebi bir daha fetch metotunun calistirilmasini engellemektir.
// From https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart
Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  counter++;
  print(state);
  print("redirection called times: $counter");
  // if the user is not logged in, they need to login
  final bool loggedIn = await context.read<AuthRepository>().isAuthenticated;
  print(loggedIn);
  final bool loggingIn = state.matchedLocation == Routes.login;
  if (!loggedIn) {
    return Routes.login;
  }

  // if the user is logged in but still on the login page, send them to
  // the home page
  if (loggingIn) {
    return Routes.home;
  }

  // no need to redirect at all
  return null;
}
