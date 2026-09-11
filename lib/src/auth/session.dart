import 'package:flutter/material.dart';
import 'package:polisphere/src/auth/app_role.dart';

/// Holds the currently signed-in role for this device session. There is no
/// backend yet, so this only lives in memory for the life of the app run.
class AppSession extends ChangeNotifier {
  AppRole? _role;

  AppRole? get role => _role;
  bool get isSignedIn => _role != null;

  void signIn(AppRole role) {
    _role = role;
    notifyListeners();
  }

  void signOut() {
    _role = null;
    notifyListeners();
  }
}

/// Exposes the app's [AppSession] to the widget tree.
class SessionScope extends InheritedNotifier<AppSession> {
  const SessionScope({
    super.key,
    required AppSession session,
    required super.child,
  }) : super(notifier: session);

  static AppSession of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SessionScope>();
    assert(scope != null, 'No SessionScope found in context');
    return scope!.notifier!;
  }
}
