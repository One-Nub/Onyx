import '../enums.dart';
import '../utilities/typedefs.dart';
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
    if (components != null) {
      components.forEach((element) => this.addComponent(element));
    }
  }

  /// Create an Action Row from a json decoded payload as [data].
  ActionRow.fromJson(JsonData data) {
    components = [];
    (data["components"] as List).forEach((element) {
      ComponentType elementType = ComponentType.fromInt(element["type"]);

      if (elementType.isButton) {
        components.add(Button.fromJson(element));
      } else if (elementType.isSelectMenu) {
        components.add(SelectMenu.fromJson(element));
      } else if (elementType.isTextInput) {
        components.add(TextInputResponse.fromJson(element));
      }
    });
  }

  /// Add a [component] to [components]
  void addComponent(Component component) {
    if (components.isNotEmpty && component.type.isSelectMenu) {
      throw StateError("Cannot add a select menu to a non-empty action row.");
    } else if (components.isNotEmpty && component.type.isTextInput) {
      throw StateError("Cannot add text input to a non-empty action row.");
    }

    bool containsSelection = false;
    bool containsTextInput = false;
    components.forEach((element) {
      if (element.type.isSelectMenu) containsSelection = true;
      if (element.type.isTextInput) containsTextInput = true;
    });

    if (containsSelection || containsTextInput) {
      throw StateError("Cannot add more components to an action row with a select menu or text input.");
    }

    if (components.length >= 5) {
      throw StateError("Cannot add more than 5 button components to an action row.");
    }
    components.add(component);
  }

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
