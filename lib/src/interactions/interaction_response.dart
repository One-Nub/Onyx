import '../enums.dart';
import '../typedefs.dart';

/// Used to create a response to an interaction.
class InteractionResponse {
  /// Callback type of the response.
  InteractionResponseType responseType;

  /// Response data to be returned to Discord.
  ///
  /// Accepted data structures are outlined at
  /// https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-response-object-interaction-callback-data-structure
  JsonData? data;

  InteractionResponse(this.responseType, this.data);

  /// Return a deserialized json representation of the response.
  Map<String, dynamic> toJson() {
    return {"type": responseType.value, "data": data};
  }
}
