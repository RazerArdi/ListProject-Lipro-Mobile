part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const LOGIN = _Paths.LOGIN;
  static const LOGREG = _Paths.LOGREG;
  static const REGISTERED = _Paths.REGISTERED;
  static const HOME = _Paths.HOME;
  static const ADD_TASK = _Paths.ADD_TASK;
  static const ADMIN = _Paths.ADMIN;
  static const HELP = _Paths.HELP;
  static const adminFeedback = _Paths.adminFeedback;

  static const SUPPORT_US = _Paths.SUPPORT_US;
  static const adminHome = _Paths.adminHome;
  static const usersManagement = _Paths.usersManagement;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const LOGIN = '/login';
  static const LOGREG = '/logreg';
  static const REGISTERED = '/registered';
  static const HOME = '/home';
  static const ADD_TASK = '/add-task';
  static const ADMIN = '/admin';
  static const HELP = '/help';
  static const String adminFeedback = '/admin-feedback';

  static const SUPPORT_US = '/support-us';
  static const String adminHome = '/admin-home';
  static const usersManagement = '/users-management';
}