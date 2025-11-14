import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection/maxi_reflection.dart';

@reflect
enum Michis {
  @FixedOration(message: 'El más lindo <3')
  oreo,
  chichita,
  keroncho,
  takara,
}

@reflect
class First {
  static const int bestNumber = 21;

  static String welcomeMessage(String name) => 'Hello $name!';

  @primaryKey
  int identifier = 0;
  @FixedOration(message: 'Name')
  String name = '';

  bool isCool = false;

  First();

  factory First.createMaxi() => First()
    ..name = 'Maxi'
    ..identifier = 1
    ..isCool = true;

  factory First.completeConstructor(int id, String name, [bool cool = false]) => First()
    ..name = name
    ..identifier = id
    ..isCool = cool;

  factory First.completeNamedConstructor({int id = 0, required String name, bool cool = false}) => First()
    ..name = name
    ..identifier = id
    ..isCool = cool;
}
