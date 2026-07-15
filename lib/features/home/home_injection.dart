import 'package:get_it/get_it.dart';

import 'package:flutter_starter/features/home/presentation/bloc/profile/profile_bloc.dart';

/// Home feature composition root. `ProfileBloc` is a **factory** (screen-scoped,
/// disposed with the route) and reuses the auth feature's
/// `GetCurrentUserUseCase` — a legitimate cross-feature dependency on another
/// feature's *domain* contract (never on its data layer or bloc).
void registerHomeFeature(GetIt sl) {
  sl.registerFactory(() => ProfileBloc(sl()));
}
