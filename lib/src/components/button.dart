import '../enums.dart';
import '../typedefs.dart';
import 'component_base.dart';

class Button implements Component {
  final ComponentType type = ComponentType.button;

  late ButtonStyle style;
  String? label;
  JsonData? emoji;
  String? custom_id;
  String? url;
  late bool disabled;

  /// Create a button following a [style].
  ///
  /// A [customID] is required for all styles except for a link button, in which case a [url] is
  /// required.
  Button({required this.style, this.label, this.emoji, this.custom_id, this.url, this.disabled = false});

  Button.fromJson(JsonData data) {
    style = ButtonStyle.fromInt(data["style"]);
    label = data["label"];
    emoji = data["emoji"];
    custom_id = data["custom_id"];
    url = data["url"];

    if(data["disabled"] == null) {
      disabled = false;
    } else {
      disabled = data["disabled"];
    }
  }

  JsonData toJson() {
    JsonData finalData = {"type": type.value, "style": style.value, "disabled": disabled};

    if(label != null) finalData["label"] = label;

    if(emoji != null) finalData["emoji"] = emoji;

    if(custom_id != null) finalData["custom_id"] = custom_id;

    if(url != null) finalData["url"] = url;

    return finalData;
  }

  @override
  String toString() {
    return "${toJson()}";
  }
}
