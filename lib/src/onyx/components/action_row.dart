import '../enums.dart';
import '../typedefs.dart';
import 'component_base.dart';

class ActionRow implements Component {
  final ComponentType type = ComponentType.action_row;
  ComponentList components = [];

  ActionRow({ComponentList? components}) {
    this.components = [...?components];
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
}
