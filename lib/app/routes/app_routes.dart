part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const LOGIN = _Paths.LOGIN;
  static const LOGREG = _Paths.LOGREG; // Corrected from 'logreg' to 'LOGREG'
  static const REGISTERED = _Paths.REGISTERED; // Corrected from 'registered' to 'REGISTERED'
  static const HOME = _Paths.HOME;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const LOGIN = '/login';
  static const LOGREG = '/logreg'; // Keep consistent with Routes
  static const REGISTERED = '/registered'; // Keep consistent with Routes
  static const HOME = '/home';
}