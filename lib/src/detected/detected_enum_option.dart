import 'package:analyzer/dart/ast/ast.dart';
import 'package:maxi_reflection_constructor/maxi_reflection_constructor.dart';

class DetectedEnumOption {
  final String value;
  final List<DetectedAnnotation> annotations;

  const DetectedEnumOption({required this.value, required this.annotations});

  factory DetectedEnumOption.fromEnumOptionAnalizer({required EnumConstantDeclaration declaration}) {
    return DetectedEnumOption(
      annotations: declaration.metadata.map((x) => DetectedAnnotation.fromAnalizer(anotation: x)).toList(),
      value: declaration.name.toString(),
    );
  }
}
