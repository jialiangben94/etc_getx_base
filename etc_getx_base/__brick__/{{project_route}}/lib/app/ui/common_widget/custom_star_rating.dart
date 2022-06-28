import 'package:{{project_route}}/app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomStarRating extends StatefulWidget {
  final int initialStar;
  final bool enable;
  final double starSize;
  final Function(int) onChanged;
  const CustomStarRating(this.initialStar,
      {this.enable = true, this.starSize = 16, this.onChanged, Key key})
      : super(key: key);

  @override
  State<CustomStarRating> createState() => _CustomStarRatingState();
}

class _CustomStarRatingState extends State<CustomStarRating> {
  int currentStar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentStar = widget.initialStar;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...List.generate(5, (index) => Expanded(child: _starItem(index)))
      ],
    );
  }

  Widget _starItem(int index) {
    return InkWell(
      onTap: () {
        if (widget.enable) {
          if (widget.onChanged != null) widget.onChanged(index);
          setState(() {
            currentStar = index + 1;
          });
        }
      },
      child: Icon(
        (index < currentStar) ? Icons.star : Icons.star_border,
        size: widget.starSize,
        color: colorBlack,
      ),
    );
  }
}
