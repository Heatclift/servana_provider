import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart' as widget;

class Stack extends widget.Stack {
  /// Create stack instance
  const Stack({
    super.key,
    super.alignment,
    super.textDirection,
    super.fit,
    super.clipBehavior,
    super.children,
  });

  @override
  RenderStack createRenderObject(widget.BuildContext context) {
    return _RenderStack(
      alignment: alignment,
      textDirection: textDirection ?? widget.Directionality.of(context),
      fit: fit,
      clipBehavior: clipBehavior,
    );
  }
}

/// Enable overflow hitTest
class _RenderStack extends RenderStack {
  _RenderStack({
    super.alignment,
    super.textDirection,
    super.fit,
    super.clipBehavior,
  });

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (clipBehavior == Clip.none || size.contains(position)) {
      if (hitTestChildren(result, position: position) || hitTestSelf(position)) {
        result.add(BoxHitTestEntry(this, position));
        return true;
      }
    }
    return false;
  }
}
