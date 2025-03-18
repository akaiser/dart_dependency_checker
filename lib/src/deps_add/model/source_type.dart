enum SourceType {
  hosted,
  sdk,
  git,
  path,
  unknown,
}

extension SourceTypeExt on SourceType {
  bool get isSdk => this == SourceType.sdk;
}

extension StringExt on String {
  SourceType get toSourceType => switch (this) {
        'hosted' => SourceType.hosted, // equatable: ^2.0.7
        'sdk' => SourceType.sdk, // flutter: sdk=flutter
        'git' => SourceType.git, // kittens: git=https://any.where.git
        'path' => SourceType.path, // awesome: path=../awesome
        _ => SourceType.unknown,
      };
}
