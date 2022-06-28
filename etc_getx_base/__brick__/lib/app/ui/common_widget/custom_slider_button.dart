import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

enum SlidableButtonPosition {
  left,
  right,
  sliding,
}

class CustomSliderButton extends StatefulWidget {
  final Widget label;
  final Widget child;
  final Color disabledColor;
  final Color buttonColor;
  final Color color;
  final BoxBorder border;
  final BorderRadius borderRadius;
  final double height;
  final double width;
  final double buttonWidth;
  final bool dismissible;
  final SlidableButtonPosition initialPosition;
  final double completeSlideAt;
  final ValueChanged<SlidableButtonPosition> onChanged;
  final AnimationController controller;
  final bool isRestart;
  final bool tristate;

  const CustomSliderButton({
    Key key,
    this.onChanged,
    this.controller,
    this.child,
    this.disabledColor,
    this.buttonColor,
    this.color,
    this.label,
    this.border,
    this.borderRadius = const BorderRadius.all(Radius.circular(60.0)),
    this.initialPosition = SlidableButtonPosition.left,
    this.completeSlideAt = 0.9,
    this.height = 36.0,
    this.width = 120.0,
    this.buttonWidth,
    this.dismissible = true,
    this.isRestart = false,
    this.tristate = false,
  }) : super(key: key);

  @override
  _CustomSliderButtonState createState() => _CustomSliderButtonState();
}

class _CustomSliderButtonState extends State<CustomSliderButton>
    with SingleTickerProviderStateMixin {
  final GlobalKey _containerKey = GlobalKey();
  final GlobalKey _positionedKey = GlobalKey();

  AnimationController _controller;
  Animation<double> _contentAnimation;
  Offset _start = Offset.zero;
  bool _isSliding = false;

  RenderBox get _positioned =>
      _positionedKey.currentContext.findRenderObject() as RenderBox;

  RenderBox get _container =>
      _containerKey.currentContext.findRenderObject() as RenderBox;

  double get _buttonWidth {
    if ((widget.buttonWidth ?? double.minPositive) > widget.width * 3 / 4) {
      return widget.width * 3 / 4;
    }
    if (widget.buttonWidth != null) return widget.buttonWidth;
    return double.minPositive;
  }

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? AnimationController.unbounded(vsync: this);
    _contentAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _initialPositionController();
  }

  void _initialPositionController() {
    if (widget.initialPosition == SlidableButtonPosition.right) {
      _controller.value = 1.0;
    } else {
      _controller.value = 0.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        border: widget.border,
        borderRadius: widget.borderRadius,
      ),
      child: Stack(
        key: _containerKey,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: widget.borderRadius,
            ),
            child: widget.dismissible
                ? ClipRRect(
                    clipper: SlidableButtonClipper(
                      animation: _controller,
                      borderRadius: widget.borderRadius,
                    ),
                    borderRadius: widget.borderRadius,
                    child: SizedBox.expand(
                      child: FadeTransition(
                        opacity: _contentAnimation,
                        child: widget.child,
                      ),
                    ),
                  )
                : SizedBox.expand(child: widget.child),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Align(
              alignment: Alignment((_controller.value * 2.0) - 1.0, 0.0),
              child: child,
            ),
            child: Container(
              key: _positionedKey,
              constraints: BoxConstraints(
                minWidth: widget.height,
                maxWidth: widget.width * 3 / 4,
              ),
              width: _buttonWidth,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                color: widget.onChanged == null ?? widget.disabledColor
                    ? Colors.grey
                    : widget.buttonColor,
              ),
              child: widget.onChanged == null
                  ? Center(child: widget.label)
                  : GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onHorizontalDragStart: _onDragStart,
                      onHorizontalDragUpdate: _onDragUpdate,
                      onHorizontalDragEnd: _onDragEnd,
                      child: Center(child: widget.label),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    final pos = _positioned.globalToLocal(details.globalPosition);
    _start = Offset(pos.dx, 0.0);
    _controller.stop(canceled: true);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final pos = _container.globalToLocal(details.globalPosition) - _start;
    final extent = _container.size.width - _positioned.size.width;
    _controller.value = (pos.dx.clamp(0.0, extent) / extent);

    if (widget.tristate && !_isSliding) {
      _isSliding = true;
      _onChanged(SlidableButtonPosition.sliding);
    }
  }

  void _onDragEnd(DragEndDetails details) {
    final extent = _container.size.width - _positioned.size.width;
    double fractionalVelocity = (details.primaryVelocity / extent).abs();
    if (fractionalVelocity < 0.5) {
      fractionalVelocity = 0.5;
    }

    double acceleration, velocity;
    if (_controller.value >= widget.completeSlideAt) {
      acceleration = 0.5;
      velocity = fractionalVelocity;
    } else {
      acceleration = -0.5;
      velocity = -fractionalVelocity;
    }

    final simulation = SlidableSimulation(
      acceleration,
      _controller.value,
      1.0,
      velocity,
    );

    _controller.animateWith(simulation).whenComplete(() {
      SlidableButtonPosition position = _controller.value == 0
          ? SlidableButtonPosition.left
          : SlidableButtonPosition.right;

      if (widget.isRestart && widget.initialPosition != position) {
        _initialPositionController();
      }

      _isSliding = false;

      _onChanged(position);
    });
  }

  void _onChanged(SlidableButtonPosition position) {
    if (widget.onChanged != null) {
      widget.onChanged(position);
    }
  }
}

class SlidableSimulation extends GravitySimulation {
  SlidableSimulation(
    double acceleration,
    double distance,
    double endDistance,
    double velocity,
  ) : super(acceleration, distance, endDistance, velocity);

  @override
  double x(double time) => super.x(time).clamp(0.0, 1.0);

  @override
  bool isDone(double time) {
    final _x = x(time).abs();
    return _x <= 0.0 || _x >= 1.0;
  }
}

class SlidableButtonClipper extends CustomClipper<RRect> {
  const SlidableButtonClipper({
    this.animation,
    this.borderRadius,
  }) : super(reclip: animation);

  final Animation<double> animation;
  final BorderRadius borderRadius;

  @override
  RRect getClip(Size size) {
    return borderRadius.toRRect(
      Rect.fromLTRB(
        size.width * animation.value,
        0.0,
        size.width,
        size.height,
      ),
    );
  }

  @override
  bool shouldReclip(SlidableButtonClipper oldClipper) => true;
}
