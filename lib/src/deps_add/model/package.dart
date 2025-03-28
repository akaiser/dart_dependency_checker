import 'package:dart_dependency_checker/src/deps_add/model/source_type.dart';
import 'package:dart_dependency_checker/src/util/string_ext.dart';
import 'package:equatable/equatable.dart';

class Package extends Equatable {
  final SourceType type;
  final String pubspecEntry;

  const Package(
    this.type,
    this.pubspecEntry,
  );

  @override
  List<Object?> get props => [type, pubspecEntry];
}

extension StringExt on String {
  Package get toPackage {
    final parts = split(':');

    final dependencyName = parts[0].trim();
    final dependencyValue = parts[1].trim();
    final dependencySource = parts.length > 2
        ? '$dependencyValue:${parts[2].trim()}'
        : dependencyValue;

    final sourceParts = dependencySource.split('=');

    if (sourceParts.length == 2) {
      final sourceName = sourceParts[0].trim();
      final sourceValue = sourceParts[1].trim();

      return Package(
        sourceName.toSourceType,
        '  $dependencyName:'.newLine + //
            '    $sourceName: $sourceValue'.newLine,
      );
    } else {
      return Package(
        SourceType.hosted,
        '  $dependencyName: $dependencySource'.newLine,
      );
    }
  }
}
