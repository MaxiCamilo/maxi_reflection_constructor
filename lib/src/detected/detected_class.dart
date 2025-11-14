import 'package:analyzer/dart/ast/ast.dart';
import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection_constructor/maxi_reflection_constructor.dart';

class DetectedClass {
  final List<DetectedAnnotation> annotations;
  final String name;
  final String baseClass;
  final List<String> classThatImplement;
  final List<DetectedMethod> methods;
  final List<DetectedField> fields;
  final bool isAbstract;
  final bool isMixin;

  bool get isPrivate => name.first == '_';

  static bool isReflectedClass({required ClassDeclaration declaration}) => declaration.metadata.any((annotation) => annotation.name.name == 'reflect');
  static bool isReflectedMixed({required ClassDeclaration declaration}) => declaration.metadata.any((annotation) => annotation.name.name == 'reflect');

  const DetectedClass({
    required this.annotations,
    required this.name,
    required this.baseClass,
    required this.classThatImplement,
    required this.methods,
    required this.fields,
    required this.isAbstract,
    required this.isMixin,
  });

  static Result<DetectedClass> fromClassAnalizer({required ClassDeclaration declaration}) {
    final fields = <DetectedField>[];
    for (final field in declaration.members.whereType<FieldDeclaration>().expand((field) => field.fields.variables)) {
      final result = DetectedField.fromFieldAnalizer(declaration: field);
      if (result.itsFailure) return result.cast();
      fields.add(result.content);
    }

    return ResultValue(
      content: DetectedClass(
        annotations: declaration.metadata.map((x) => DetectedAnnotation.fromAnalizer(anotation: x)).toList(),
        name: declaration.name.toString(),
        fields: fields,
        methods: [
          ...declaration.members.whereType<MethodDeclaration>().map((x) => DetectedMethod.fromMethodAnalizer(declaration: x)),
          ...declaration.members.whereType<ConstructorDeclaration>().map((x) => DetectedMethod.fromConstructAnalizer(declaration: x)),
        ],
        baseClass: _extractBaseClass(declaration),
        classThatImplement: _getInheritance(declaration.extendsClause, declaration.implementsClause, declaration.withClause, null),
        isAbstract: declaration.abstractKeyword != null,
        isMixin: false,
      ),
    );
  }

  static Result<DetectedClass> fromMixinAnalizer({required MixinDeclaration declaration}) {
    final fields = <DetectedField>[];
    for (final field in declaration.members.whereType<FieldDeclaration>().expand((field) => field.fields.variables)) {
      final result = DetectedField.fromFieldAnalizer(declaration: field);
      if (result.itsFailure) return result.cast();
      fields.add(result.content);
    }

    return ResultValue(
      content: DetectedClass(
        annotations: declaration.metadata.map((x) => DetectedAnnotation.fromAnalizer(anotation: x)).toList(),
        name: declaration.name.toString(),
        fields: fields,
        methods: [
          ...declaration.members.whereType<MethodDeclaration>().map((x) => DetectedMethod.fromMethodAnalizer(declaration: x)),
          ...declaration.members.whereType<ConstructorDeclaration>().map((x) => DetectedMethod.fromConstructAnalizer(declaration: x)),
        ],
        baseClass: '',
        classThatImplement: _getInheritance(null, declaration.implementsClause, null, declaration.onClause),
        isAbstract: true,
        isMixin: true,
      ),
    );
  }

  static List<String> _getInheritance(ExtendsClause? extendsClause, ImplementsClause? implementsClause, WithClause? withClause, MixinOnClause? onClause) {
    final list = <String>[];
    /*
    if (extendsClause != null) {
      list.add(extendsClause.superclass.name2.toString());
    }
    */

    if (implementsClause != null) {
      for (final item in implementsClause.interfaces) {
        list.add(item.name.toString());
      }
    }

    if (withClause != null) {
      for (final item in withClause.mixinTypes) {
        list.add(item.name.toString());
      }
    }

    if (onClause != null) {
      for (final item in onClause.superclassConstraints) {
        list.add(item.name.toString());
      }
    }

    return list;
  }

  static String _extractBaseClass(ClassDeclaration declaration) {
    if (declaration.extendsClause != null) {
      return declaration.extendsClause!.superclass.name.toString();
    } else {
      return '';
    }
  }
}
