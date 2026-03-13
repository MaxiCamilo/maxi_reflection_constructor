import 'dart:async';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection_constructor/maxi_reflection_constructor.dart';

class FileAnalizerResult {
  final String fileName;
  final Set<String> imports;
  final List<DetectedClass> classList;
  final List<DetectedEnum> enumList;

  const FileAnalizerResult({required this.fileName, required this.imports, required this.classList, required this.enumList});
}

class FileAnalizer with FunctionalityMixin<FileAnalizerResult?> {
  final String fileName;
  final FutureOr<Result<String>> Function() fileGetter;

  const FileAnalizer({required this.fileName, required this.fileGetter});

  @override
  Future<Result<FileAnalizerResult?>> runInternalFuncionality() async {
    final fileGetterResult = await fileGetter().connect();
    if (fileGetterResult.itsFailure) return fileGetterResult.cast();

    final fileContent = fileGetterResult.content;

    if (fileContent.startsWith('@ignoreFileForReflection')) {
      return nullResult<FileAnalizerResult>();
    }

    final parceResult = volatileFunction<ParseStringResult>(
      error: (ex, st) => NegativeResult.controller(
        code: ErrorCode.invalidValue,
        message: FlexibleOration(message: 'The dart file is not a valid: %1', textParts: [ex]),
      ),
      function: () => parseString(content: fileContent, throwIfDiagnostics: true),
    );

    if (parceResult.itsFailure) return parceResult.cast();

    final unit = parceResult.content.unit;
    final visitor = _ReflectVisitor();

    final checkVisitException = volatileFunction(
      error: (ex, st) => NegativeResult.controller(
        code: ErrorCode.exception,
        message: FlexibleOration(message: 'An error occurred while parsing file %1: %2', textParts: [ex]),
      ),
      function: () => unit.visitChildren(visitor),
    );

    if (checkVisitException.itsFailure) return checkVisitException.cast();

    return ResultValue(
      content: FileAnalizerResult(fileName: fileName, classList: visitor.classList, enumList: visitor.enumList, imports: visitor.imports),
    );
  }
}

class _ReflectVisitor extends GeneralizingAstVisitor<void> {
  final imports = <String>{};
  final classList = <DetectedClass>[];
  final enumList = <DetectedEnum>[];

  @override
  void visitImportDirective(ImportDirective node) {
    imports.add(node.toString());

    super.visitImportDirective(node);
  }

  @override
  void visitMixinDeclaration(MixinDeclaration node) {
    if (node.metadata.any((annotation) => annotation.name.name == 'reflect')) {
      final classResult = DetectedClass.fromMixinAnalizer(declaration: node);
      if (classResult.itsFailure) throw classResult.error;
      if (!classResult.content.isPrivate) {
        classList.add(classResult.content);
      }
    }

    super.visitMixinDeclaration(node);
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (node.metadata.any((annotation) => annotation.name.name == 'reflect')) {
      final classResult = DetectedClass.fromClassAnalizer(declaration: node);
      if (classResult.itsFailure) throw classResult.error;
      if (!classResult.content.isPrivate) {
        classList.add(classResult.content);
      }
    }

    super.visitClassDeclaration(node);
  }

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    if (node.metadata.any((annotation) => annotation.name.name == 'reflect')) {
      final enu = DetectedEnum.fromenumFactory(declaration: node);
      if (!enu.isPrivate) {
        enumList.add(enu);
      }
    }

    super.visitEnumDeclaration(node);
  }
}
