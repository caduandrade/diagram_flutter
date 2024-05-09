class Translation {
  Translation([this.x = 0, this.y = 0]);

  int x = 0;
  int y = 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Translation &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() {
    return 'Translation{x: $x, y: $y}';
  }
}
