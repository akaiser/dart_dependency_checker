import 'package:dart_dependency_checker/src/_shared/params.dart';

/// Params for the [DepsAddPerformer].
class DepsAddParams extends PathParam {
  const DepsAddParams({
    required super.path,
    this.main = const {},
    this.dev = const {},
  });

  /// Main dependencies to add.
  final Set<String> main;

  /// Dev dependencies to add.
  final Set<String> dev;

  @override
  List<Object?> get props => [...super.props, main, dev];
}
