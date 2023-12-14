import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_dependency_checker/src/arguments_result.dart';
import 'package:dart_dependency_checker/src/checker_mode.dart';

const _pathOption = 'path';
const _devIgnoresOption = 'dev-ignores';

abstract final class ArgumentsParser {
  static ArgumentsResult? parse(List<String> args) {
    final results = _parser.parse(args);
    final command = results.command;

    if (command == null) {
      return null;
    }

    final devIgnores = command[_devIgnoresOption] as String?;
    final mode = CheckerMode.values.firstWhere((v) => v.name == command.name);

    return ArgumentsResult(
      mode: mode,
      path: command[_pathOption] as String? ?? Directory.current.path,
      devIgnores: devIgnores?.split(',').toSet() ?? const {},
    );
  }

  static ArgParser get _parser => ArgParser()
    ..addCommand(
      CheckerMode.depOrigin.name,
      ArgParser()..withPathOption(),
    )
    ..addCommand(
      CheckerMode.depsUnused.name,
      ArgParser()
        ..withPathOption()
        ..addOption(_devIgnoresOption),
    )
    ..addCommand(
      CheckerMode.transitiveUse.name,
      ArgParser()..withPathOption(),
    );
}

extension on ArgParser {
  void withPathOption() => addOption(_pathOption, abbr: _pathOption[0]);
}
