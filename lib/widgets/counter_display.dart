import 'package:flutter/material.dart';

/// Widget responsible for displaying the counter number and managing its own animations.
///
/// Isolating this widget ensures that only the text is rebuilt
/// during animations, saving [CounterPage] from unnecessary rebuilds.
class CounterDisplay extends StatefulWidget {
  /// Current counter value to be rendered.
  final int count;

  const CounterDisplay({super.key, required this.count});

  @override
  State<CounterDisplay> createState() => _CounterDisplayState();
}

class _CounterDisplayState extends State<CounterDisplay>
    with TickerProviderStateMixin {
  /// Controller responsible for the growth/shrink animation (+ and -).
  late final AnimationController _scaleController;

  /// Controller responsible for the jump animation (reset).
  late final AnimationController _jumpController;

  /// Defines whether the target scale will be larger (increment) or smaller (decrement).
  double _scaleTarget = 1.08;

  @override
  void initState() {
    super.initState();
    // Initialization of controllers with short durations for a "momentum" effect.
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _jumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  /// Observes changes in the [count] property coming from the parent widget.
  /// Triggers the correct animation depending on the state change.
  @override
  void didUpdateWidget(CounterDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only animates if the value actually changed.
    if (widget.count != oldWidget.count) {
      if (widget.count == 0 && oldWidget.count != 0) {
        _triggerJump(); // Triggers the jump when resetting.
      } else {
        _triggerScale(widget.count > oldWidget.count); // Grows or shrinks.
      }
    }
  }

  /// Executes the back-and-forth cycle of the scale animation.
  ///
  /// Stops any in-progress animation before starting to prevent
  /// overlapping async chains on rapid taps.
  Future<void> _triggerScale(bool isIncrement) async {
    _scaleTarget = isIncrement ? 1.08 : 0.92;
    _scaleController
      ..stop()
      ..reset();
    await _scaleController.forward();

    if (!mounted) return;
    _scaleController.reverse();
  }

  /// Executes the back-and-forth cycle of the jump animation.
  ///
  /// Stops any in-progress animation before starting to prevent
  /// overlapping async chains on rapid taps.
  Future<void> _triggerJump() async {
    _jumpController
      ..stop()
      ..reset();
    await _jumpController.forward();

    if (!mounted) return;
    _jumpController.reverse();
  }

  /// Frees GPU resources by discarding Tickers when unmounting the widget.
  @override
  void dispose() {
    _scaleController.dispose();
    _jumpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The AnimatedBuilder rebuilds only the Transform in sync with the animation frames.
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleController, _jumpController]),
      builder: (context, child) {
        // Interpolates the scale and Y offset based on the current value of the controllers.
        final scale =
            1.0 +
            (_scaleTarget - 1.0) *
                Curves.easeOut.transform(_scaleController.value);
        final offsetY = -20.0 * Curves.easeOut.transform(_jumpController.value);

        return Transform.translate(
          offset: Offset(0.0, offsetY),
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
      // The static Text is passed as a child so it's not rebuilt on every animation frame.
      child: Text(
        '${widget.count}',
        style: const TextStyle(
          fontSize: 120,
          fontWeight: FontWeight.w700,
          letterSpacing: -4,
          color: Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}
