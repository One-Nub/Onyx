/// Metadata that can be assigned on an object.
///
/// Used for objects where information may need to be passed along the object, without the need
/// for specifically defining these methods in the class.
mixin Metadata {
  dynamic _privMetadata;

  dynamic get metadata => _privMetadata;

  /// Sets the metdata to [obj].
  void setMetadata(dynamic obj) => this._privMetadata = obj;
}
