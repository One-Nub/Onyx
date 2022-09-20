/// Metadata that can be assigned on an object.
///
/// Used for objects where information may need to be passed along the object, without the need
/// for specifically defining these methods in the class.
///
/// In Onyx, this is only utilized to enable the linking of additional data, like a HttpRequest, to
/// an Interaction so it can be utilized later within the handling method(s).
mixin Metadata {
  dynamic _privMetadata;

  dynamic get metadata => _privMetadata;

  /// Sets the metadata to [obj].
  void setMetadata(dynamic obj) => this._privMetadata = obj;
}
