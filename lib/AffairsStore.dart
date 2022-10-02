class Affair {
  Affair(this.title, this.time, this.period, this.summary, this.description) {}
  String title;
  DateTime time;
  Duration period;
  String summary;
  String description;
}

class AffairsStore {
  static final List<Affair> _affairs = [];
  static final AffairsStore _cache = AffairsStore._internal();

  factory AffairsStore() {
    return _cache;
  }

  AffairsStore._internal();
  add(Affair affair) => _affairs.add(affair);
  Affair get(int idx) => _affairs[idx];
  void set(int idx, Affair a) => _affairs[idx] = a;
  int get length => _affairs.length;
  void removeAt(int idx) => _affairs.removeAt(idx);
}
