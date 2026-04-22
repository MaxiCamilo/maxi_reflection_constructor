import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection_constructor/src/analyzer/search_compatible_unreflective_types.dart';



class DefineUnreflectiveTypes implements SyncFunctionality<(List<String> names, String code)> {
  final UnreflectiveTypesResult unreflectiveTypes;

  const DefineUnreflectiveTypes({required this.unreflectiveTypes});

  @override
  Result<(List<String> names, String code)> execute() {
    final names = <String>[];
    final buffer = StringBuffer();

    for (final listType in unreflectiveTypes.lists) {
      final name = UnreflectiveTypesResult.getListName(listType);
      final listTypeName = listType.startUpTo(startTo: 'List<', endTo: '>');
      names.add(name);
      buffer.writeln('const $name = ReflectedTypedList<$listTypeName>(anotations: []);');
    }

    return ResultValue<(List<String>, String)>(content: (names, buffer.toString()));
  }
}
