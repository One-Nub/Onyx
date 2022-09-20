import '../enums.dart';
import '../typedefs.dart';
import 'component_base.dart';

/// A Text Input component, utilized for Modals.
///
/// https://discord.com/developers/docs/interactions/message-components#text-inputs
class TextInput implements Component {
  /// The component type.
  final ComponentType type = ComponentType.text_input;

  /// Developer defined identifier for this input field.
  ///
  /// Limited to 100 characters at most.
  late String custom_id;

  /// The style of input that this text input field will show up as.
  late TextInputStyle style;

  /// The label for the input field.
  ///
  /// Limited to 45 characters at most.
  late String label;

  /// The minimum number of characters allowed for this text input.
  ///
  /// Minimum of 0, maximum of 4000.
  int? min_length;

  /// The maximum number of characters allowed for this text input.
  ///
  /// Minimum of 1, maximum of 4000.
  int? max_length;

  /// Make it so that this text input field is required, true by default.
  late bool requiredField;

  /// A pre-filled value for this input field.
  ///
  /// Limited to 4000 characters at most.
  String? defaultValue;

  /// Placeholder text that will show up if there is no user input.
  ///
  /// Limited to 100 characters at most.
  String? placeholderText;

  TextInput(
      {required this.custom_id,
      required this.style,
      required this.label,
      this.min_length,
      this.max_length,
      this.requiredField = true,
      this.defaultValue,
      this.placeholderText});

  TextInput.fromJson(JsonData data) {
    custom_id = data["custom_id"];
    style = TextInputStyle.fromInt(data["style"]);
    label = data["label"];
    min_length = data["min_length"];
    max_length = data["max_length"];

    if (data["required"] == null) {
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

    if (min_length != null) finalData["min_length"] = min_length;

    if (max_length != null) finalData["max_length"] = max_length;

    if (defaultValue != null) finalData["value"] = defaultValue;

    if (placeholderText != null) finalData["placeholder"] = placeholderText;

    return finalData;
  }

  @override
  String toString() {
    return "${toJson()}";
  }
}
