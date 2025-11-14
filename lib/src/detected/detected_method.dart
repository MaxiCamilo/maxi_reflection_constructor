import 'package:analyzer/dart/ast/ast.dart';
import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection_constructor/maxi_reflection_constructor.dart';

enum DetectedMethodType { commonMethod, getMehtod, setMethod, buildMethod, factoryMethod }

class DetectedMethod {
  final List<DetectedAnnotation> annotations;
  final String name;
  final String typeReturn;
  final DetectedMethodType type;
  final bool isStatic;
  final bool isConst;
  final List<DetectedMethodParameter> parameters;

  bool get isPrivate => name.first == '_';

  const DetectedMethod({required this.annotations, required this.name, required this.typeReturn, required this.type, required this.isStatic, required this.parameters, required this.isConst});

  factory DetectedMethod.fromMethodAnalizer({required MethodDeclaration declaration}) {
    return DetectedMethod(
      isStatic: declaration.isStatic,
      name: declaration.name.toString(),
      typeReturn: _getTypeReturn(declaration),
      annotations: declaration.metadata.map((x) => DetectedAnnotation.fromAnalizer(anotation: x)).toList(),
      type: _checkMethodType(declaration),
      isConst: false,
      parameters: DetectedMethodParameter.getAnalizerParameters(parameters: declaration.parameters),
    );
  }

  factory DetectedMethod.fromConstructAnalizer({required ConstructorDeclaration declaration}) {
    return DetectedMethod(
      isStatic: true,
      name: declaration.name?.toString() ?? '',
      typeReturn: declaration.returnType.name,
      annotations: declaration.metadata.map((x) => DetectedAnnotation.fromAnalizer(anotation: x)).toList(),
      type: declaration.factoryKeyword == null ? DetectedMethodType.buildMethod : DetectedMethodType.factoryMethod,
      parameters: DetectedMethodParameter.getAnalizerParameters(parameters: declaration.parameters),
      isConst: declaration.constKeyword != null,
    );
  }

  static DetectedMethodType _checkMethodType(MethodDeclaration declaration) {
    if (declaration.isGetter) {
      return DetectedMethodType.getMehtod;
    } else if (declaration.isSetter) {
      return DetectedMethodType.setMethod;
    } else {
      return DetectedMethodType.commonMethod;
    }
  }

  static String _getTypeReturn(MethodDeclaration declaration) {
    return declaration.returnType?.toString() ?? 'void';
  }
}
