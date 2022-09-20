import '../enums.dart';
import '../typedefs.dart';
import 'button.dart';
import 'component_base.dart';
import 'select_menu.dart';
import 'text_input.dart';

/// Represents an Action Row component, which holds other Components.
///
/// https://discord.com/developers/docs/interactions/message-components#action-rows
class ActionRow implements Component {
  /// The component type.
  final ComponentType type = ComponentType.action_row;

  /// List containing the components that this ActionRow contains.
  ComponentList components = [];

  /// Create an Action Row with optionally some [components] on creation.
  ActionRow({ComponentList? components}) {
    this.components = [...?components];
  }

  /// Create an Action Row from a json decoded payload as [data].
  ActionRow.fromJson(JsonData data) {
    components = [];
    (data["components"] as List).forEach((element) {
      ComponentType elementType = ComponentType.fromInt(element["type"]);

      if (elementType == ComponentType.button) {
        components.add(Button.fromJson(element));
      } else if (elementType == ComponentType.select_menu) {
        components.add(SelectMenu.fromJson(element));
      } else if (elementType == ComponentType.text_input) {
        components.add(TextInput.fromJson(element));
      }
    });
  }

  /// Add a [component] to [components]
  void addComponent(Component component) => components.add(component);

  JsonData toJson() {
    List<JsonData> componentList = [];
    components.forEach((element) => componentList.add(element.toJson()));

    return {"type": type.value, "components": componentList};
  }

  @override
  String toString() {
    return "${toJson()}";
  }
}
