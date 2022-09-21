import '../enums.dart';
import '../utilities/typedefs.dart';

/// A base component representation.
///
/// https://discord.com/developers/docs/interactions/message-components#what-is-a-component
abstract class Component {
  /// The type of component.
  final ComponentType type;

  Component(this.type);

  JsonData toJson();
}
