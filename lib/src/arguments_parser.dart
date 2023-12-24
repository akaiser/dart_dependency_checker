import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_dependency_checker/src/arguments_error.dart';
import 'package:dart_dependency_checker/src/arguments_result.dart';
import 'package:dart_dependency_checker/src/checker_mode.dart';

const _pathOption = 'path';
const _devIgnoresOption = 'dev-ignores';
const _mainIgnoresOption = 'main-ignores';

abstract final class ArgumentsParser {
  static ArgumentsResult parse(List<String> args) {
    final command = _command(_parse(args));

    return ArgumentsResult(
      mode: CheckerMode.values.firstWhere((v) => v.name == command.name),
      path: command.option(_pathOption) ?? Directory.current.path,
      devIgnores: command.resolve(_devIgnoresOption),
      mainIgnores: command.resolve(_mainIgnoresOption),
    );
  }

  static ArgResults _parse(List<String> args) {
    try {
      return _parser.parse(args);
    } on FormatException catch (e) {
      throw ArgumentsError(e.message);
    }
  }

  static ArgResults _command(ArgResults results) {
    final command = results.command;

    if (command == null) {
      throw ArgumentsError(
        'One of mode type is required: '
        '${CheckerMode.values.commaSeparated}',
      );
    }

    return command;
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
        ..addOption(_devIgnoresOption)
        ..addOption(_mainIgnoresOption),
    )
    ..addCommand(
      CheckerMode.transitiveUse.name,
      ArgParser()..withPathOption(),
    );
}

extension on ArgParser {
  void withPathOption() => addOption(_pathOption, abbr: _pathOption[0]);
}

extension on ArgResults {
  String? option(String key) => this[key] as String?;

  Set<String> resolve(String key) =>
      option(key)?.split(',').toSet() ?? const {};
}
