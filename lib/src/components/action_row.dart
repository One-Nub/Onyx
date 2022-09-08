import '../enums.dart';
import '../typedefs.dart';
import 'button.dart';
import 'component_base.dart';
import 'select_menu.dart';
import 'text_input.dart';

class ActionRow implements Component {
  final ComponentType type = ComponentType.action_row;
  ComponentList components = [];

  ActionRow({ComponentList? components}) {
    this.components = [...?components];
  }

  ActionRow.fromJson(JsonData data) {
    components = [];
    (data["components"] as List).forEach((element) {
      ComponentType elementType = ComponentType.fromInt(element["type"]);

      if(elementType == ComponentType.button) {
        components.add(Button.fromJson(element));
      } else if (elementType == ComponentType.select_menu) {
        components.add(SelectMenu.fromJson(element));
      } else if (elementType == ComponentType.text_input) {
        components.add(TextInput.fromJson(element));
      }
    });
  }

  void addComponent(Component component) => components.add(component);

  JsonData toJson() {
    List<JsonData> componentList = [];
    components.forEach((element) => componentList.add(element.toJson()));

    return {
      "type": type.value,
      "components": componentList
    };
  }

  @override
  String toString() {
    return "${toJson()}";
  }
}
