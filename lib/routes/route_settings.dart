import 'dart:io';

import 'package:coinxfiat/constants/constants_index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../screens/screen_index.dart';
import '../store/store_index.dart';
import '../utils/utils_index.dart';
import '../widgets/widget_index.dart';
import 'route_index.dart';

final GoRouter goRouter = GoRouter(
  routes: <RouteBase>[
    ///Splash
    GoRoute(
      path: Paths.splash,
      name: Routes.splash,
      pageBuilder: (context, state) =>
          animatedRoute(state, (state) => const SplashScreen()),
    ),

    ///Dashboard
    GoRoute(
      path: Paths.dashboard,
      name: Routes.dashboard,
      pageBuilder: (context, state) =>
          animatedRoute(state, (state) => const Dashboard()),
      routes: [
        ///wallet
        GoRoute(
          path: Routes.walletDetails,
          name: Routes.walletDetails,
          redirect: (context, state) => Paths.walletDetails(
            state.pathParameters['code'] ?? '-',
            title: state.uri.queryParameters['name'],
            address: state.uri.queryParameters['address'],
            bal: state.uri.queryParameters['bal'],
          ),
          routes: [
            GoRoute(
              path: ':code',
              pageBuilder: (context, state) => animatedRoute(
                  state,
                  (state) => WalletDetails(
                        code: state.pathParameters['code'] ?? '-',
                        name: state.uri.queryParameters['name'],
                        address: state.uri.queryParameters['address'],
                        bal: state.uri.queryParameters['bal'],
                      )),
            ),
          ],
        ),

        ///my holdings
        GoRoute(
          path: Routes.myHoldings,
          name: Routes.myHoldings,
          pageBuilder: (context, state) =>
              animatedRoute(state, (state) => const MyHoldingsPage()),
        ),

        ///buy sell
        GoRoute(
          path: ':type(buy|sell)/trade/request',
          name: Routes.buyOrSell,
          pageBuilder: (context, state) => animatedRoute(
              state,
              (state) => BuyOrSellRequestPage(
                  selling:
                      (state.pathParameters['type']!).toLowerCase() == 'sell')),
          routes: [
            GoRoute(
              path: ':requestId',
              pageBuilder: (context, state) => animatedRoute(
                  state,
                  (state) => BuyOrSellRequestPage(
                        selling:
                            (state.pathParameters['type']!).toLowerCase() ==
                                'sell',
                        requestId: state.pathParameters['requestId'],
                      )),
            ),
          ],
        ),

        ///add gateway
        GoRoute(
          path: 'sell/gateway/add/:requestId',
          name: Routes.addGateWay,
          pageBuilder: (context, state) => animatedRoute(
              state,
              (state) =>
                  AddGateway(requestId: state.pathParameters['requestId'])),
        ),

        ///payout history
        GoRoute(
          path: Routes.payoutHistory,
          name: Routes.payoutHistory,
          pageBuilder: (context, state) =>
              animatedRoute(state, (state) => const PayoutHistory()),
        ),

        ///transaction history
        GoRoute(
          path: Routes.transactionHistory,
          name: Routes.transactionHistory,
          pageBuilder: (context, state) =>
              animatedRoute(state, (state) => const TransactionHistory()),
        ),

        ///ad feedbacks
        GoRoute(
          path: Routes.feedback,
          name: Routes.feedback,
          pageBuilder: (context, state) =>
              animatedRoute(state, (state) => const FeedbackPage()),
          routes: [
            GoRoute(
              path: ':id',
              pageBuilder: (context, state) => animatedRoute(state,
                  (state) => FeedbackPage(id: state.pathParameters['id'])),
            ),
          ],
        ),

        /// ad edit
        GoRoute(
          path: 'advertisments/:type(edit|create)',
          name: Routes.createOrEditAd,
          pageBuilder: (context, state) => animatedRoute(
              state,
              (state) => CreateOrEditAdScreen(
                  type: state.pathParameters['type'] ?? 'create')),
          routes: [
            GoRoute(
              path: ':id',
              pageBuilder: (context, state) => animatedRoute(
                  state,
                  (state) => CreateOrEditAdScreen(
                      id: state.pathParameters['id'],
                      type: state.pathParameters['type'] ?? 'edit')),
            ),
          ],
        ),

        ///trade-list
        GoRoute(
          path: 'trade/list',
          name: Routes.tradeList,
          redirect: (_, state) => Paths.tradeList(
              state.pathParameters['type'] ?? 'all',
              state.uri.queryParameters['adId']),
          routes: [
            GoRoute(
              path: ':type(running|complete|all)',
              pageBuilder: (context, state) => animatedRoute(
                  state,
                  (state) => TradeList(
                        type: state.pathParameters['type'],
                        adId: state.uri.queryParameters['adId'],
                      )),
            ),
          ],
        ),

        ///trade-details
        GoRoute(
          path: 'trade/details',
          name: Routes.tradeDetails,
          redirect: (context, state) =>
              '${Paths.dashboard}/trade/details/${state.pathParameters['id']}',
          routes: [
            GoRoute(
              path: ':id',
              pageBuilder: (context, state) => animatedRoute(state,
                  (state) => TradeDetails(id: state.pathParameters['id'])),
            ),
          ],
        ),

        ///profile
        GoRoute(
          path: Routes.editProfile,
          name: Routes.editProfile,
          pageBuilder: (context, state) =>
              animatedRoute(state, (state) => const EditProfileScreen()),
        ),

        ///support
        GoRoute(
          path: Routes.support,
          name: Routes.support,
          pageBuilder: (context, state) =>
              animatedRoute(state, (state) => const SupportTicketsPage()),
          routes: [
            GoRoute(
              path: '${Routes.ticketView}/:id',
              name: Routes.ticketView,
              pageBuilder: (context, state) => animatedRoute(
                state,
                (state) => SupportChatPage(
                    key: ValueKey(state.pathParameters['id'] ??
                        'error${DateTime.now().millisecondsSinceEpoch}'),
                    id: state.pathParameters['id'],
                    title:
                        tryCatch(() => (state.extra as Map)['title'] ?? '') ??
                            '',
                    lastSeen: DateTime.tryParse(tryCatch(
                            () => (state.extra as Map)['lastSeen'] ?? '') ??
                        '')),
              ),
            ),
          ],
        ),

        ///widgets
        GoRoute(
          path: Routes.htmlPage,
          name: Routes.htmlPage,
          pageBuilder: (context, state) => animatedRoute(
              state,
              (state) => HtmlPage(
                    title: state.uri.queryParameters['title'],
                    html: state.uri.queryParameters['html'],
                  )),
        ),
      ],
    ),

    ///Auth
    GoRoute(
      path: Paths.login,
      name: Routes.login,
      pageBuilder: (context, state) => animatedRoute(
          state,
          (state) => AuthScreen(
              returnPath: state.uri.queryParameters['then'] ?? '',
              returnExpected: false)),
    ),

    ///company
    GoRoute(
      path: Paths.aboutUs,
      name: Routes.aboutUs,
      pageBuilder: (context, state) =>
          animatedRoute(state, (state) => AboutScreen()),
    ),
  ],
  errorPageBuilder: (context, state) =>
      animatedRoute(state, (state) => ErrorScreen(state: state)),
  navigatorKey: navigatorKey,
  initialLocation: Paths.splash,
  redirect: _redirect,
);
Future<bool> checkLogin() async {
  await appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));
  return appStore.isLoggedIn;
}

///Global redirect
Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  bool loggedIn = await checkLogin();

  logger.i('_redirect logged in => $loggedIn',
      error: {
        'location': state.fullPath,
        'matchedLocation': state.matchedLocation,
        'extra': state.extra,
        'uri': state.uri
      },
      tag: 'My Router');
  String path = state.matchedLocation;
  if (path == Paths.splash) return Paths.splash;

  if (_loginPaths(path)) {
    if (loggedIn) {
      return Paths.dashboard;
    } else {
      String? redirectAfterLogin = state.uri.queryParameters['redirect'];
      String newPath = redirectAfterLogin != null
          ? '$path?redirect=$redirectAfterLogin'
          : path;
      logger.i('_redirect', error: {'newPath': newPath}, tag: 'My Router');
      return newPath;
    }
  } else if (_authenticatedPaths(path)) {
    return loggedIn ? path : Paths.login;
  }

  return null;
}

bool _loginPaths(String path) =>
    authRoutes.any((element) => element.startsWith(path));

bool _authenticatedPaths(String path) =>
    authenticatedRoutes.any((element) => element.startsWith(path));

///Auth Routes name List
List<String> authRoutes = [
  Paths.login,
  Paths.register,
  Paths.forgotPassword,
];

///Authenticated Routes name List
List<String> authenticatedRoutes = [
  Paths.dashboard,
];

///Global animated route       G O   R O U T E R

Page animatedRoute(
    GoRouterState state, Widget Function(GoRouterState state) child,
    {RouteTransition? transition}) {
  String? anim = state.uri.queryParameters['anim'] ??
      (state.extra is Map && (state.extra as Map).containsKey('anim')
          ? (state.extra as Map)['anim']
          : null);
  if ((Platform.isAndroid || Platform.isIOS) && anim == null) {
    return CupertinoPage(
      child: child(state),
      key: state.pageKey,
      title: state.matchedLocation.split('-').last.capitalizeEachWord(),
      arguments: state.extra,
    );
  }
  logger.i('animatedRoute',
      error: {
        'transition': transition,
        'queryParameters': state.uri.queryParameters,
        'matchedLocation': state.matchedLocation,
      },
      tag: 'My Router');

  RouteTransition pageTransition = transition ??
      RouteTransition.values.firstWhere(
          (element) => element.name == (anim ?? RouteTransition.fade.name));
  return CustomTransitionPage(
      key: state.pageKey,
      child: child(state),
      barrierDismissible: true,
      barrierColor: Colors.black38,
      arguments: state.extra,
      // opaque: false,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (pageTransition) {
          case RouteTransition.slide:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          case RouteTransition.fromTop:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, -1.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          case RouteTransition.fromBottom:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          case RouteTransition.fomRight:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          case RouteTransition.topLeft:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, -1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          case RouteTransition.topRight:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, -1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          case RouteTransition.bottomLeft:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 1.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          case RouteTransition.bottomRight:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 1.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          case RouteTransition.fade:
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          case RouteTransition.scale:
            return FadeTransition(
              opacity: Tween<double>(begin: 0.6, end: 1.0).animate(animation),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                child: child,
              ),
            );
          default:
            return FadeTransition(
              opacity: Tween<double>(begin: .5, end: 1.0).animate(animation),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
        }
      });
}

enum RouteTransition {
  slide,
  fromTop,
  fromBottom,
  fomRight,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  fade,
  scale,
  fromLeft,
}
