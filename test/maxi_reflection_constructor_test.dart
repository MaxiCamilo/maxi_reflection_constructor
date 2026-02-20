@Timeout(Duration(minutes: 20))
library;

import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection_constructor/maxi_reflection_constructor.dart';
import 'package:maxi_reflection_constructor/src/analyzer/file_analizer.dart';
import 'package:maxi_reflection_constructor/src/analyzer/folder_reflected_file_finder.dart';
import 'package:test/test.dart';

void main() {
  group('Test builder', () {
    setUp(() async {
    });

    test('Dart File Finder', () async {
      final finder = FolderReflectedFileFinder(
        folderAddress: FolderReference(isLocal: true, name: 'test', router: '..'),
      );

      final findResult = await finder.execute();
      expect(findResult.itsCorrect, true);
    });

    test('Class finder', () async {
      final dartFiles = FolderReflectedFileFinder(
        folderAddress: FolderReference(isLocal: true, name: 'test', router: '..'),
      );

      final dartFilesResult = await dartFiles.execute();
      expect(dartFilesResult.itsCorrect, true);

      for (final file in dartFilesResult.content) {
        final analizerResult = await FileAnalizer(fileName: file.fileReference.name, fileGetter: file.readText).execute();
        expect(analizerResult.itsCorrect, true);
      }
    });

    test('Builder test', () async {
      final builder = ReflectorBuilder(
        prefix: 'test',
        extraImports: const ['../../classes/first.dart'],
        searcher: FolderReflectedFileFinder(
          folderAddress: FolderReference(isLocal: true, name: 'test', router: '..'),
        ),
        destination: FolderReference(isLocal: true, name: 'reflection', router: '../test'),
      );

      final buildResult = await builder.execute();
      expect(buildResult.itsCorrect, true);
    });
  });
}
