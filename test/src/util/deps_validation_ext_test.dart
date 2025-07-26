import 'package:dart_dependency_checker/src/performer_error.dart';
import 'package:dart_dependency_checker/src/util/deps_validation_ext.dart';
import 'package:test/test.dart';

void main() {
  group('throws $InvalidParamsError for', () {
    group('hosted', () {
      test('case 1', () {
        expect(
          const {'any'}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any"',
            ),
          ),
        );
      });

      test('case 2', () {
        expect(
          const {'any:'}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any:"',
            ),
          ),
        );
      });

      test('case 3', () {
        expect(
          const {'any: '}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: "',
            ),
          ),
        );
      });

      test('case 4', () {
        expect(
          const {'any: hosted'}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: hosted"',
            ),
          ),
        );
      });

      test('case 5', () {
        expect(
          const {'any: hosted='}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: hosted="',
            ),
          ),
        );
      });

      test('case 6', () {
        expect(
          const {'any: hosted=any'}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: hosted=any"',
            ),
          ),
        );
      });

      test('case 7', () {
        expect(
          const {'any: hosted=any; version'}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: hosted=any; version"',
            ),
          ),
        );
      });

      test('case 8', () {
        expect(
          const {'any: hosted=any; version= '}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: hosted=any; version= "',
            ),
          ),
        );
      });
    });

    group('path', () {
      test('case 1', () {
        expect(
          const {'any: path'}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: path"',
            ),
          ),
        );
      });

      test('case 2', () {
        expect(
          const {'any: path='}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: path="',
            ),
          ),
        );
      });

      test('case 3', () {
        expect(
          const {'any: path= '}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: path= "',
            ),
          ),
        );
      });
    });

    group('sdk', () {
      test('case 1', () {
        expect(
          const {'any: sdk'}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: sdk"',
            ),
          ),
        );
      });

      test('case 2', () {
        expect(
          const {'any: sdk='}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: sdk="',
            ),
          ),
        );
      });

      test('case 3', () {
        expect(
          const {'any: sdk= '}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: sdk= "',
            ),
          ),
        );
      });
    });

    group('git', () {
      test('case 1', () {
        expect(
          const {'any: git'}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: git"',
            ),
          ),
        );
      });

      test('case 2', () {
        expect(
          const {'any: git='}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: git="',
            ),
          ),
        );
      });

      test('case 3', () {
        expect(
          const {'any: git= '}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: git= "',
            ),
          ),
        );
      });

      test('case 4', () {
        expect(
          const {'any: git=any; ref'}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: git=any; ref"',
            ),
          ),
        );
      });

      test('case 5', () {
        expect(
          const {'any: git=any; ref='}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: git=any; ref="',
            ),
          ),
        );
      });

      test('case 6', () {
        expect(
          const {'any: git=any; ref= '}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: git=any; ref= "',
            ),
          ),
        );
      });

      test('case 7', () {
        expect(
          const {'any: git=any; path'}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: git=any; path"',
            ),
          ),
        );
      });

      test('case 8', () {
        expect(
          const {'any: git=any; path='}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: git=any; path="',
            ),
          ),
        );
      });

      test('case 9', () {
        expect(
          const {'any: git=any; path= '}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: git=any; path= "',
            ),
          ),
        );
      });

      test('case 10', () {
        expect(
          const {'any: git=any; ref=any path=any'}.validate,
          throwsA(
            isA<InvalidParamsError>().having(
              (e) => e.message,
              'message',
              'Invalid params near: "any: git=any; ref=any path=any"',
            ),
          ),
        );
      });
    });
  });

  group('passes', () {
    group('hosted', () {
      test('case 1', () {
        const {'any:any'}.validate();
      });

      test('case 2', () {
        const {' any : any '}.validate();
      });

      test('case 3', () {
        const {'any: hosted =any ; version= any '}.validate();
      });
    });

    group('path', () {
      test('case 1', () {
        const {'any:path=any'}.validate();
      });

      test('case 2', () {
        const {' any : path = any '}.validate();
      });
    });

    group('sdk', () {
      test('case 1', () {
        const {'any:sdk=any'}.validate();
      });

      test('case 2', () {
        const {' any : sdk = any '}.validate();
      });
    });

    group('git', () {
      test('case 1', () {
        const {'any:git=any'}.validate();
      });

      test('case 2', () {
        const {'any:git=any;ref=any'}.validate();
      });

      test('case 3', () {
        const {'any:git=any;path=any'}.validate();
      });

      test('case 4', () {
        const {'any:git=any;ref=any;path=any'}.validate();
      });

      test('case 5', () {
        const {' any : git = any '}.validate();
      });

      test('case 6', () {
        const {' any : git = any ; ref = any '}.validate();
      });

      test('case 7', () {
        const {' any : git = any ; path = any '}.validate();
      });

      test('case 8', () {
        const {' any : git = any ; ref = any ; path = any '}.validate();
      });
    });
  });
}
