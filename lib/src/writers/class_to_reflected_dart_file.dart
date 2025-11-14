import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection_constructor/maxi_reflection_constructor.dart';
import 'package:maxi_reflection_constructor/src/writers/field_to_reflected_dart_file.dart';
import 'package:maxi_reflection_constructor/src/writers/method_to_reflected_dart_file.dart';

class ClassToReflectedDartFile implements SyncFunctionality<(String, String)> {
  final DetectedClass processedClass;
  final String prefix;

  const ClassToReflectedDartFile({required this.processedClass, required this.prefix});

  @override
  Result<(String, String)> execute() {
    final reflectorClassName = '${processedClass.name}Reflector';
    final buffer = StringBuffer('//[CLASS] ${processedClass.name}\n');
    buffer.writeln('class $reflectorClassName extends ReflectedClassImplementation<${processedClass.name}>{');
    DetectedMethod? baseConstructor = processedClass.methods.selectItem((x) => x.type == DetectedMethodType.buildMethod && x.parameters.isEmpty);

    final methods = processedClass.methods.map((x) => MethodToReflectedDartFile(parentClass: processedClass, processedMethod: x).execute()).toList();
    final fields = processedClass.fields.map((x) => FieldToReflectedDartFile(parentClass: processedClass, processedField: x).execute()).toList(growable: false);

    if (baseConstructor == null && !processedClass.methods.any((x) => x.type == DetectedMethodType.buildMethod) && processedClass.isAbstract == false && processedClass.isMixin == false) {
      final newConstructor = DetectedMethod(name: processedClass.name, typeReturn: processedClass.name, type: DetectedMethodType.buildMethod, isStatic: true, isConst: false, annotations: [], parameters: []);

      methods.add(MethodToReflectedDartFile(parentClass: processedClass, processedMethod: newConstructor).execute());
      baseConstructor = newConstructor;
    }

    

    buffer.writeln('\t$reflectorClassName({');
    buffer.writeln('\t\trequired super.manager,');
    buffer.writeln('\t\tsuper.hasBaseConstructor =  ${baseConstructor != null ? 'true' : 'false'},');
    buffer.writeln('\t\tsuper.anotations = const [${processedClass.annotations.join(',')}],');
    buffer.writeln('\t\tsuper.extendsType${processedClass.baseClass.isEmpty ? '' : ' = ${processedClass.baseClass}'},');
    buffer.writeln('\t\tsuper.isConstClass =  ${baseConstructor != null && baseConstructor.isConst ? 'true' : 'false'},');
    buffer.writeln('\t\tsuper.isInterface =  ${processedClass.isMixin || processedClass.isAbstract ? 'true' : 'false'},');
    buffer.writeln('\t\tsuper.packagePrefix = \'$prefix\',');
    buffer.writeln('\t\tsuper.traits = const [${processedClass.classThatImplement.join(',')}],');
    buffer.writeln('\t\tsuper.typeName = \'${processedClass.name}\',');
    buffer.writeln('\t});');

    buffer.writeln('\t@override\n\tResult createNewInstance({ReflectionManager? manager}) {');
    if (baseConstructor == null) {
      buffer.writeln('\t\treturn ReflectedClass.buildInterfaceClassErrorResult(\'${processedClass.name}\').cast();');
    } else {
      buffer.writeln('\t\treturn ResultValue(content: ${baseConstructor.isConst ? 'const ' : ''}${processedClass.name}());');
    }
    buffer.writeln('\t}');

    buffer.writeln('\t@override\n\tList<ReflectedField> buildNativeFields({required ReflectionManager manager}) {');
    buffer.writeln('\t\treturn [');
    buffer.writeln('\t\t\t${fields.map((x) => '${x.content.$1}(manager)').join(',')}');
    buffer.writeln('\t\t];');
    buffer.writeln('\t}');

    buffer.writeln('\t@override\n\tList<ReflectedMethod> buildNativeMethods({required ReflectionManager manager}){');
    buffer.writeln('\t\treturn [');
    buffer.writeln('\t\t\t${methods.map((x) => '${x.content.$1}(manager)').join(',')}');
    buffer.writeln('\t\t];');
    buffer.writeln('\t}');

    buffer.writeln('}');

    fields.lambda((x) => buffer.writeln(x.content.$2));
    methods.lambda((x) => buffer.writeln(x.content.$2));

    buffer.writeln('/////////////////////////////////////////////////////////////////////////////////////////');

    return ResultValue(content: (reflectorClassName, buffer.toString()));
  }
}

/*
EXAMPLE:
class _SuperEntityReflector extends ReflectedClassImplementation<_SuperEntity> {
  _SuperEntityReflector({
    required super.manager,
    super.hasBaseConstructor = true,
    super.anotations = const [],
    super.extendsType,
    super.isConstClass = false,
    super.isInterface = false,
    super.packagePrefix = 'super',
    super.traits = const [],
    super.typeName = '_SuperEntity',
  });

  @override
  Result createNewInstance({ReflectionManager? manager}) {
    return ResultValue(content: _SuperEntity());
  }

  @override
  List<ReflectedField> buildNativeFields({required ReflectionManager manager}) {
    return [
    ];
  }

  @override
  List<ReflectedMethod> buildNativeMethods({required ReflectionManager manager}) {
    return [
    ];
  }
}

*/
