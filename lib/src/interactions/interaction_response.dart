class InteractionResponse {
  /// Callback type of the response.
  InteractionResponseType responseType;

  /// Raw data to be returned. Accepted data structures are outlined at
  /// https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-response-object-interaction-callback-data-structure
  Map<String, dynamic>? data;

  InteractionResponse(this.responseType, this.data);

  /// Return unserialized json representation.
  Map<String, dynamic> toJson() {
    return {
      "type": responseType.value,
      "data": data
    };
  }
}

enum InteractionResponseType {
  /// Respond with a message.
  message,

  /// User sees a loading screen, respond with a message later.
  deferredMessage,

  /// Only works with components, edit the original message later. No loading state.
  deferredUpdateMessage,

  /// Only works with components, edit the original message.
  updateMessage,

  /// Respond to an autocomplete interaction.
  autocomplete,

  /// Respond with a popup modal. Does not work with MODAL_SUBMIT and PING interactions.
  modal
}

extension ResponseValues on InteractionResponseType {
  /// Get the associated integer value with an interaction callback type.
  int get value {
    switch (this) {
      case InteractionResponseType.message:
        return 4;
      case InteractionResponseType.deferredMessage:
        return 5;
      case InteractionResponseType.deferredUpdateMessage:
        return 6;
      case InteractionResponseType.updateMessage:
        return 7;
      case InteractionResponseType.autocomplete:
        return 8;
      case InteractionResponseType.modal:
        return 9;
    }
  }

  /// Return type with assigned value.
  int from(int value) => value;
}
