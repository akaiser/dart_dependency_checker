import 'package:dart_dependency_checker/src/_shared/package.dart';
import 'package:dart_dependency_checker/src/_shared/package_ext.dart';
import 'package:test/test.dart';

void main() {
  const hostedDep = 'some : ^2.0.7',
      pathDep = 'some: path = ../some',
      sdkDep = 'some: sdk= flutter',
      gitDep = 'some: git= https://any.git',
      gitRefDep = 'some : git=https://any.git; ref=main',
      gitPathDep = 'some: git =https://any.git ; path =any/dir',
      gitRefPathDep = 'some : git= https://any.git; ref = main; path =any/dir';

  test('toPackage', () {
    expect(hostedDep.toPackage, isA<HostedPackage>());
    expect(pathDep.toPackage, isA<PathPackage>());
    expect(sdkDep.toPackage, isA<SdkPackage>());
    expect(gitDep.toPackage, isA<GitPackage>());
    expect(gitRefDep.toPackage, isA<GitPackage>());
    expect(gitPathDep.toPackage, isA<GitPackage>());
    expect(gitRefPathDep.toPackage, isA<GitPackage>());
  });

  group('pubspecEntry', () {
    test('hosted', () {
      expect(hostedDep.toPackage.pubspecEntry, '  some: ^2.0.7');
    });

    test('path', () {
      expect(
        pathDep.toPackage.pubspecEntry,
        '  some:\n'
        '    path: ../some',
      );
    });

    test('sdk', () {
      expect(
        sdkDep.toPackage.pubspecEntry,
        '  some:\n'
        '    sdk: flutter',
      );
    });

    test('git', () {
      expect(
        gitDep.toPackage.pubspecEntry,
        '  some:\n'
        '    git: https://any.git',
      );
    });

    test('git with ref', () {
      expect(
        gitRefDep.toPackage.pubspecEntry,
        '  some:\n'
        '    git:\n'
        '      url: https://any.git\n'
        '      ref: main',
      );
    });

    test('git with path', () {
      expect(
        gitPathDep.toPackage.pubspecEntry,
        '  some:\n'
        '    git:\n'
        '      url: https://any.git\n'
        '      path: any/dir',
      );
    });

    test('git with ref and path', () {
      expect(
        gitRefPathDep.toPackage.pubspecEntry,
        '  some:\n'
        '    git:\n'
        '      url: https://any.git\n'
        '      ref: main\n'
        '      path: any/dir',
      );
    });
  });
}
