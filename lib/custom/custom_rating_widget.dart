import 'package:flutter/material.dart';

class SponRatingWidget extends StatefulWidget {
  /// star number
  final int count;

  /// Max score
  final double maxRating;

  /// Current score value
  final double value;

  /// Star size
  final double size;

  /// Space between the stars
  final double padding;

  /// Whether the score can be modified by sliding
  final bool selectAble;

  /// Callbacks when ratings change
  final ValueChanged<String> onRatingUpdate;

  SponRatingWidget(
      {
        Key? key,
        this.maxRating = 10.0,
      this.count = 5,
      this.value = 5.0,
      this.size = 20,
      this.padding = 5,
      this.selectAble = false,
        required this.onRatingUpdate});

  @override
  _SponRatingWidgetState createState() => _SponRatingWidgetState();
}

class _SponRatingWidgetState extends State<SponRatingWidget> {
  late double value;

  var _solidStar;
  var _hollowStar;

  @override
  void initState() {
    super.initState();
    value = widget.value;
    _solidStar = Icon(Icons.star ,size: widget.size, color: Colors.orange,);
    _hollowStar = Icon(Icons.star_border , size: widget.size, color: Colors.orange,);
  }


  @override
  void didUpdateWidget(covariant SponRatingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.value != oldWidget.value) {
    //   setState(() {
    //     value = widget.value;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Listener(
          child: buildRowRating(),
          onPointerDown: (PointerDownEvent event) {
            double x = event.localPosition.dx;
            if (x < 0) x = 0;
            pointValue(x);
          },
          onPointerMove: (PointerMoveEvent event) {
            double x = event.localPosition.dx;
            if (x < 0) x = 0;
            pointValue(x);
          },
          onPointerUp: (_) {},
          behavior: HitTestBehavior.deferToChild,
        ),

        SizedBox(width: 10,),
        Text('${value.toStringAsFixed(1)}' , style: TextStyle(color: Colors.orange, fontSize: 20),)
      ],
    );
  }

  pointValue(double dx) {
    print('pointValue....$dx');
    if (!widget.selectAble) {
      return;
    }
    if (dx >= widget.size * widget.count + widget.padding * (widget.count - 1)) {
      value = widget.maxRating;
    } else {
      for (double i = 1; i < widget.count + 1; i++) {
        if (dx > widget.size * i + widget.padding * (i - 1) &&
            dx < widget.size * i + widget.padding * i) {
          value = i * (widget.maxRating / widget.count);
          break;
        } else if (dx > widget.size * (i - 1) + widget.padding * (i - 1) &&
            dx < widget.size * i + widget.padding * i) {
          value = (dx - widget.padding * (i - 1)) /
              (widget.size * widget.count) *
              widget.maxRating;
          break;
        }
      }
    }
    setState(() {
      widget.onRatingUpdate(value.toStringAsFixed(1));
    });
  }

  int fullStars() {
    if (value != null) {
      var f = (value / (widget.maxRating / widget.count)).floor();
      print('fullStarts : $f');
      return f;
    }
    return 0;
  }

  double star() {
    if (value != null) {
      if (widget.count / fullStars() == widget.maxRating / value) {
        return 0;
      }
      return (value % (widget.maxRating / widget.count)) /
          (widget.maxRating / widget.count);
    }
    return 0;
  }

  List<Widget> buildRow() {
    int full = fullStars();
    List<Widget> children = [];
    for (int i = 0; i < full; i++) {
      children.add(_solidStar);
      if (i < widget.count - 1) {
        children.add(
          SizedBox(
            width: widget.padding,
          ),
        );
      }
    }
    if (full < widget.count) {
      children.add(ClipRect(
        clipper: MyClipper(rating: star() * widget.size),
        child: _solidStar,
      ));
    }

    return children;
  }

  List<Widget> buildNormalRow() {
    List<Widget> children = [];
    for (int i = 0; i < widget.count; i++) {
      children.add(_hollowStar);
      if (i < widget.count - 1) {
        children.add(SizedBox(
          width: widget.padding,
        ));
      }
    }
    return children;
  }

  Widget buildRowRating() {
    return Container(
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: buildNormalRow(),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: buildRow(),
          )
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Rect> {
  final double rating;
  MyClipper({required this.rating}) : assert(rating != null);
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0.0, 0.0, rating, size.height);
  }

  @override
  bool shouldReclip(MyClipper oldClipper) {
    return rating != oldClipper.rating;
  }
}
