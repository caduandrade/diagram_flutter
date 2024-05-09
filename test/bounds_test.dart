import 'package:diagram/src/bounds.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Bounds', () {
    test('Constructor', () {
      Bounds bounds = Bounds(left: 1, top: 5, width: 10, height: 100);
      expect(bounds.left, 1);
      expect(bounds.top, 5);
      expect(bounds.right, 11);
      expect(bounds.bottom, 105);
      expect(bounds.width, 10);
      expect(bounds.height, 100);
    });

    test('Expand', () {
      Bounds bounds1 = Bounds(left: 1, top: 5, width: 10, height: 100);
      Bounds bounds2 = Bounds(left: 2, top: 6, width: 22, height: 230);
      Bounds bounds3 = bounds1.expandToInclude(bounds2);
      expect(bounds3.left, 1);
      expect(bounds3.top, 5);
      expect(bounds3.right, 24);
      expect(bounds3.bottom, 236);
      expect(bounds3.width, 23);
      expect(bounds3.height, 231);

      Bounds bounds4 = Bounds(left: 0, top: 0, width: 24, height: 236);
      Bounds bounds5 = bounds3.expandToInclude(bounds4);

      expect(bounds5.left, 0);
      expect(bounds5.top, 0);
      expect(bounds5.right, 24);
      expect(bounds5.bottom, 236);
      expect(bounds5.width, 24);
      expect(bounds5.height, 236);
    });
  });
}
