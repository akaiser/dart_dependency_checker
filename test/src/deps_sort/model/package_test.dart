import 'package:dart_dependency_checker/src/deps_sort/model/package.dart';
import 'package:test/test.dart';

void main() {
  group('$Package', () {
    test('sorts by name', () {
      const tested = [PackageImpl('a'), PackageImpl('c'), PackageImpl('b')];

      expect(
        [...tested]..sort(),
        const [PackageImpl('a'), PackageImpl('b'), PackageImpl('c')],
      );
    });
  });

  group('$SdkPackage', () {
    test('pubspecEntry', () {
      const tested = SdkPackage('a', sdk: 'flutter');

      expect(
        tested.pubspecEntry,
        '  a:\n    sdk: flutter',
      );
    });
  });

  group('$PathPackage', () {
    test('pubspecEntry', () {
      const tested = PathPackage('a', path: 'path/to/a');

      expect(
        tested.pubspecEntry,
        '  a:\n    path: path/to/a',
      );
    });
  });

  group('$HostedPackage', () {
    test('pubspecEntry without hostedUrl', () {
      const tested = HostedPackage('a', '1.0.0');

      expect(tested.pubspecEntry, '  a: 1.0.0');
    });

    test('pubspecEntry with hostedUrl', () {
      const tested = HostedPackage('a', '1.0.0', hostedUrl: 'https://a.b');

      expect(
        tested.pubspecEntry,
        '  a:\n    hosted: https://a.b\n    version: 1.0.0',
      );
    });
  });

  group('$GitPackage', () {
    test('pubspecEntry without path and ref', () {
      const tested = GitPackage('a', url: 'https://a.b');

      expect(
        tested.pubspecEntry,
        '  a:\n    git: https://a.b',
      );
    });

    test('pubspecEntry with path', () {
      const tested = GitPackage('a', url: 'https://a.b', path: 'path/to/a');

      expect(
        tested.pubspecEntry,
        '  a:\n    git:\n      url: https://a.b\n      path: path/to/a',
      );
    });

    test('pubspecEntry with ref', () {
      const tested = GitPackage('a', url: 'https://a.b', ref: 'ref');

      expect(
        tested.pubspecEntry,
        '  a:\n    git:\n      url: https://a.b\n      ref: ref',
      );
    });

    test('pubspecEntry with path and ref', () {
      const tested = GitPackage(
        'a',
        url: 'https://a.b',
        path: 'path/to/a',
        ref: 'ref',
      );

      expect(
        tested.pubspecEntry,
        '  a:\n    git:\n      url: https://a.b\n      path: path/to/a\n      ref: ref',
      );
    });
  });
}

class PackageImpl extends Package {
  const PackageImpl(super.name);

  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  String get pubspecEntry => throw UnimplementedError();
}
