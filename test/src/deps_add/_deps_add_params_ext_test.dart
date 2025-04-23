import 'package:dart_dependency_checker/src/deps_add/_deps_add_params_ext.dart';
import 'package:dart_dependency_checker/src/deps_add/deps_add_params.dart';
import 'package:dart_dependency_checker/src/performer_error.dart';
import 'package:test/test.dart';

import '../_paths.dart';

void main() {
  group('validate', () {
    const sourcePath = meantForAddingPath;

    group('throws $InvalidParamsError for', () {
      group('version', () {
        test('case 1', () {
          const params = DepsAddParams(path: sourcePath, main: {'any'});

          expect(
            params.validate,
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
          const params = DepsAddParams(path: sourcePath, dev: {'any:'});

          expect(
            params.validate,
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
          const params = DepsAddParams(path: sourcePath, dev: {'any: '});

          expect(
            params.validate,
            throwsA(
              isA<InvalidParamsError>().having(
                (e) => e.message,
                'message',
                'Invalid params near: "any: "',
              ),
            ),
          );
        });
      });

      group('path', () {
        test('case 1', () {
          const params = DepsAddParams(path: sourcePath, dev: {'any: path'});

          expect(
            params.validate,
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
          const params = DepsAddParams(path: sourcePath, dev: {'any: path='});

          expect(
            params.validate,
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
          const params = DepsAddParams(path: sourcePath, dev: {'any: path= '});

          expect(
            params.validate,
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
          const params = DepsAddParams(path: sourcePath, dev: {'any: sdk'});

          expect(
            params.validate,
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
          const params = DepsAddParams(path: sourcePath, dev: {'any: sdk='});

          expect(
            params.validate,
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
          const params = DepsAddParams(path: sourcePath, dev: {'any: sdk= '});

          expect(
            params.validate,
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
          const params = DepsAddParams(path: sourcePath, dev: {'any: git'});

          expect(
            params.validate,
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
          const params = DepsAddParams(path: sourcePath, dev: {'any: git='});

          expect(
            params.validate,
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
          const params = DepsAddParams(path: sourcePath, dev: {'any: git= '});

          expect(
            params.validate,
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
          const params = DepsAddParams(
            path: sourcePath,
            dev: {'any: git=any; ref'},
          );

          expect(
            params.validate,
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
          const params = DepsAddParams(
            path: sourcePath,
            dev: {'any: git=any; ref='},
          );

          expect(
            params.validate,
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
          const params = DepsAddParams(
            path: sourcePath,
            dev: {'any: git=any; ref= '},
          );

          expect(
            params.validate,
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
          const params = DepsAddParams(
            path: sourcePath,
            dev: {'any: git=any; path'},
          );

          expect(
            params.validate,
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
          const params = DepsAddParams(
            path: sourcePath,
            dev: {'any: git=any; path='},
          );

          expect(
            params.validate,
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
          const params = DepsAddParams(
            path: sourcePath,
            dev: {'any: git=any; path= '},
          );

          expect(
            params.validate,
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
          const params = DepsAddParams(
            path: sourcePath,
            dev: {'any: git=any; ref=any path=any'},
          );

          expect(
            params.validate,
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
      group('version', () {
        test('case 1', () {
          const params = DepsAddParams(path: sourcePath, main: {'any:any'});

          params.validate();
        });

        test('case 2', () {
          const params = DepsAddParams(path: sourcePath, main: {' any : any '});

          params.validate();
        });
      });

      group('path', () {
        test('case 1', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {'any:path=any'},
          );

          params.validate();
        });

        test('case 2', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {' any : path = any '},
          );

          params.validate();
        });
      });

      group('sdk', () {
        test('case 1', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {'any:sdk=any'},
          );

          params.validate();
        });

        test('case 2', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {' any : sdk = any '},
          );

          params.validate();
        });
      });

      group('git', () {
        test('case 1', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {'any:git=any'},
          );

          params.validate();
        });

        test('case 2', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {'any:git=any;ref=any'},
          );

          params.validate();
        });

        test('case 3', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {'any:git=any;path=any'},
          );

          params.validate();
        });

        test('case 4', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {'any:git=any;ref=any;path=any'},
          );

          params.validate();
        });

        test('case 5', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {' any : git = any '},
          );

          params.validate();
        });

        test('case 6', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {' any : git = any ; ref = any '},
          );

          params.validate();
        });

        test('case 7', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {' any : git = any ; path = any '},
          );

          params.validate();
        });

        test('case 8', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {' any : git = any ; ref = any ; path = any '},
          );

          params.validate();
        });
      });
    });
  });
}
