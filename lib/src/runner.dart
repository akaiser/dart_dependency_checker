import 'package:dart_dependency_checker/src/arguments_parser.dart';
import 'package:dart_dependency_checker/src/checker_mode.dart';
import 'package:dart_dependency_checker/src/dep_origin/deb_origin_checker.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_checker.dart';
import 'package:dart_dependency_checker/src/exit_code.dart';
import 'package:dart_dependency_checker/src/logger.dart';
import 'package:dart_dependency_checker/src/transitive_use/transitive_use_checker.dart';
import 'package:dart_dependency_checker/src/util/pubspec_yaml_parser.dart';

ExitCode run(List<String> args, [Logger logger = const Logger()]) {
  final arguments = ArgumentsParser.parse(args);

  if (arguments == null) {
    logger.error(
      'One of mode type is required: '
      '${CheckerMode.values.commaSeparated}',
    );
    return const ExitCode(1);
  }

  final pubspecYaml = PubspecYamlParser.from(arguments.path);
  if (pubspecYaml == null) {
    logger.error('Invalid pubspec.yml file path: ${arguments.path}');
    return const ExitCode(2);
  }

  final checker = switch (arguments.mode) {
    CheckerMode.depOrigin => DepOriginChecker(logger),
    CheckerMode.depsUnused => DepsUnusedChecker(logger, arguments, pubspecYaml),
    CheckerMode.transitiveUse => TransitiveUseChecker(logger),
  };

  return checker.makeItSo();
}
