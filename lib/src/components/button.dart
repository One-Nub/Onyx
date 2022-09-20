import '../enums.dart';
import '../typedefs.dart';
import 'component_base.dart';

/// Represents a button component.
///
/// https://discord.com/developers/docs/interactions/message-components#buttons
class Button implements Component {
  /// The component type.
  final ComponentType type = ComponentType.button;

  /// The [ButtonStyle] for this button.
  late ButtonStyle style;

  /// Text that will appear on this button.
  ///
  /// Limited to 80 characters at most.
  String? label;

  /// A partial emoji that will show on this button.
  ///
  /// Partial emojis consist of `name`, `id`, and the `animated` fields.
  /// https://discord.com/developers/docs/resources/emoji#emoji-resource
  JsonData? emoji;

  /// Developer defined identifier for this button.
  ///
  /// Limited to 100 characters at most.
  String? custom_id;

  /// For [ButtonStyle.link] buttons, the URL that the user will be redirected to.
  String? url;

  /// Whether the button is disabled or not.
  late bool disabled;

  /// Create a button following a [style].
  ///
  /// A [custom_id] is required for all styles except for a link button, in which case a [url] is
  /// required.
  Button({required this.style, this.label, this.emoji, this.custom_id, this.url, this.disabled = false});

  Button.fromJson(JsonData data) {
    style = ButtonStyle.fromInt(data["style"]);
    label = data["label"];
    emoji = data["emoji"];
    custom_id = data["custom_id"];
    url = data["url"];

    if (data["disabled"] == null) {
      disabled = false;
    } else {
      disabled = data["disabled"];
    }
  }

  JsonData toJson() {
    JsonData finalData = {"type": type.value, "style": style.value, "disabled": disabled};

    if (label != null) finalData["label"] = label;

    if (emoji != null) finalData["emoji"] = emoji;

    if (custom_id != null) finalData["custom_id"] = custom_id;

    if (url != null) finalData["url"] = url;

    return finalData;
  }

  @override
  String toString() {
    return "${toJson()}";
  }
}
