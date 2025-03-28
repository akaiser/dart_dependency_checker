import 'package:dart_dependency_checker/src/deps_add/model/package.dart';
import 'package:dart_dependency_checker/src/deps_add/model/source_type.dart';
import 'package:dart_dependency_checker/src/util/string_ext.dart';
import 'package:test/test.dart';

void main() {
  test('has known props count', () {
    const tested = Package(SourceType.hosted, 'any');

    expect(tested.props, hasLength(2));
  });

  test('toPackage extension', () {
    const hostedDependency = 'equatable: ^2.0.7';
    const sdkDependency = 'flutter: sdk=flutter';
    const gitDependency = 'kittens: git=https://any.where.git';
    const pathDependency = 'awesome: path=../awesome';
    const unknownDependency = 'unknown: some_value';

    expect(
      hostedDependency.toPackage,
      Package(SourceType.hosted, '  equatable: ^2.0.7'.newLine),
    );
    expect(
      sdkDependency.toPackage,
      Package(
        SourceType.sdk,
        '  flutter:'.newLine + '    sdk: flutter'.newLine,
      ),
    );
    expect(
      gitDependency.toPackage,
      Package(
        SourceType.git,
        '  kittens:'.newLine + '    git: https://any.where.git'.newLine,
      ),
    );
    expect(
      pathDependency.toPackage,
      Package(
        SourceType.path,
        '  awesome:'.newLine + '    path: ../awesome'.newLine,
      ),
    );
    expect(
      unknownDependency.toPackage,
      Package(SourceType.hosted, '  unknown: some_value'.newLine),
    );
  });
}
