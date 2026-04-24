import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection_constructor/src/analyzer/search_compatible_unreflective_types.dart';

class UnreflectiveTypesToDartFile with FunctionalityMixin<void> {
  final FolderReference destinationFolder;
  final UnreflectiveTypesResult unreflectiveTypes;

  final Set<String> otherImports;
  final Iterable<String> extraImports;

  const UnreflectiveTypesToDartFile({required this.destinationFolder, required this.unreflectiveTypes, required this.extraImports, required this.otherImports});

  @override
  FutureResult<void> runInternalFuncionality() async {
    final unreflectiveFile = FileReference.fromFolder(folder: destinationFolder, name: 'unreflective_types.g.dart');

    final names = <String>[];

    final buffer = StringBuffer('//ignore_for_file: unnecessary_const, unnecessary_import, duplicate_import, unused_import\n\n');
    buffer.writeln('import \'package:maxi_reflection_constructor/maxi_reflection_constructor.dart\';');
    buffer.writeln('import \'package:maxi_framework/maxi_framework.dart\';');
    buffer.writeln('import \'package:maxi_reflection/maxi_reflection.dart\';');
    buffer.writeln('import \'package:maxi_reflection/maxi_reflection_ext.dart\';\n');

    for (final imp in extraImports) {
      buffer.writeln('import \'$imp\';');
    }

    for (final imp in otherImports) {
      if (imp.last == ';') {
        buffer.writeln(imp);
      } else {
        buffer.writeln('$imp;');
      }
    }

    buffer.writeln();

    for (final list in unreflectiveTypes.lists) {
      final name = UnreflectiveTypesResult.getListName(list);
      names.add(name);
      final text = 'const $name = ReflectedTypedList<${list.startUpTo(startTo: '<', endTo: '>')}>(anotations: []);';
      buffer.writeln(text);
    }

    buffer.writeln();

    buffer.writeln('const unreflectiveTypesList = <ReflectedType>[${names.join(', ')}];');

    final fileWritter = unreflectiveFile.buildOperator();
    final fileCreationResult = await fileWritter.create();
    if (fileCreationResult.itsFailure) return fileCreationResult.cast();

    final fileWriteResult = await fileWritter.writeText(content: buffer.toString());
    if (fileWriteResult.itsFailure) return fileWriteResult.cast();

    return voidResult;
  }
}
