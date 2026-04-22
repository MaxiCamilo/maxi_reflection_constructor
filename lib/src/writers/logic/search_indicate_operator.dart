import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection_constructor/src/analyzer/search_compatible_unreflective_types.dart';

class SearchIndicateOperator implements SyncFunctionality<String> {
  final String realType;

  const SearchIndicateOperator({required this.realType});

  @override
  Result<String> execute() {
    if (realType.startsWith('List<')) {
      return UnreflectiveTypesResult.getListName(realType).asResultValue();
    }

    return 'ReflectedFlexible(externalAnotations: annotations, manager: manager, realType: $realType)'.asResultValue();
  }
}
