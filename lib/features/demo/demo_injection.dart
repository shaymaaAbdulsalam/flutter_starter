import 'package:get_it/get_it.dart';

import 'package:flutter_starter/features/demo/presentation/bloc/demo/demo_bloc.dart';

/// Showcase feature composition root. Factory-scoped like every screen bloc.
/// Delete along with `features/demo/` when starting a real project.
void registerDemoFeature(GetIt sl) {
  sl.registerFactory(() => DemoBloc());
}
