import 'package:analyzer/dart/ast/ast.dart';
import 'package:maxi_framework/maxi_framework.dart';

class DetectedAnnotation {
  final String data;

  const DetectedAnnotation({required this.data});

  factory DetectedAnnotation.fromAnalizer({required Annotation anotation}) {
    return DetectedAnnotation(data: anotation.toString().extractFrom(since: 1));
  }

  @override
  String toString() => data;
}
