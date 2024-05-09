import 'dart:math' as math;

class Bounds {
  Bounds(
      {required this.left,
      required this.top,
      required this.width,
      required this.height}) {
    if (width < 0) {
      throw ArgumentError.value(width, 'width', 'Invalid value');
    }
    if (height < 0) {
      throw ArgumentError.value(height, 'height', 'Invalid value');
    }
  }

  final int left;
  final int top;
  final int width;
  final int height;
  int get right => left + width;
  int get bottom => top + height;

  /// Returns a new rectangle which is the bounding box containing this
  /// rectangle and the given rectangle.
  Bounds expandToInclude(Bounds other) {
    int left = math.min(this.left, other.left);
    int top = math.min(this.top, other.top);
    int right = math.max(this.right, other.right);
    int bottom = math.max(this.bottom, other.bottom);
    return Bounds(
        left: left, top: top, width: right - left, height: bottom - top);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Bounds &&
          runtimeType == other.runtimeType &&
          left == other.left &&
          top == other.top &&
          width == other.width &&
          height == other.height;

  @override
  int get hashCode =>
      left.hashCode ^ top.hashCode ^ width.hashCode ^ height.hashCode;

  @override
  String toString() {
    return 'Bounds{left: $left, top: $top, width: $width, height: $height}';
  }
}

class ScaledBounds extends Bounds {
  factory ScaledBounds({required double scale, required Bounds bounds}) {
    return ScaledBounds._(
        scale: scale,
        left: (bounds.left * scale).toInt(),
        top: (bounds.top * scale).toInt(),
        width: (bounds.width * scale).toInt(),
        height: (bounds.height * scale).toInt());
  }

  ScaledBounds._(
      {required this.scale,
      required super.left,
      required super.top,
      required super.height,
      required super.width});

  final double scale;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ScaledBounds &&
          runtimeType == other.runtimeType &&
          scale == other.scale;

  @override
  int get hashCode => super.hashCode ^ scale.hashCode;
}
