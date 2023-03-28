import 'package:flutter/material.dart';

class RatingWidget extends StatefulWidget {
  final double initialRating;

  final Function(double) onRatingChanged;

  const RatingWidget({Key? key, this.initialRating = 0, required this.onRatingChanged}) : super(key: key);

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double _rating = 0;

  var _color = Colors.orange;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  void _updateRating(double newPosition) {
    setState(() {
      _rating = newPosition / 34.0;
      if (_rating > 5.0) {
        _rating = 5.0;
      } else if (_rating < 0.0) {
        _rating = 0.0;
      }
      // 将评分四舍五入到最近的 0.5 分
      _rating = (_rating * 2).roundToDouble() / 2;
    });
    widget.onRatingChanged(_rating);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            double newPosition = details.localPosition.dx;
            _updateRating(newPosition);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              var currentIndex = index + 1;
              if (currentIndex - 0.5 <= _rating && _rating < currentIndex) {
                return Icon(
                  Icons.star_half,
                  color: _color,
                  size :34.0 ,
                );
              } else if (currentIndex <= _rating) {
                return Icon(
                  Icons.star,
                  color: _color,
                  size :34.0 ,

                );
              } else {
                return Icon(
                  Icons.star_border,
                  color: _color,
                  size :34.0 ,

                );
              }
            }),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Text("$_rating" , style: TextStyle(fontSize: 27,color: _color),)
      ],
    );
  }
}
