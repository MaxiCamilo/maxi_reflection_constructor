import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection_constructor/maxi_reflection_constructor.dart';

class UnreflectiveTypesResult {
  final Set<String> lists;

  const UnreflectiveTypesResult({required this.lists});

  static String getListName(String typeName) => '${typeName.replaceAll('<', '').replaceAll('>', '').firstWithLowercase()}List';

  UnreflectiveTypesResult merge(UnreflectiveTypesResult other) {
    return UnreflectiveTypesResult(lists: {...lists, ...other.lists});
  }
}

class SearchCompatibleUnreflectiveTypes implements SyncFunctionality<UnreflectiveTypesResult> {
  final List<DetectedClass> classList;
  final List<DetectedEnum> enumList;

  const SearchCompatibleUnreflectiveTypes({required this.classList, required this.enumList});

  @override
  Result<UnreflectiveTypesResult> execute() {
    final lists = <String>{};

    for (final detectedClass in classList) {
      for (final field in detectedClass.fields) {
        if (field.typeValue.toString().startsWith('List<')) {
          lists.add(field.typeValue.toString());
        }
      }

      for (final method in detectedClass.methods) {
        if (method.typeReturn.toString().startsWith('List<')) {
          lists.add(method.typeReturn.toString());
        }
        for (final param in method.parameters) {
          if (param.typeValue.toString().startsWith('List<')) {
            lists.add(param.typeValue.toString());
          }
        }
      }
    }

    return ResultValue(content: UnreflectiveTypesResult(lists: lists));
  }
}
