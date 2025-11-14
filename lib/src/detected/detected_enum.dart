import 'package:analyzer/dart/ast/ast.dart';
import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection_constructor/maxi_reflection_constructor.dart';

class DetectedEnum {
  final String name;
  final List<DetectedEnumOption> options;
  final List<DetectedAnnotation> annotations;

  bool get isPrivate => name.first == '_';

  const DetectedEnum({required this.name, required this.options, required this.annotations});

  factory DetectedEnum.fromenumFactory({required EnumDeclaration declaration}) {
    return DetectedEnum(
      annotations: declaration.metadata.map((x) => DetectedAnnotation.fromAnalizer(anotation: x)).toList(),
      name: declaration.name.toString(),
      options: declaration.constants.map((x) => DetectedEnumOption.fromEnumOptionAnalizer(declaration: x)).toList(),
    );
  }
}
