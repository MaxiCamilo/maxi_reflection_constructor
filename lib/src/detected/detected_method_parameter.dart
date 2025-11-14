import 'package:analyzer/dart/ast/ast.dart';
import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection_constructor/maxi_reflection_constructor.dart';

class DetectedMethodParameter {
  final List<DetectedAnnotation> annotations;
  final String name;
  final String typeValue;
  final int position;
  final bool isNamed;
  final bool hasDefaultValue;
  final String defaultValue;
  final bool acceptNulls;

  const DetectedMethodParameter({
    required this.annotations,
    required this.name,
    required this.typeValue,
    required this.position,
    required this.isNamed,
    required this.hasDefaultValue,
    required this.defaultValue,
    required this.acceptNulls,
  });

  factory DetectedMethodParameter.fromAnalizer({required int position, required FormalParameter declaration}) {
    /*
    if (declaration is DefaultFormalParameter) {
      return DetectedMethodParameter.fromAnalizer(position: position, declaration: declaration.parameter);
    }*/
    final type = _getTypeValue(declaration);

    return DetectedMethodParameter(
      annotations: declaration.metadata.map((x) => DetectedAnnotation.fromAnalizer(anotation: x)).toList(),
      isNamed: declaration.isNamed,
      name: declaration.name.toString(),
      position: position,
      typeValue: type,
      acceptNulls: type.last == '?',
      hasDefaultValue: !declaration.isRequired,
      defaultValue: _getDefaultValue(typeParameter: type, declaration: declaration),
    );
  }

  static List<DetectedMethodParameter> getAnalizerParameters({required FormalParameterList? parameters}) {
    if (parameters == null) {
      return const [];
    }

    final list = <DetectedMethodParameter>[];

    for (int i = 0; i < parameters.parameters.length; i++) {
      final item = DetectedMethodParameter.fromAnalizer(position: i, declaration: parameters.parameters[i]);
      list.add(item);
    }

    return list;
  }

  static String _getTypeValue(FormalParameter declaration) {
    if (declaration is SimpleFormalParameter) {
      return declaration.type?.toString() ?? 'dynamic';
    }
    if (declaration is DefaultFormalParameter) {
      return _getTypeValue(declaration.parameter);
    }
    return 'dynamic';
    //return declaration.declaredElement?.type.toString() ?? 'dynamic';
  }

  static String _getDefaultValue({required String typeParameter, required FormalParameter declaration}) {
    if (declaration.isRequired) {
      return '';
    }
    if (declaration is DefaultFormalParameter) {
      return declaration.defaultValue?.toString() ?? '';
    } else {
      return 'dynamic';
      //return declaration.declaredElement?.defaultValueCode ?? '';
    }
  }
}
