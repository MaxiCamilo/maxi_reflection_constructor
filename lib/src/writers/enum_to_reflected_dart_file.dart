import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection_constructor/maxi_reflection_constructor.dart';

class EnumToReflectedDartFile implements SyncFunctionality<(String, String)> {
  final DetectedEnum processedEnum;

  const EnumToReflectedDartFile({required this.processedEnum});

  @override
  Result<(String, String)> execute() {
    final buffer = StringBuffer();
    final constValueName = '${processedEnum.name}Reflection'.firstWithLowercase();

    buffer.writeln('//[ENUM] ${processedEnum.name}');

    buffer.writeln('const $constValueName = ReflectedEnum(');
    buffer.writeln('\tdartType: ${processedEnum.name},');
    buffer.writeln('\tanotations: [${processedEnum.annotations.join(',')}],');
    buffer.writeln('\toptions: [');

    for (final option in processedEnum.options) {
      buffer.writeln('\t\tReflectedEnumOption(anotations: [${option.annotations.join(',')}], value: ${processedEnum.name}.${option.value}),');
    }

    buffer.writeln('\t],');
    buffer.writeln(');');
    buffer.writeln('/////////////////////////////////////////////////////////////////////////////////////////');

    return ResultValue(content: (constValueName, buffer.toString()));
  }
}

/**
 EXAMPLE:
  const _superEnum = ReflectedEnum(
  anotations: [],
  dartType: _SuperEnum,
  options: [
    ReflectedEnumOption(anotations: [], value: _SuperEnum.first),
    ReflectedEnumOption(anotations: [], value: _SuperEnum.second),
    ReflectedEnumOption(anotations: [], value: _SuperEnum.third),
  ],
);
  
  
 
 */
