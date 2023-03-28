import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ratingbar/render_box/rich_score/render_rich_score.dart';

import '../base/score.dart';

class RichScore extends MultiChildRenderObjectWidget {
  RichScore({
    Key? key,
    required double score,
    required ScoreCallback callback,
  }) : super(
    key: key,
    children: [
      Score(score: score, callback: callback,),
      Text('$score', style: TextStyle(fontSize: 28 , color: Colors.orange)),
    ]
  );

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderRichScore(children: []);
  }
}