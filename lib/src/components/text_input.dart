import '../enums.dart';
import '../typedefs.dart';
import 'component_base.dart';

class TextInput implements Component {
  final ComponentType type = ComponentType.text_input;
  late String custom_id;
  late TextInputStyle style;
  late String label;

  int? min_length;
  int? max_length;
  late bool requiredField;
  String? defaultValue;
  String? placeholderText;

  TextInput({required this.custom_id, required this.style, required this.label, this.min_length,
    this.max_length, this.requiredField = true, this.defaultValue, this.placeholderText});

  TextInput.fromJson(JsonData data) {
    custom_id = data["custom_id"];
    style = TextInputStyle.fromInt(data["style"]);
    label = data["label"];
    min_length = data["min_length"];
    max_length = data["max_length"];

    if(data["required"] == null) {
      requiredField = false;
    } else {
      requiredField = data["required"];
    }

    defaultValue = data["value"];
    placeholderText = data["placeholder"];
  }

  JsonData toJson() {
    JsonData finalData = {
      "type": type.value,
      "custom_id": custom_id,
      "style": style.value,
      "label": label,
      "required": requiredField
    };

    if(min_length != null) finalData["min_length"] = min_length;

    if(max_length != null) finalData["max_length"] = max_length;

    if(defaultValue != null) finalData["value"] = defaultValue;

    if(placeholderText != null) finalData["placeholder"] = placeholderText;

    return finalData;
  }
}
