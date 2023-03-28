import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ratingbar/render_box/base/score_star.dart';

typedef ScoreCallback = void Function(double score);

class Score extends StatefulWidget {
  final double score;
  final ScoreCallback callback;

  const Score({Key? key, this.score = 0, required this.callback}) : super(key: key);

  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> {

  late double score;

  @override
  void initState() {
    super.initState();

    score = widget.score ?? 0;
  }

  @override
  void didUpdateWidget(Score oldWidget) {
    super.didUpdateWidget(oldWidget);

    score = widget.score ?? 0;
  }

  var _color = Colors.orange;

  @override
  Widget build(BuildContext context) {
    void _changeScore(Offset offset) {
      Size _size = context.size ?? const Size(20, 20);
      double offsetX = min(offset.dx, _size.width);
      offsetX = max(0, offsetX);

      setState(() {
        score = double.parse(((offsetX / _size.width) * 5).toStringAsFixed(1));
      });

      if (widget.callback != null) {
        widget.callback(score);
      }
    }

    return GestureDetector(
      child: ScoreStar(Colors.grey, _color, score),
      onTapDown: (TapDownDetails details) {
        _changeScore(details.localPosition);
      },
      onLongPressMoveUpdate:(LongPressMoveUpdateDetails details) {
        _changeScore(details.localPosition);
      },
    );
  }
}