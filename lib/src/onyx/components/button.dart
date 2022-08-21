import '../enums.dart';
import '../typedefs.dart';
import 'component_base.dart';

class Button implements Component {
  final ComponentType type = ComponentType.button;
  final ButtonStyle style;

  String? label;
  JsonData? emoji;
  String? customID;
  String? url;
  bool disabled;

  /// Create a button following a [style].
  /// 
  /// A [customID] is required for all styles except for a link button, in which case a [url] is
  /// required. 
  Button({required this.style, this.label, this.emoji, this.customID, this.url, this.disabled = false});

  JsonData toJson() {
    JsonData finalData = {"type": type.value, "disabled": disabled};
    
    if(label != null) finalData["label"] = label;

    if(emoji != null) finalData["emoji"] = emoji;

    if(customID != null) finalData["custom_id"] = customID;

    if(url != null) finalData["url"] = url;

    return finalData;
  }
}
