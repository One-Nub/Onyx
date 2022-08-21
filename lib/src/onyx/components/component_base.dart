import '../enums.dart';
import '../typedefs.dart';

abstract class Component {
  final ComponentType type;
  
  Component(this.type);

  JsonData toJson();
}