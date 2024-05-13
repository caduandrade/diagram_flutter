import 'package:diagram/src/bounds.dart';
import 'package:diagram/src/debug_notifier.dart';
import 'package:diagram/src/node.dart';
import 'package:diagram/src/controller.dart';
import 'package:diagram/src/translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

@internal
class DiagramViewportLayout extends StatelessWidget {
  const DiagramViewportLayout(
      {super.key,
      required this.controller,
      required this.width,
      required this.height,
      required this.debugNotifier});

  final DiagramController controller;
  final double width;
  final double height;
  final DebugNotifier? debugNotifier;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    Bounds viewportBounds = Bounds(
        left: -controller.translation.x,
        top: -controller.translation.y,
        width: width.toInt(),
        height: height.toInt());
    int visibleCount = 0;
    for (DiagramNode node in controller.nodes) {
      ScaledBounds bounds = node.scaledBounds(controller.scale);
      bool visible = viewportBounds.overlaps(bounds);
      if (visible) {
        visibleCount++;
      }
      children.add(_LayoutChild(
          scaledBounds: bounds,
          visible: visible,
          child: node.build(
              context: context,
              scale: controller.scale,
              viewportWidth: width,
              viewportHeight: height)));
    }
    if (debugNotifier != null) {
      Future.microtask(() => debugNotifier?.visibleNodes = visibleCount);
    }
    return _Layout(translation: controller.translation, children: children);
  }
}

class _LayoutParentData extends ContainerBoxParentData<RenderBox> {
  ScaledBounds? scaledBounds;
  bool? visible;
}

class _LayoutChild extends ParentDataWidget<_LayoutParentData> {
  const _LayoutChild({
    required this.scaledBounds,
    required this.visible,
    required super.child,
  });

  final ScaledBounds scaledBounds;
  final bool visible;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is _LayoutParentData);
    final _LayoutParentData parentData =
        renderObject.parentData! as _LayoutParentData;
    if (parentData.visible != visible ||
        parentData.scaledBounds != scaledBounds) {
      parentData.visible = visible;
      parentData.scaledBounds = scaledBounds;
      final RenderObject? targetParent = renderObject.parent;
      if (targetParent is RenderObject) {
        targetParent.markNeedsLayout();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => _Layout;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Object>('visible', visible));
    properties.add(DiagnosticsProperty<Object>('bounds', scaledBounds));
  }
}

class _Layout extends MultiChildRenderObjectWidget {
  const _Layout({
    required this.translation,
    super.children,
  });

  final Translation translation;

  @override
  _RenderLayout createRenderObject(BuildContext context) {
    return _RenderLayout(translation: translation);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderLayout renderObject) {
    renderObject.translation = translation;
  }
}

class _RenderLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _LayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _LayoutParentData> {
  _RenderLayout({
    List<RenderBox>? children,
    required Translation translation,
  }) : _translation = translation {
    addAll(children);
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _LayoutParentData) {
      child.parentData = _LayoutParentData();
    }
  }

  Translation get translation => _translation;
  Translation _translation;
  set translation(Translation newTranslation) {
    if (_translation == newTranslation) {
      return;
    }
    _translation = newTranslation;
    markNeedsLayout();
  }

  void _visitVisibleChildren(
      void Function(RenderBox child, _LayoutParentData childParentData)
          function) {
    RenderBox? child = firstChild;
    while (child != null) {
      final _LayoutParentData childParentData =
          child.parentData! as _LayoutParentData;
      if (childParentData.visible!) {
        function(child, childParentData);
      }
      child = childParentData.nextSibling;
    }
  }

  @override
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return Size(constraints.maxWidth, constraints.maxHeight);
  }

  @override
  void performLayout() {
    size = Size(constraints.maxWidth, constraints.maxHeight);
    _visitVisibleChildren((child, childParentData) {
      final ScaledBounds bounds = childParentData.scaledBounds!;
      child.layout(
          BoxConstraints.tightFor(
              width: bounds.width.toDouble(), height: bounds.height.toDouble()),
          parentUsesSize: true);
      childParentData.offset = Offset((bounds.left + translation.x).toDouble(),
          (bounds.top + translation.y).toDouble());
    });
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _visitVisibleChildren((child, childParentData) {
      context.paintChild(child, childParentData.offset + offset);
    });
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;
    while (child != null) {
      final _LayoutParentData childParentData =
          child.parentData! as _LayoutParentData;
      if (childParentData.visible!) {
        final bool isHit = result.addWithPaintOffset(
          offset: childParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            assert(transformed == position - childParentData.offset);
            return child!.hitTest(result, position: transformed);
          },
        );
        if (isHit) {
          return true;
        }
      }
      child = childParentData.previousSibling;
    }
    return false;
  }
}
