import 'package:equatable/equatable.dart';

abstract class BaseParams extends Equatable {
  const BaseParams({
    required this.path,
    this.mainIgnores = const {},
    this.devIgnores = const {},
    this.fix = false,
  });

  final String path;
  final Set<String> mainIgnores;
  final Set<String> devIgnores;
  final bool fix;

  @override
  List<Object> get props => [path, mainIgnores, devIgnores, fix];
}
