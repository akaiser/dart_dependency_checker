import 'package:dart_dependency_checker/src/deps_sort/model/package.dart';
import 'package:yaml/yaml.dart';

abstract final class DepsParser {
  static Set<Package> parse(YamlMap yamlMap) {
    final dependencies = <Package>{};

    yamlMap.forEach((key, value) {
      final name = key as String;
      if (value is YamlMap) {
        if (value.containsKey('sdk')) {
          dependencies.add(SdkPackage(name, sdk: _s(value['sdk'])));
        } else if (value.containsKey('path')) {
          dependencies.add(PathPackage(name, path: _s(value['path'])));
        } else if (value.containsKey('git')) {
          final git = value['git'];
          if (git is String) {
            dependencies.add(GitPackage(name, url: git.trim()));
          } else if (git is YamlMap) {
            dependencies.add(
              GitPackage(
                name,
                url: _s(git['url']),
                path: _ns(git['path']),
                ref: _ns(git['ref']),
              ),
            );
          }
        } else if (value.containsKey('hosted')) {
          dependencies.add(
            HostedPackage(
              name,
              _s(value['version']),
              hostedUrl: _ns(value['hosted']),
            ),
          );
        }
      } else if (value is String) {
        dependencies.add(HostedPackage(name, value));
      }
    });

    return dependencies;
  }

  static String _s(dynamic value) => (value as String).trim();

  static String? _ns(dynamic value) => (value as String?)?.trim();
}
