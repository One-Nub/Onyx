import '../enums.dart';
import '../typedefs.dart';
import 'component_base.dart';

class SelectMenu implements Component {
  final ComponentType type = ComponentType.select_menu;
  String custom_id;
  late List<SelectMenuOption> options;

  String? placeholderText;
  int? min_values;
  int? max_values;
  bool disabled;

  SelectMenu({required this.custom_id, List<SelectMenuOption>? options, this.placeholderText,
    this.min_values, this.max_values, this.disabled = false}) {
      if(options != null) {
        this.options = options;
      } else {
        this.options = [];
      }
    }

  void addOption(SelectMenuOption option) => options.add(option);

  JsonData toJson() {
    JsonData finalData = {
      "type": type.value,
      "custom_id": custom_id,
      "disabled": disabled
    };

    List<JsonData> optionsList = [];
    options.forEach((element) => optionsList.add(element.toJson()));
    finalData["options"] = optionsList;

    if(placeholderText != null) finalData["placeholder"] = placeholderText;

    if(min_values != null) finalData["min_values"] = min_values;

    if(max_values != null) finalData["max_values"] = max_values;

    return finalData;
  }
}

class SelectMenuOption {
  String label;
  String value;
  String? description;
  JsonData? emoji;
  bool? defaultSelection;

  SelectMenuOption({required this.label, required this.value, this.description,
    this.emoji, this.defaultSelection});

  JsonData toJson() {
    JsonData finalData = {"label": label, "value": value};

    if(description != null) finalData["description"] = description;

    if(emoji != null) finalData["emoji"] = emoji;

    if(defaultSelection != null) finalData["default"] = defaultSelection;

    return finalData;
  }
}
