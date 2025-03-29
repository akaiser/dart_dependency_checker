import 'package:dart_dependency_checker/src/deps_unused/_deps_cleaner.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';
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
      const results = DepsUnusedResults(
        mainDependencies: {'meta', 'bla_analytics'},
        devDependencies: {'integration_test', 'lints', 'bla_test_bed'},
      );

      DepsCleaner.clean(results, builder.file);

      expect(builder.readFile, builder.readExpectedFile);
    });

    test('leaves blank dependency sections', () {
      const results = DepsUnusedResults(
        mainDependencies: {
          'args',
          'meta',
          'bla_analytics',
          'bla_support',
        },
        devDependencies: {
          'flutter_test',
          'integration_test',
          'bla_dart_lints',
          'lints',
          'test',
          'bla_test_bed',
          'bla_other_bed',
        },
      );

      DepsCleaner.clean(results, builder.file);

      expect(
        builder.readFile,
        '$sourcePath/expected_empty_nodes.yaml'.read,
      );
    });

    test('will modify file if something was removed', () async {
      DepsCleaner.clean(
        const DepsUnusedResults(
          mainDependencies: {'meta'},
          devDependencies: {},
        ),
        builder.file,
      );

      expect(
        builder.fileCreatedAt.isBefore(builder.fileModifiedAt),
        isTrue,
      );
    });

    test('will not modify file if nothing was removed', () async {
      DepsCleaner.clean(
        const DepsUnusedResults(
          mainDependencies: {'equatable'},
          devDependencies: {},
        ),
        builder.file,
      );

      expect(
        builder.fileCreatedAt.isAtSameMomentAs(builder.fileCreatedAt),
        isTrue,
      );
    });
  });

  group('providing $meantForFixingNoNodesPath path', () {
    const sourcePath = meantForFixingNoNodesPath;

    setUp(() => builder.init(sourcePath));

    test('passes with no changes', () {
      const results = DepsUnusedResults(
        mainDependencies: {},
        devDependencies: {},
      );

      DepsCleaner.clean(results, builder.file);

      expect(builder.readFile, builder.readExpectedFile);
    });
  });
}
