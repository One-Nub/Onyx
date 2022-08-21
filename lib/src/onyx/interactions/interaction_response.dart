import '../enums.dart';
import '../typedefs.dart';

class InteractionResponse {
  /// Callback type of the response.
  InteractionResponseType responseType;

  /// Raw data to be returned. Accepted data structures are outlined at
  /// https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-response-object-interaction-callback-data-structure
  JsonData? data;

  InteractionResponse(this.responseType, this.data);

  /// Return unserialized json representation.
  Map<String, dynamic> toJson() {
    return {
      "type": responseType.value,
      "data": data
    };
  }
}
