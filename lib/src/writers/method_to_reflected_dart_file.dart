import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection/maxi_reflection.dart';
import 'package:maxi_reflection_constructor/maxi_reflection_constructor.dart';

class MethodToReflectedDartFile implements SyncFunctionality<(String, String)> {
  final DetectedClass parentClass;
  final DetectedMethod processedMethod;

  const MethodToReflectedDartFile({required this.parentClass, required this.processedMethod});

  @override
  Result<(String, String)> execute() {
    final buffer = StringBuffer();
    final genericTypes = '<${parentClass.name}, ${processedMethod.typeReturn}>';
    final builerName = '_build${parentClass.name}${processedMethod.name}Method';

    buffer.writeln('//[METHOD] ${parentClass.name} -> ${processedMethod.name}');

    buffer.writeln('ReflectedMethodInstance$genericTypes $builerName(ReflectionManager manager){');
    buffer.writeln('\tfinal annotations = const [${processedMethod.annotations.join(',')}];');
    buffer.writeln('\treturn ReflectedMethodInstance$genericTypes(');

    buffer.writeln('\t\tanotations: annotations,');
    buffer.writeln('\t\tname: \'${processedMethod.name}\',');
    buffer.writeln('\t\tisStatic: ${processedMethod.isStatic ? 'true' : 'false'},');
    buffer.writeln('\t\tmethodType: ReflectedMethodType.${_parseMethodType().name},');
    buffer.writeln('\t\treflectedType: ReflectedFlexible(externalAnotations: annotations, manager: manager, realType: ${processedMethod.typeReturn}),');

    buffer.write('\t\tinvoker: (instance, parameters) => ');
    switch (processedMethod.type) {
      case DetectedMethodType.commonMethod:
        buffer.writeln('${processedMethod.isStatic ? '${parentClass.name}.' : 'instance!.'}${processedMethod.name}(${_generateCaller()}),');
        break;
      case DetectedMethodType.getMehtod:
        buffer.writeln('${processedMethod.isStatic ? '${parentClass.name}.' : 'instance!.'}${processedMethod.name},');
        break;
      case DetectedMethodType.setMethod:
        buffer.writeln('${processedMethod.isStatic ? '${parentClass.name}.' : 'instance!.'}${processedMethod.name} = ${_generateCaller()},');
        break;
      case DetectedMethodType.buildMethod:
        buffer.writeln('${parentClass.name}(${_generateCaller()}),');
        break;
      case DetectedMethodType.factoryMethod:
        buffer.writeln('${parentClass.name}.${processedMethod.name}(${_generateCaller()}),');
        break;
    }

    buffer.writeln('\t\tfixedParameters: [');
    for (final fixed in processedMethod.parameters.where((element) => !element.isNamed)) {
      _whiteFixedParameter(buffer: buffer, fixed: fixed);
    }

    buffer.writeln('\t\t],');

    buffer.writeln('\t\tnamedParameters: [');
    for (final named in processedMethod.parameters.where((element) => element.isNamed)) {
      _whiteNamedParameter(buffer: buffer, named: named);
    }

    buffer.writeln('\t\t],');

    buffer.writeln('\t);');
    buffer.writeln('}');
    buffer.writeln('/////////////////////////////////////////////////////////////////////////////////////////');

    return ResultValue(content: (builerName, buffer.toString()));
  }

  ReflectedMethodType _parseMethodType() {
    switch (processedMethod.type) {
      case DetectedMethodType.commonMethod:
        return ReflectedMethodType.method;
      case DetectedMethodType.getMehtod:
        return ReflectedMethodType.getter;
      case DetectedMethodType.setMethod:
        return ReflectedMethodType.setter;
      case DetectedMethodType.buildMethod:
      case DetectedMethodType.factoryMethod:
        return ReflectedMethodType.contructor;
    }
  }

  String _generateCaller() {
    if (processedMethod.parameters.isEmpty) return '';

    final parameters = <String>[];

    for (final fixed in processedMethod.parameters.where((x) => !x.isNamed)) {
      if (fixed.hasDefaultValue) {
        parameters.add('parameters.optionalFixed<${fixed.typeValue}>(location: ${fixed.position}, predetermined: ${fixed.defaultValue})');
      } else {
        parameters.add('parameters.fixed<${fixed.typeValue}>(${fixed.position})');
      }
    }

    for (final named in processedMethod.parameters.where((x) => x.isNamed)) {
      if (named.hasDefaultValue) {
        parameters.add('${named.name}: parameters.optionalNamed<${named.typeValue}>(name: \'${named.name}\', predetermined: ${named.defaultValue})');
      } else {
        parameters.add('${named.name}: parameters.named<${named.typeValue}>(\'${named.name}\')');
      }
    }

    return parameters.join(',');
  }

  void _whiteFixedParameter({required StringBuffer buffer, required DetectedMethodParameter fixed}) {
    buffer.writeln('\t\t\tReflectedFixedParameter(');
    buffer.writeln('\t\t\t\tanotations: const [${fixed.annotations.join(',')}],');
    buffer.writeln('\t\t\t\treflectedType: ReflectedFlexible(externalAnotations: const [${fixed.annotations.join(',')}], manager: manager, realType: ${fixed.typeValue}),');
    buffer.writeln('\t\t\t\tname: \'${fixed.name}\',');
    buffer.writeln('\t\t\t\tindex: ${fixed.position},');
    buffer.writeln('\t\t\t\tisOptional: ${fixed.hasDefaultValue ? 'true' : 'false'},');
    buffer.writeln('\t\t\t\tdefaultValue: ${fixed.hasDefaultValue ? fixed.defaultValue : 'null'} ,');

    buffer.writeln('\t\t\t),');
  }

  void _whiteNamedParameter({required StringBuffer buffer, required DetectedMethodParameter named}) {
    buffer.writeln('\t\t\tReflectedNamedParameter(');
    buffer.writeln('\t\t\t\tanotations: const [${named.annotations.join(',')}],');
    buffer.writeln('\t\t\t\treflectedType: ReflectedFlexible(externalAnotations: const [${named.annotations.join(',')}], manager: manager, realType: ${named.typeValue}),');
    buffer.writeln('\t\t\t\tname: \'${named.name}\',');
    buffer.writeln('\t\t\t\tisRequired: ${!named.hasDefaultValue ? 'true' : 'false'},');
    buffer.writeln('\t\t\t\tdefaultValue: ${named.hasDefaultValue ? named.defaultValue : 'null'},');

    buffer.writeln('\t\t\t),');
  }
}

/*
EXAMPLE:
ReflectedMethodInstance<_SuperEntity, String>(
        anotations: anotations,
        name: 'secretMethod',
        isStatic: true,
        methodType: ReflectedMethodType.method,
        fixedParameters: [
          ReflectedFixedParameter(
            anotations: [],
            reflectedType: ReflectedFlexible(externalAnotations: const [], manager: manager, realType: String),
            name: 'personName',
            index: 0,
            isOptional: false,
            defaultValue: null,
          ),
        ],
        namedParameters: [
          ReflectedNamedParameter(
            anotations: const [],
            reflectedType: ReflectedFlexible(externalAnotations: const [], manager: manager, realType: bool),
            name: 'isWelcome',
            isRequired: false,
            defaultValue: false,
          ),
        ],
        reflectedType: ReflectedFlexible(externalAnotations: anotations, manager: manager, realType: String),
        invoker: (instance, parameters) => _SuperEntity.secretMethod(),
      )



 */
