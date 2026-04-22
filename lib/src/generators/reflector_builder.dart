import 'dart:async';

import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection_constructor/src/analyzer/file_analizer.dart';
import 'package:maxi_reflection_constructor/src/analyzer/folder_reflected_file_finder.dart';
import 'package:maxi_reflection_constructor/src/analyzer/search_compatible_unreflective_types.dart';
import 'package:maxi_reflection_constructor/src/writers/album_generator.dart';
import 'package:maxi_reflection_constructor/src/writers/file_reflector_writter.dart';
import 'package:maxi_reflection_constructor/src/writers/unreflective_types_to_dart_file.dart';

class ReflectorBuilder with FunctionalityMixin<void> {
  final String prefix;
  final Functionality<List<FileOperator>>? searcher;
  final FolderReference? destination;

  final Iterable<String> extraImports;

  const ReflectorBuilder({required this.prefix, this.searcher, this.destination, this.extraImports = const []});

  @override
  Future<Result<void>> runInternalFuncionality() async {
    final projectAddressResult = await FolderReference.workingFolder.buildOperator().obtainCompleteRoute();
    if (projectAddressResult.itsFailure) return projectAddressResult.cast();
    final projectAddress = projectAddressResult.content;
    FolderReference mainFolder = FolderReference.interpretRoute(route: projectAddress, isLocal: false).content;
    if (appManager.isDebug && mainFolder.name == 'debug') {
      mainFolder = mainFolder.obtainFolderLocation().content;
    }

    late final Functionality<List<FileOperator>> realSeacher;
    if (searcher == null) {
      realSeacher = FolderReflectedFileFinder(folderAddress: mainFolder);
    } else {
      realSeacher = searcher!;
    }

    late final FolderReference realDestination;
    if (destination == null) {
      realDestination = FolderReference.pulledFolder(parent: mainFolder, route: 'lib/src/reflection');
    } else {
      realDestination = destination!;
    }

    final generatedFolder = FolderReference.fromAnotherFolder(parent: realDestination, name: 'generated');
    final generatedForlderOperator = generatedFolder.buildOperator();
    final generatedFolderCreation = await generatedForlderOperator.create(createFolderRoute: true);
    if (generatedFolderCreation.itsFailure) return generatedFolderCreation.cast();

    final filesResult = await realSeacher.execute();
    if (filesResult.itsFailure) return filesResult.cast();

    if (filesResult.content.isEmpty) {
      return NegativeResult.controller(
        code: ErrorCode.nonExistent,
        message: FixedOration(message: 'No reflected classes found'),
      );
    }

    final newReflectedFile = <FileReflectorWritterResult>[];
    final otherImports = <String>{};
    UnreflectiveTypesResult unreflectiveTypes = const UnreflectiveTypesResult(lists: {});

    for (final file in filesResult.content) {
      final analizerResult = await FileAnalizer(fileName: file.fileReference.nameWithoutExtension, fileGetter: file.readText).execute();
      if (analizerResult.itsFailure) return analizerResult.cast();
      if (analizerResult.content == null) continue;
      if (analizerResult.content!.classList.isEmpty && analizerResult.content!.enumList.isEmpty) continue;

      otherImports.addAll(analizerResult.content!.imports);

      final fileWritterResult = await FileReflectorWritter(
        prefix: prefix,
        destinationFolder: generatedFolder,
        analizerContent: analizerResult.content!,
        initialImportAddress: 'generated',
        extraImports: ['unreflective_types.g.dart', ...extraImports],
      ).execute();
      if (fileWritterResult.itsFailure) return fileWritterResult.cast();
      if (fileWritterResult.content != null) {
        newReflectedFile.add(fileWritterResult.content!);
        unreflectiveTypes = unreflectiveTypes.merge(analizerResult.content!.unreflectiveTypes);
      }
    }

    final unreflectiveTypesFileResult = await UnreflectiveTypesToDartFile(destinationFolder: generatedFolder, unreflectiveTypes: unreflectiveTypes, extraImports: extraImports, otherImports: otherImports).execute();
    if (unreflectiveTypesFileResult.itsFailure) return unreflectiveTypesFileResult.cast();

    final albumGenerator = AlbumGenerator(files: newReflectedFile, prefix: prefix, folderDestination: realDestination, folderClassAddress: 'generated', extraImports: extraImports);
    final albumGenerationResult = await albumGenerator.execute();
    if (albumGenerationResult.itsFailure) return albumGenerationResult.cast();

    return voidResult;
  }
}
