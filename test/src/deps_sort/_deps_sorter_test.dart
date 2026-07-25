import 'package:dart_dependency_checker/src/deps_sort/_deps_sorter.dart';
import 'package:dart_dependency_checker/src/util/file_ext.dart';
import 'package:test/test.dart';

import '../_file_arrange_builder.dart';
import '../_paths.dart';

void main() {
  late FileArrangeBuilder builder;

  setUp(() => builder = FileArrangeBuilder());

  tearDown(() => builder.reset());

  group('providing $meantForSortingPath path', () {
    setUp(() => builder.init(meantForSortingPath));

    test('will sort all dependencies', () {
      final result = DepsSorter.sort(builder.file);

      expect(result, isTrue);
      expect(builder.file.read, builder.expectedFile.read);
    });

    test('will modify file', () async {
      DepsSorter.sort(builder.file);

      expect(builder.fileCreatedAt.isBefore(builder.fileModifiedAt), isTrue);
    });
  });

  group('providing $meantForSortingEmptyNodePath path', () {
    setUp(() => builder.init(meantForSortingEmptyNodePath));

    test('leaves blank dependency section', () {
      DepsSorter.sort(builder.file);

      expect(builder.file.read, builder.expectedFile.read);
    });

    test('will not modify anything', () async {
      final result = DepsSorter.sort(builder.file);

      expect(result, isFalse);
      expect(
        builder.fileCreatedAt.isAtSameMomentAs(builder.fileModifiedAt),
        isTrue,
      );
    });
  });

  group('providing $meantForSortingFlippedNodesPath path', () {
    setUp(() => builder.init(meantForSortingFlippedNodesPath));

    test('will sort all dependencies', () {
      final result = DepsSorter.sort(builder.file);

      expect(result, isTrue);
      expect(builder.file.read, builder.expectedFile.read);
    });
  });

  group('providing $noNodesPath path', () {
    setUp(() => builder.init(noNodesPath));

    test('will not sort anything', () {
      final result = DepsSorter.sort(builder.file);

      expect(result, isFalse);
      expect(builder.file.read, builder.expectedFile.read);
    });

    test('will not modify file', () async {
      DepsSorter.sort(builder.file);

      expect(
        builder.fileCreatedAt.isAtSameMomentAs(builder.fileModifiedAt),
        isTrue,
      );
    });
  });

  test('providing $noDependenciesPath path will not do anything', () {
    builder.init(noDependenciesPath);

    final result = DepsSorter.sort(builder.file);

    expect(result, isFalse);
    expect(
      builder.fileCreatedAt.isAtSameMomentAs(builder.fileModifiedAt),
      isTrue,
    );
  });
}
