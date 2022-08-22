import '../enums.dart';
import '../typedefs.dart';
import 'component_base.dart';

class Button implements Component {
  final ComponentType type = ComponentType.button;
  final ButtonStyle style;

  String? label;
  JsonData? emoji;
  String? custom_id;
  String? url;
  bool disabled;

  /// Create a button following a [style].
  /// 
  /// A [customID] is required for all styles except for a link button, in which case a [url] is
  /// required. 
  Button({required this.style, this.label, this.emoji, this.custom_id, this.url, this.disabled = false});

  JsonData toJson() {
    JsonData finalData = {"type": type.value, "disabled": disabled};
    
    if(label != null) finalData["label"] = label;

    if(emoji != null) finalData["emoji"] = emoji;

    if(custom_id != null) finalData["custom_id"] = custom_id;

    if(url != null) finalData["url"] = url;

    return finalData;
  }
}
