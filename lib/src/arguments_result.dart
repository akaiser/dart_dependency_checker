import 'package:dart_dependency_checker/src/checker_mode.dart';
import 'package:equatable/equatable.dart';

class ArgumentsResult extends Equatable {
  const ArgumentsResult({
    required this.mode,
    required this.path,
    required this.devIgnores,
    required this.mainIgnores,
  });

  final CheckerMode mode;
  final String path;
  final Set<String> devIgnores;
  final Set<String> mainIgnores;

  @override
  List<Object> get props => [mode, path, devIgnores, mainIgnores];
}
