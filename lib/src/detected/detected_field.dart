import 'package:analyzer/dart/ast/ast.dart';
import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection_constructor/maxi_reflection_constructor.dart';

class DetectedField {
  final List<DetectedAnnotation> annotations;
  final String name;
  final String typeValue;
  final bool isStatic;
  final bool isConst;
  final bool isLate;
  final bool isFinal;
  final bool hasDefaultValue;
  final String defaulValue;

  bool get isPrivate => name.first == '_';
  bool get acceptNull => typeValue.last == '?';

  const DetectedField({
    required this.annotations,
    required this.name,
    required this.typeValue,
    required this.isStatic,
    required this.isConst,
    required this.isLate,
    required this.isFinal,
    required this.hasDefaultValue,
    required this.defaulValue,
  });

  static Result<DetectedField> fromFieldAnalizer({required VariableDeclaration declaration}) {
    final parentListResult = volatileFunction<VariableDeclarationList>(
      error: (ex, st) => NegativeResult.controller(
        code: ErrorCode.wrongType,
        message: FlexibleOration(message: 'Parent of variable %1 is not "VariableDeclarationList"', textParts: [declaration.toString()]),
      ),

      function: () => declaration.parent as VariableDeclarationList,
    );
    if (parentListResult.itsFailure) return parentListResult.cast();
    final parentList = parentListResult.content;

    final parentResult = volatileFunction<FieldDeclaration>(
      error: (ex, st) => NegativeResult.controller(
        code: ErrorCode.wrongType,
        message: FlexibleOration(message: 'Parent of variable %1 is "VariableDeclaration"', textParts: [parentList.toString()]),
      ),
      function: () => parentList.parent as FieldDeclaration,
    );
    if (parentResult.itsFailure) return parentResult.cast();
    final parent = parentResult.content;

    return ResultValue(
      content: DetectedField(
        annotations: parent.metadata.map((x) => DetectedAnnotation.fromAnalizer(anotation: x)).toList(),
        name: declaration.name.toString(),
        typeValue: parentList.type?.toString() ?? 'dynamic',
        isConst: declaration.isConst,
        isFinal: declaration.isFinal,
        isLate: declaration.isLate,
        isStatic: parent.isStatic,
        defaulValue: declaration.initializer?.toString() ?? '',
        hasDefaultValue: declaration.initializer != null,
      ),
    );
  }
}
