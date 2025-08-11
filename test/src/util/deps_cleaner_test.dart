import 'package:dart_dependency_checker/src/util/deps_cleaner.dart';
import 'package:test/test.dart';

import '../_file_arrange_builder.dart';
import '../_paths.dart';
import '../_util.dart';

void main() {
  late FileArrangeBuilder builder;

  setUp(() => builder = FileArrangeBuilder());

  tearDown(() => builder.reset());

  group('providing $meantForFixingPath path', () {
    const sourcePath = meantForFixingPath;

    setUp(() => builder.init(sourcePath));

    test('cleanes source file', () {
      final removedDependencies = DepsCleaner.clean(
        builder.file,
        mainDependencies: const {
          'meta',
          'path', // not inside yaml file
          'bla_analytics',
        },
        devDependencies: const {
          'integration_test',
          'lints',
          'bla_test_bed',
          'git', // not inside yaml file
          'url' // not inside yaml file
        },
      );

      expect(builder.readFile, builder.readExpectedFile);
      expect(removedDependencies, const {
        'meta',
        'bla_analytics',
        'integration_test',
        'lints',
        'bla_test_bed',
      });
    });

    test('leaves blank dependency sections', () {
      final removedDependencies = DepsCleaner.clean(
        builder.file,
        mainDependencies: const {
          'args',
          'meta',
          'bla_analytics',
          'some_hosted_source',
          'bla_support',
        },
        devDependencies: const {
          'flutter_test',
          'integration_test',
          'bla_dart_lints',
          'lints',
          'test',
          'bla_test_bed',
          'bla_other_bed',
        },
      );

      expect(builder.readFile, '$sourcePath/expected_empty_nodes.yaml'.read);
      expect(removedDependencies, const {
        'args',
        'meta',
        'bla_analytics',
        'some_hosted_source',
        'bla_support',
        'flutter_test',
        'integration_test',
        'bla_dart_lints',
        'lints',
        'test',
        'bla_test_bed',
        'bla_other_bed',
      });
    });

    test('will modify file if something was removed', () {
      final removedDependencies = DepsCleaner.clean(
        builder.file,
        mainDependencies: const {'meta'},
        devDependencies: const {},
      );

      expect(builder.fileCreatedAt.isBefore(builder.fileModifiedAt), isTrue);
      expect(removedDependencies, const {'meta'});
    });

    test('will not modify file if nothing was removed', () {
      final removedDependencies = DepsCleaner.clean(
        builder.file,
        mainDependencies: const {'equatable'},
        devDependencies: const {},
      );

      expect(
        builder.fileCreatedAt.isAtSameMomentAs(builder.fileCreatedAt),
        isTrue,
      );
      expect(removedDependencies, const <String>{});
    });
  });

  group('providing $noNodesPath path', () {
    setUp(() => builder.init(noNodesPath));

    test('passes with no changes', () {
      final removedDependencies = DepsCleaner.clean(
        builder.file,
        mainDependencies: const {},
        devDependencies: const {},
      );

      expect(builder.readFile, builder.readExpectedFile);
      expect(removedDependencies, isEmpty);
    });
  });
}
