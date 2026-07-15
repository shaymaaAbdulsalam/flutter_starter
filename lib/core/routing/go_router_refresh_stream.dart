import 'dart:async';

import 'package:flutter/foundation.dart';

/// Adapts a [Stream] (an [AuthBloc]'s state stream) into a [Listenable] that
/// `GoRouter.refreshListenable` understands. Every time auth state changes, the
/// router re-runs its `redirect` — so login/logout navigation is fully
/// declarative and centralized, never scattered across screens.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (_) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
