import 'package:dart_dependency_checker/src/deps_add/model/source_type.dart';
import 'package:test/test.dart';

void main() {
  test('$SourceType has known values', () {
    expect(
      SourceType.values,
      [
        SourceType.hosted,
        SourceType.sdk,
        SourceType.git,
        SourceType.path,
        SourceType.unknown,
      ],
    );
  });

  <SourceType, bool>{
    SourceType.hosted: false,
    SourceType.sdk: true,
    SourceType.git: false,
    SourceType.path: false,
    SourceType.unknown: false,
  }.forEach((type, isSdk) {
    test('isSdk returns $isSdk for $type', () {
      expect(type.isSdk, isSdk);
    });
  });

  <String, SourceType>{
    'hosted': SourceType.hosted,
    'sdk': SourceType.sdk,
    'git': SourceType.git,
    'path': SourceType.path,
    'any': SourceType.unknown,
  }.forEach((source, type) {
    test('toSourceType returns $type for $source', () {
      expect(source.toSourceType, type);
    });
  });
}
