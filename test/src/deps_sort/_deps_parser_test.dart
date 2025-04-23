import 'dart:io';

import 'package:dart_dependency_checker/src/_shared/package.dart';
import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/deps_sort/_deps_parser.dart';
import 'package:dart_dependency_checker/src/util/yaml_map_ext.dart';
import 'package:dart_dependency_checker/src/util/yaml_map_loader.dart';
import 'package:test/test.dart';

import '../_paths.dart';

void main() {
  test('providing $meantForSortingPath will be parsed expected', () {
    final yamlFile = File('$meantForSortingPath/pubspec.yaml');
    final yamlMap = YamlMapLoader.from(yamlFile);
    final mainYamlMap = yamlMap.node(DependencyType.mainDependencies);

    final result = DepsParser.parse(mainYamlMap!);

    expect(result, {
      const HostedPackage('meta', '^1.11.0'),
      const HostedPackage('args', '2.4.2'),
      const SdkPackage('flutter', 'flutter'),
      const PathPackage('some_path_source', '../some_path_dependency'),
      const PathPackage('some_path_source2', '../some_path_dependency2'),
      const HostedPackage('equatable', '^2.0.7'),
      const GitPackage(
        'window_size',
        'git@github.com:google/flutter-desktop-embedding.git',
        path: 'plugins/window_size',
        ref: 'e48abe7c3e9ebfe0b81622167c5201d4e783bb81',
      ),
      const GitPackage('yaansi', 'https://github.com/akaiser/yaansi.git'),
      const HostedPackage('path', '^1.9.1'),
      const HostedPackage('yaml', '3.1.3'),
    });
  });
}
