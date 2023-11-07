class HelperModel<T> {
  T Function(Map<String, dynamic> map) _fromMap;
  HelperModel(this._fromMap);

  List<T> fromMapArray(dynamic map) {
    List<T> list = [];
    if (map == null) return list;
    map.forEach((e) {
      list.add(_fromMap(e));
    });

    return list;
  }
}
