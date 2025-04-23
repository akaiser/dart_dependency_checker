import 'package:dart_dependency_checker/src/deps_add/deps_add_params.dart';
import 'package:dart_dependency_checker/src/deps_add/deps_add_performer.dart';
import 'package:dart_dependency_checker/src/performer_error.dart';
import 'package:test/test.dart';

import '../_file_arrange_builder.dart';
import '../_paths.dart';

void main() {
  test(
      'throws a $PerformerError with proper message '
      'on invalid pubspec.yaml path', () {
    expect(
      const DepsAddPerformer(DepsAddParams(path: 'unknown')).perform,
      throwsA(
        isA<PerformerError>().having(
          (e) => e.message,
          'message',
          'Invalid pubspec.yaml file path: unknown/pubspec.yaml',
        ),
      ),
    );
  });

  group('params validation', () {
    const sourcePath = meantForAddingPath;

    group('throws $InvalidParamsError for', () {
      group('version', () {
        test('case 1', () {
          const params = DepsAddParams(path: sourcePath, main: {'any'});

          expect(
            const DepsAddPerformer(params).perform,
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
            const DepsAddPerformer(params).perform,
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
            const DepsAddPerformer(params).perform,
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
            const DepsAddPerformer(params).perform,
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
            const DepsAddPerformer(params).perform,
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
            const DepsAddPerformer(params).perform,
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
            const DepsAddPerformer(params).perform,
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
            const DepsAddPerformer(params).perform,
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
            const DepsAddPerformer(params).perform,
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
            const DepsAddPerformer(params).perform,
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
            const DepsAddPerformer(params).perform,
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
            const DepsAddPerformer(params).perform,
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
          const params =
              DepsAddParams(path: sourcePath, dev: {'any: git=any; ref'});

          expect(
            const DepsAddPerformer(params).perform,
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
            const DepsAddPerformer(params).perform,
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
            const DepsAddPerformer(params).perform,
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
            const DepsAddPerformer(params).perform,
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
            const DepsAddPerformer(params).perform,
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
            const DepsAddPerformer(params).perform,
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
            const DepsAddPerformer(params).perform,
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
      late FileArrangeBuilder builder;

      setUp(() => builder = FileArrangeBuilder()..init(sourcePath));

      tearDown(() => builder.reset());

      group('version', () {
        test('case 1', () {
          const params = DepsAddParams(path: sourcePath, main: {'any:any'});

          const DepsAddPerformer(params).perform();
        });

        test('case 2', () {
          const params = DepsAddParams(path: sourcePath, main: {' any : any '});

          const DepsAddPerformer(params).perform();
        });
      });

      group('path', () {
        test('case 1', () {
          const params =
              DepsAddParams(path: sourcePath, main: {'any:path=any'});

          const DepsAddPerformer(params).perform();
        });

        test('case 2', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {' any : path = any '},
          );

          const DepsAddPerformer(params).perform();
        });
      });

      group('sdk', () {
        test('case 1', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {'any:sdk=any'},
          );

          const DepsAddPerformer(params).perform();
        });

        test('case 2', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {' any : sdk = any '},
          );

          const DepsAddPerformer(params).perform();
        });
      });

      group('git', () {
        test('case 1', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {'any:git=any'},
          );

          const DepsAddPerformer(params).perform();
        });

        test('case 2', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {'any:git=any;ref=any'},
          );

          const DepsAddPerformer(params).perform();
        });

        test('case 3', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {'any:git=any;path=any'},
          );

          const DepsAddPerformer(params).perform();
        });

        test('case 4', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {'any:git=any;ref=any;path=any'},
          );

          const DepsAddPerformer(params).perform();
        });

        test('case 5', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {' any : git = any '},
          );

          const DepsAddPerformer(params).perform();
        });

        test('case 6', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {' any : git = any ; ref = any '},
          );

          const DepsAddPerformer(params).perform();
        });

        test('case 7', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {' any : git = any ; path = any '},
          );

          const DepsAddPerformer(params).perform();
        });

        test('case 8', () {
          const params = DepsAddParams(
            path: sourcePath,
            main: {' any : git = any ; ref = any ; path = any '},
          );

          const DepsAddPerformer(params).perform();
        });
      });
    });
  });
}
