import 'package:dart_dependency_checker/src/_shared/package.dart';
import 'package:yaml/yaml.dart';

abstract final class DepsParser {
  static Iterable<Package> parse(YamlMap yamlMap) sync* {
    for (final entry in yamlMap.entries) {
      final name = entry.key as String;
      final value = entry.value;

      if (value is YamlMap) {
        if (value.containsKey('sdk')) {
          yield SdkPackage(name, _s(value['sdk']));
        } else if (value.containsKey('path')) {
          yield PathPackage(name, _s(value['path']));
        } else if (value.containsKey('git')) {
          final git = value['git'];
          if (git is String) {
            yield GitPackage(name, url: git.trim());
          } else if (git is YamlMap) {
            yield GitPackage(
              name,
              url: _s(git['url']),
              ref: _ns(git['ref']),
              path: _ns(git['path']),
            );
          }
        } else if (value.containsKey('hosted')) {
          yield HostedPackage(
            name,
            _s(value['version']),
            url: _ns(value['hosted']),
          );
        }
      } else if (value is String) {
        yield HostedPackage(name, value);
      }
    }
  }

  static String _s(dynamic value) => (value as String).trim();

  static String? _ns(dynamic value) => (value as String?)?.trim();
}
