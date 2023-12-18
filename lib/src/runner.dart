import 'package:dart_dependency_checker/src/arguments_parser.dart';
import 'package:dart_dependency_checker/src/checker_mode.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_params.dart';
import 'package:dart_dependency_checker/src/deps_unused/internal_deps_unused_checker.dart';
import 'package:dart_dependency_checker/src/logger.dart';

int run(List<String> args, [Logger logger = const Logger()]) {
  final arguments = ArgumentsParser.parse(args);

  if (arguments == null) {
    logger.error(
      'One of mode type is required: '
      '${CheckerMode.values.commaSeparated}',
    );
    return 1;
  }

  final checker = switch (arguments.mode) {
    CheckerMode.depOrigin => throw UnimplementedError(),
    CheckerMode.depsUnused => InternalDepsUnusedChecker(
        logger,
        DepsUnusedParams.from(arguments),
      ),
    CheckerMode.transitiveUse => throw UnimplementedError(),
  };

  return checker.checkWithExit();
}
