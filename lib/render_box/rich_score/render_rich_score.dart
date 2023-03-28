import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ratingbar/render_box/rich_score/rich_score_parentData.dart';

class RenderRichScore extends RenderBox with ContainerRenderObjectMixin<RenderBox, RichScoreParentData>,
    RenderBoxContainerDefaultsMixin<RenderBox, RichScoreParentData>,
    DebugOverflowIndicatorMixin {

  RenderRichScore({
    required List<RenderBox> children,
  }) {
    addAll(children);
  }

  @override
  bool get sizedByParent => false;

  final double horizontalSpace = 10;
  final double scoreTextWidthDifference = 10;

  @override
  bool hitTestChildren(BoxHitTestResult result, { required Offset position }) {
    assert(childCount == 2);

    RenderBox? scoreChild = firstChild;
    return scoreChild?.hitTest(result, position: position) ?? false;
  }

  @override
  void performLayout() {
    assert(childCount == 2);

    RenderBox? scoreStarChild = firstChild;
    RenderBox? scoreTextChild = lastChild;

    if (scoreStarChild == null || scoreTextChild == null) {
      size = constraints.smallest;
      return;
    }

    // infinity constraints
    //
    BoxConstraints descConstraints = BoxConstraints();
    scoreTextChild.layout(descConstraints, parentUsesSize: true);

    final RichScoreParentData descChildParentData = scoreTextChild.parentData as RichScoreParentData;
    double descWidth = descChildParentData.scoreTextWidth;
    if (descWidth == null) {
      descWidth = scoreTextChild.size.width + scoreTextWidthDifference;
      descChildParentData.scoreTextWidth = descWidth;
    }

    BoxConstraints scoreConstraints = BoxConstraints(
      minWidth: 0,
      maxWidth: max(constraints.maxWidth - descWidth - horizontalSpace, 0),
      minHeight: 0,
      maxHeight: constraints.maxHeight
    );
    scoreStarChild.layout(scoreConstraints, parentUsesSize: true);

    descChildParentData.offset = Offset(
      scoreStarChild.size.width + horizontalSpace,
      (scoreStarChild.size.height - scoreTextChild.size.height) / 2
    );

    if (constraints.isTight) {
      size = constraints.biggest;
    }
    else {
      double width = min(constraints.biggest.width, scoreStarChild.size.width + descWidth + horizontalSpace);
      width = max(constraints.smallest.width, width);

      double height = max(scoreStarChild.size.height, scoreTextChild.size.height);
      height = min(constraints.biggest.height, height);
      height = max(constraints.smallest.height, height);

      size = Size(width, height);
    }
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    assert(childCount == 2);
    if (childCount != 2) {
      return 0;
    }

    return firstChild?.getMaxIntrinsicWidth(height) ?? 0 + (lastChild?.getMaxIntrinsicWidth(height) ?? 0) + horizontalSpace + scoreTextWidthDifference;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    assert(childCount == 2);
    if (childCount != 2) {
      return 0;
    }

    return firstChild?.getMinIntrinsicWidth(height) ?? 0 + (lastChild?.getMinIntrinsicWidth(height) ?? 0 ) + horizontalSpace + scoreTextWidthDifference;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    assert(childCount == 2);
    if (childCount != 2) {
      return 0;
    }

    return max(firstChild?.getMinIntrinsicHeight(width) ?? 0, lastChild?.getMinIntrinsicHeight(width) ?? 0);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    assert(childCount == 2);
    if (childCount != 2) {
      return 0;
    }

    return max(firstChild?.getMinIntrinsicHeight(width) ?? 0, lastChild?.getMinIntrinsicHeight(width) ?? 0);
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToFirstActualBaseline(baseline);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    assert(childCount == 2);

    if (childCount != 2) {
      return;
    }

    defaultPaint(context, offset);
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! RichScoreParentData) {
      child.parentData = RichScoreParentData();
    }
  }
}