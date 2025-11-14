import 'dart:async';

import 'package:maxi_framework/maxi_framework.dart';

class FolderReflectedFileFinder with FunctionalityMixin<List<FileOperator>> {
  final FolderReference folderAddress;

  const FolderReflectedFileFinder({required this.folderAddress});

  @override
  Future<Result<List<FileOperator>>> runFuncionality() async {
    final folderInstance = ApplicationManager.singleton.buildFolderOperator(folderAddress);
    final fileList = <FileOperator>[];

    await for (final file in folderInstance.obtainFiles().where((file) => file.nameExtension == 'dart')) {
      final fileOperator = ApplicationManager.singleton.buildFileOperator(file);
      fileList.add(fileOperator);
    }

    return ResultValue(content: fileList);
  }
}
