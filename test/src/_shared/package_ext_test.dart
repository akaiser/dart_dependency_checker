import 'package:dart_dependency_checker/src/_shared/package.dart';
import 'package:dart_dependency_checker/src/_shared/package_ext.dart';
import 'package:dart_dependency_checker/src/util/string_ext.dart';
import 'package:test/test.dart';

void main() {
  const hostedDep = 'some : ^2.0.7',
      hostedUrlDep = 'some: hosted=https://any.url; version=^2.0.7',
      pathDep = 'some: path = ../some',
      sdkDep = 'some: sdk= flutter',
      gitDep = 'some: git= https://any.git',
      gitRefDep = 'some : git=https://any.git; ref=main',
      gitPathDep = 'some: git =https://any.git ; path =any/dir',
      gitRefPathDep = 'some : git= https://any.git; ref = main; path =any/dir';

  test('toPackage', () {
    expect(hostedDep.toPackage, isA<HostedPackage>());
    expect(hostedUrlDep.toPackage, isA<HostedPackage>());
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

    test('hosted url', () {
      expect(
        hostedUrlDep.toPackage.pubspecEntry,
        '${'  some:'.newLine}'
        '${'    hosted: https://any.url'.newLine}'
        '${'    version: ^2.0.7'}',
      );
    });

    test('path', () {
      expect(
        pathDep.toPackage.pubspecEntry,
        '${'  some:'.newLine}'
        '${'    path: ../some'}',
      );
    });

    test('sdk', () {
      expect(
        sdkDep.toPackage.pubspecEntry,
        '${'  some:'.newLine}'
        '${'    sdk: flutter'}',
      );
    });

    test('git', () {
      expect(
        gitDep.toPackage.pubspecEntry,
        '${'  some:'.newLine}'
        '${'    git: https://any.git'}',
      );
    });

    test('git with ref', () {
      expect(
        gitRefDep.toPackage.pubspecEntry,
        '${'  some:'.newLine}'
        '${'    git:'.newLine}'
        '${'      url: https://any.git'.newLine}'
        '${'      ref: main'}',
      );
    });

    test('git with path', () {
      expect(
        gitPathDep.toPackage.pubspecEntry,
        '${'  some:'.newLine}'
        '${'    git:'.newLine}'
        '${'      url: https://any.git'.newLine}'
        '${'      path: any/dir'}',
      );
    });

    test('git with ref and path', () {
      expect(
        gitRefPathDep.toPackage.pubspecEntry,
        '${'  some:'.newLine}'
        '${'    git:'.newLine}'
        '${'      url: https://any.git'.newLine}'
        '${'      ref: main'.newLine}'
        '${'      path: any/dir'}',
      );
    });
  });
}
