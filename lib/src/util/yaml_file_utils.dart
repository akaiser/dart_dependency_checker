import 'package:dart_dependency_checker/src/dependency_type.dart';

final rootNodeExp = RegExp(r'^\w+:');
final depLocationNodeExp = RegExp(r'^(\s{2})+(path|sdk|git|url|ref):');

final mainDependenciesNode = DependencyType.mainDependencies.yamlNode;
final devDependenciesNode = DependencyType.devDependencies.yamlNode;
