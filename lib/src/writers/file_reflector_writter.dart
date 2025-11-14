import 'dart:async';

import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection_constructor/src/analyzer/file_analizer.dart';
import 'package:maxi_reflection_constructor/src/writers/class_to_reflected_dart_file.dart';
import 'package:maxi_reflection_constructor/src/writers/enum_to_reflected_dart_file.dart';

class FileReflectorWritterResult {
  final String fileName;
  final String importAddress;

  final List<String> classNames;
  final List<String> enumNames;

  const FileReflectorWritterResult({required this.fileName, required this.classNames, required this.enumNames, required this.importAddress});
}

class FileReflectorWritter with FunctionalityMixin<FileReflectorWritterResult?> {
  final FileAnalizerResult analizerContent;
  final FolderReference destinationFolder;
  final String prefix;
  final String initialImportAddress;
  final Iterable<String> extraImports;

  FileReflectorWritter({required this.analizerContent, required this.destinationFolder, required this.prefix, required this.initialImportAddress, required this.extraImports});

  @override
  Future<Result<FileReflectorWritterResult?>> runFuncionality() async {
    if (analizerContent.classList.isEmpty && analizerContent.enumList.isEmpty) return nullResult<FileReflectorWritterResult>();

    final newFileName = '${analizerContent.fileName}.g.dart';
    final fileDirection = FileReference.fromFolder(folder: destinationFolder, name: newFileName);
    final fileWritter = ApplicationManager.singleton.buildFileOperator(fileDirection);

    final fileCreationResult = await fileWritter.create();
    if (fileCreationResult.itsFailure) return fileCreationResult.cast();

    final classNames = <String>[];
    final enumNames = <String>[];

    final buffer = StringBuffer('//ignore_for_file: unnecessary_const, unnecessary_import, duplicate_import, unused_import\n\n');
    buffer.writeln('import \'package:maxi_reflection_constructor/maxi_reflection_constructor.dart\';');
    buffer.writeln('import \'package:maxi_framework/maxi_framework.dart\';');
    buffer.writeln('import \'package:maxi_reflection/maxi_reflection.dart\';');
    buffer.writeln('import \'package:maxi_reflection/maxi_reflection_ext.dart\';\n');

    for (final imp in extraImports) {
      buffer.writeln('import \'$imp\';');
    }

    //buffer.writeln('import \'$packageName:\';');

    for (final imp in analizerContent.imports) {
      if (imp.last == ';') {
        buffer.writeln(imp);
      } else {
        buffer.writeln('$imp;');
      }
    }

    buffer.writeln('\n');

    for (final deteEnum in analizerContent.enumList) {
      final convEnum = EnumToReflectedDartFile(processedEnum: deteEnum).execute();
      if (convEnum.itsFailure) return convEnum.cast();

      enumNames.add(convEnum.content.$1);
      buffer.writeln(convEnum.content.$2);
    }

    buffer.writeln('\n');

    for (final deteClass in analizerContent.classList) {
      final convClass = ClassToReflectedDartFile(processedClass: deteClass, prefix: prefix).execute();
      if (convClass.itsFailure) return convClass.cast();

      classNames.add(convClass.content.$1);
      buffer.writeln(convClass.content.$2);
    }

    final fileWritingResult = await fileWritter.writeText(content: buffer.toString());
    if (fileWritingResult.itsFailure) return fileWritingResult.cast();

    return ResultValue(
      content: FileReflectorWritterResult(fileName: newFileName, classNames: classNames, enumNames: enumNames, importAddress: '$initialImportAddress/$newFileName'),
    );
  }
}
