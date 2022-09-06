import 'dart:async';

import './interactions/interaction.dart';

class OnyxStreams {
  StreamController<Interaction> componentController = StreamController.broadcast();
  StreamController<Interaction> autocompleteController = StreamController.broadcast();
  StreamController<Interaction> modalController = StreamController.broadcast();

  static late Stream<Interaction> componentStream;
  static late Stream<Interaction> autocompleteStream;
  static late Stream<Interaction> modalStream;

  OnyxStreams() {
    componentStream = componentController.stream;
    autocompleteStream = autocompleteController.stream;
    modalStream = modalController.stream;
  }
}