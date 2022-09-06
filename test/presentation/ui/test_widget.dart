import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget testWidget({
  required Widget child,
  List<NavigatorObserver> navigatorObservers = const <NavigatorObserver>[],
  List<BlocProvider<BlocBase<Object?>>>? blocsList,
  Map<String, WidgetBuilder> routes = const <String, WidgetBuilder>{},
  WidgetBuilder? onTap,
}) {
  return MaterialApp(
    home: onTap != null
        ? GestureDetector(
            child: blocsList != null && blocsList.isNotEmpty
                ? MultiBlocProvider(providers: blocsList, child: child)
                : child,
          )
        : blocsList != null && blocsList.isNotEmpty
            ? MultiBlocProvider(providers: blocsList, child: child)
            : child,
    navigatorObservers: navigatorObservers,
    initialRoute: '/',
    routes: routes,
  );
}
