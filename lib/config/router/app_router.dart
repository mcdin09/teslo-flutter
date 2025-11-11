import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/products.dart';

final goRouterProvider = Provider((ref){

  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      //
      GoRoute(
        path: '/splash',
        builder:(context,state)=> const CheckAuthScreen()
      ),
      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state){
          final productId = state.pathParameters['id'] ?? '';
          return ProductScreen(productId: productId);
        },
      ),
    ],
    redirect: (context,state){
      print('path: ${state.matchedLocation}');
      final nextLocation = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      if(nextLocation == '/splash' && authStatus == AuthStatus.checking) return null;

      if(authStatus == AuthStatus.notAuthenticated){
        //continue
        if(nextLocation == '/login' || nextLocation == '/register') return null;

        //authenticate
        return '/login';
      }

      if(authStatus == AuthStatus.authenticated){
        //Re-route to main page to prevent login again
        if(nextLocation == '/login' || nextLocation == '/register' || nextLocation == '/splash') return '/';

        //validate other paths when authenticated (Maybe check rol or something else)
      }
      return null;

    }
  );
});
