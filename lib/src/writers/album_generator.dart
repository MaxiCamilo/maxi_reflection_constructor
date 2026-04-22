import 'dart:async';

import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection_constructor/src/writers/file_reflector_writter.dart';

class AlbumGenerator with FunctionalityMixin<void> {
  final List<FileReflectorWritterResult> files;
  final String prefix;
  final FolderReference folderDestination;
  final String folderClassAddress;

  final Iterable<String> extraImports;

  const AlbumGenerator({required this.files, required this.prefix, required this.folderDestination, required this.folderClassAddress, required this.extraImports});

  @override
  Future<Result<void>> runInternalFuncionality() async {
    final buffer = StringBuffer('import \'package:maxi_reflection/maxi_reflection.dart\';\n');
    buffer.writeln('import \'generated/unreflective_types.g.dart\';\n');

    for (final imp in files) {
      buffer.writeln('import \'${imp.importAddress}\';');
    }
    /*
    buffer.writeln('');

    for (final imp in extraImports) {
      buffer.writeln('import \'$imp\';');
    }*/

    buffer.writeln('');

    final className = '${prefix}Reflectors'.firstWithUppercase();

    buffer.writeln('class $className implements ReflectionBook{');
    buffer.writeln('\tconst $className();');

    buffer.writeln('\t@override\n\tString get prefixName => \'$prefix\';');

    buffer.writeln('\t@override\n\tList<ReflectedEnum> buildEnums({required ReflectionManager manager}) => const [${files.expand((x) => x.enumNames).join(',')}];');

    buffer.writeln('\t@override\n\tList<ReflectedClass> buildClassReflectors({required ReflectionManager manager}) {');
    buffer.writeln('\t\treturn [');

    buffer.writeln('\t\t\t ${files.expand((x) => x.classNames).map((x) => '$x(manager: manager)').join(',')}');

    buffer.writeln('\t\t];');
    buffer.writeln('\t}');

    buffer.writeln('\t@override\n\tList<ReflectedType> buildOtherReflectors({required ReflectionManager manager}) => unreflectiveTypesList;');

    buffer.writeln('}');

    final fileName = '$prefix.reflection.dart';
    final fileOperator = FileReference.fromFolder(folder: folderDestination, name: fileName).buildOperator();

    final writeFileResult = await fileOperator.writeText(content: buffer.toString());
    if (writeFileResult.itsFailure) return writeFileResult.cast();

    return voidResult;
  }
}

/*
class _SuperBook implements ReflectionBook {
  const _SuperBook();

  @override
  String get prefixName => 'super';

  @override
  List<ReflectedEnum> buildEnums({required ReflectionManager manager}) {
    return const [_superEnum];
  }

  @override
  List<ReflectedClass> buildClassReflectors({required ReflectionManager manager}) {
    return [_SuperEntityReflector(manager: manager)];
  }

  @override
  List<ReflectedType> buildOtherReflectors({required ReflectionManager manager}) {
    return [];
  }
}
*/
