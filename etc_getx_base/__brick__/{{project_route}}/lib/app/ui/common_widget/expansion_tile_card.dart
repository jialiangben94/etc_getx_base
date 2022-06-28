import 'package:{{project_route}}/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpansionTileCard extends StatefulWidget {
  const ExpansionTileCard({
    Key key,
    this.title,
    this.onExpansionChanged,
    this.child,
    this.trailing,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.initiallyExpanded = false,
    this.bottomPadding = true,
    this.isBottomPaddingChecking = false,
    this.isIconReverse = false,
    this.headerPadding = const EdgeInsets.all(24),
    this.headerBackgroundColor = colorTransparent,
    this.bottomBackgroundColor = colorTransparent,
    this.iconColor = colorBlack,
    this.duration = const Duration(milliseconds: 300),
    this.elevationCurve = Curves.easeOut,
    this.heightFactorCurve = Curves.easeIn,
    this.turnsCurve = Curves.easeIn,
    this.colorCurve = Curves.easeIn,
    this.paddingCurve = Curves.easeIn,
    this.animateTrailing = false,
  })  : assert(initiallyExpanded != null || child == null),
        super(key: key);

  final Widget title;
  final ValueChanged<bool> onExpansionChanged;
  final Widget child;
  final Widget trailing;
  final bool animateTrailing;
  final BorderRadiusGeometry borderRadius;
  final bool initiallyExpanded;

  final bool isIconReverse;
  final bool bottomPadding;
  final bool isBottomPaddingChecking;
  final EdgeInsetsGeometry headerPadding;
  final Color headerBackgroundColor;
  final Color bottomBackgroundColor;
  final Color iconColor;
  final Duration duration;
  final Curve elevationCurve;
  final Curve heightFactorCurve;
  final Curve turnsCurve;
  final Curve colorCurve;
  final Curve paddingCurve;

  @override
  ExpansionTileCardState createState() => ExpansionTileCardState();
}

class ExpansionTileCardState extends State<ExpansionTileCard>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  Animatable<double> _heightFactorTween;
  Animatable<double> _turnsTween;

  AnimationController _controller;
  Animation<double> _iconTurns;
  Animation<double> _heightFactor;

  bool _isExpanded = false;

  double bottomViewPadding = 0;

  @override
  void initState() {
    super.initState();
    _heightFactorTween = CurveTween(curve: widget.heightFactorCurve);
    _turnsTween = CurveTween(curve: widget.turnsCurve);

    _controller = AnimationController(duration: widget.duration, vsync: this);
    _heightFactor = _controller.drive(_heightFactorTween);
    _iconTurns = _controller.drive(_halfTween.chain(_turnsTween));

    _isExpanded = widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
    bottomViewPadding = (Get.mediaQuery.viewPadding.bottom <
            (widget.headerPadding.vertical / 2))
        ? (widget.headerPadding.vertical / 2)
        : Get.mediaQuery.viewPadding.bottom;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setExpansion(bool shouldBeExpanded) {
    if (shouldBeExpanded != _isExpanded) {
      setState(() {
        _isExpanded = shouldBeExpanded;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse().then<void>((void value) {
            if (!mounted) return;
            setState(() {});
          });
        }
      });
      if (widget.onExpansionChanged != null) {
        widget.onExpansionChanged(_isExpanded);
      }
    }
  }

  void expand() {
    _setExpansion(true);
  }

  void collapse() {
    _setExpansion(false);
  }

  void toggleExpansion() {
    _setExpansion(!_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: toggleExpansion,
            child: Container(
              color: widget.headerBackgroundColor,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    widget.headerPadding.horizontal / 2,
                    widget.headerPadding.vertical / 2,
                    widget.headerPadding.horizontal / 2,
                    widget.isBottomPaddingChecking
                        ? (((widget.headerPadding.vertical / 2) *
                                _heightFactor.value) +
                            (bottomViewPadding * (1 - _heightFactor.value)))
                        : (widget.headerPadding.vertical / 2)),
                child: Row(children: [
                  Expanded(child: widget.title),
                  const SizedBox(width: 5),
                  RotationTransition(
                    turns: (widget.trailing == null || widget.animateTrailing)
                        ? _iconTurns
                        : const AlwaysStoppedAnimation(0),
                    child: widget.trailing ??
                        Icon(
                          widget.isIconReverse
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: widget.iconColor,
                        ),
                  ),
                ]),
              ),
            ),
          ),
          ClipRRect(
            child: Container(
              color: widget.bottomBackgroundColor,
              child: Padding(
                padding: EdgeInsets.only(
                  left: widget.bottomPadding ? 24.0 : 0,
                  right: widget.bottomPadding ? 24.0 : 0,
                  bottom: (_isExpanded && widget.bottomPadding) ? 24 : 0,
                ),
                child: Align(
                  heightFactor: _heightFactor.value,
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : widget.child,
    );
  }
}
