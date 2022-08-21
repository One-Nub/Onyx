import '../enums.dart';
import '../typedefs.dart';
import 'component_base.dart';

class TextInput implements Component {
  final ComponentType type = ComponentType.text_input;
  String customID;
  TextInputStyle style;
  String label;

  int? min_length;
  int? max_length;
  bool requiredField;
  String? defaultValue;
  String? placeholderText;

  TextInput({required this.customID, required this.style, required this.label, this.min_length,
    this.max_length, this.requiredField = true, this.defaultValue, this.placeholderText});

  JsonData toJson() {
    JsonData finalData = {
      "type": type.value,
      "custom_id": customID,
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
