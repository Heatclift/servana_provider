import 'package:flutter/material.dart';
import 'transition_container_builder.dart';

/// Add controller with provided transition api, such as [SlideTransition], [ScaleTransition].
class TransitionContainer extends StatefulWidget {
  /// Build transition.
  final TransitionContainerBuilder builder;

  /// Transition duration.
  final Duration? duration;

  /// Control whether the animation should be skipped when widget change.
  final int? data;

  TransitionContainer.scale({
    super.key,
    required Widget child,
    required Curve curve,
    this.duration,
    this.data,
  }) : builder = ScaleBuilder(curve: curve, child: child);

  /// Wrap a widget with flip transition.
  TransitionContainer.flip({
    super.key,
    required Widget bottomChild,
    required Curve curve,
    required double height,
    this.duration,
    this.data,
  }) : builder = FlipBuilder(
          height,
          curve: curve,
          bottomChild: bottomChild,
        );

  @override
  // ignore: library_private_types_in_public_api
  _State createState() {
    return _State();
  }
}

class _State extends State<TransitionContainer> with TickerProviderStateMixin {
  AnimationController? animationController;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    _setAnimation();
  }

  void _setAnimation() {
    final controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 150),
    )..addListener(() => setState(() {}));
    controller.forward();
    animation = widget.builder.animation(controller);
    animationController = controller;
  }

  @override
  void didUpdateWidget(TransitionContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.builder.runtimeType != widget.builder.runtimeType) {
      animationController?.dispose();
      _setAnimation();
    } else {
      if (widget.data == oldWidget.data) {
        return;
      }
      animationController?.reset();
      animationController?.forward();
    }
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.build(animation);
  }
}
