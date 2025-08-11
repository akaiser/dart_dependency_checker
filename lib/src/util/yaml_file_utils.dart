import 'package:dart_dependency_checker/src/dependency_type.dart';

final rootNodeExp = RegExp(r'^\w+:');
final depLocationNodesExp = RegExp(r'^(\s{4})(git|hosted|path|sdk|version):');
final depLocationGitNodesExp = RegExp(r'^(\s{6})(url|ref|path):');

final mainDependenciesNode = DependencyType.mainDependencies.yamlNode;
final devDependenciesNode = DependencyType.devDependencies.yamlNode;
