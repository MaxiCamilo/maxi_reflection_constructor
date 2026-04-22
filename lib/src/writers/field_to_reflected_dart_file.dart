import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection_constructor/maxi_reflection_constructor.dart';
import 'package:maxi_reflection_constructor/src/writers/logic/search_indicate_operator.dart';

class FieldToReflectedDartFile implements SyncFunctionality<(String, String)> {
  final DetectedClass parentClass;
  final DetectedField processedField;

  const FieldToReflectedDartFile({required this.parentClass, required this.processedField});

  //String get _getOptionalInstanceType => processedField.typeValue.last == '?' ? processedField.typeValue : '${processedField.typeValue}?';

  @override
  Result<(String, String)> execute() {
    final buffer = StringBuffer();
    final genericTypes = '<${parentClass.name}, ${processedField.typeValue}>';
    final builerName = '_build${parentClass.name}${processedField.name}Field';

    buffer.writeln('//[FIELD] ${parentClass.name} -> ${processedField.name}');

    buffer.writeln('ReflectedFieldInstance$genericTypes $builerName(ReflectionManager manager){');
    buffer.writeln('\tfinal annotations = const [${processedField.annotations.join(',')}];');
    buffer.writeln('\treturn ReflectedFieldInstance$genericTypes(');

    buffer.writeln('\t\tanotations: annotations,');
    buffer.writeln('\t\tname: \'${processedField.name}\',');
    buffer.writeln('\t\tisStatic: ${processedField.isStatic ? 'true' : 'false'},');
    buffer.writeln('\t\tisFinal: ${processedField.isFinal || processedField.isConst ? 'true' : 'false'},');
    buffer.writeln('\t\tisLate: ${processedField.isLate ? 'true' : 'false'},');

    final searchIndicateOper = SearchIndicateOperator(realType: processedField.typeValue).execute();
    if (searchIndicateOper.itsFailure) {
      return searchIndicateOper.cast();
    }

    buffer.writeln('\t\treflectedType: ${searchIndicateOper.content},');

    buffer.writeln('\t\tgetter: (${parentClass.name}? instance) => ${processedField.isConst || processedField.isStatic ? '${parentClass.name}.${processedField.name}' : 'instance!.${processedField.name}'},');

    if (processedField.isConst) {
      buffer.writeln('\t\tsetter: (${parentClass.name}? instance, ${processedField.typeValue} value) => ReflectedField.constSeterError(\'${processedField.name}\'),');
    } else if (processedField.isFinal && !processedField.isLate) {
      buffer.writeln('\t\tsetter: (${parentClass.name}? instance, ${processedField.typeValue} value) => ReflectedField.finalSeterError(\'${processedField.name}\'),');
    } else if (processedField.isStatic) {
      buffer.writeln('\t\tsetter: (${parentClass.name}? instance, ${processedField.typeValue} value) => ${parentClass.name}.${processedField.name} = value,');
    } else {
      buffer.writeln('\t\tsetter: (${parentClass.name}? instance, ${processedField.typeValue} value) => instance!.${processedField.name} = value,');
    }

    buffer.writeln('\t);');
    buffer.writeln('}');
    buffer.writeln('/////////////////////////////////////////////////////////////////////////////////////////');

    return ResultValue(content: (builerName, buffer.toString()));
  }
}

/*
ReflectedFieldInstance<_SuperEntity, String>(
        anotations: [],
        isFinal: false,
        isLate: false,
        isStatic: true,
        name: 'secretField',
        reflectedType: ReflectedFlexible(externalAnotations: anotations, manager: manager, realType: String),
        setter: (_SuperEntity? instance, String value) => _SuperEntity.secretField = value,
        getter: (_SuperEntity? instance) => _SuperEntity.secretField,
      ),


*/
