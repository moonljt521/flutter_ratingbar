import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../custom/custom_rating_widget.dart';
import '../render_box/base/score.dart';
import '../render_box/rich_score/render_rich_score.dart';

class Sample extends StatefulWidget {
  final double initialRating;

  final Function(double) onRatingChanged;

  const Sample(
      {Key? key, this.initialRating = 0, required this.onRatingChanged})
      : super(key: key);

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<Sample> {
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
    return ClipRect(
      // clipper: SMClipper(rating: 32),
      clipper: MyClipper(value: 6.4),
      child: Icon(
        Icons.star,
        color: _color,
        size: 64.0,
      ),
    );



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
                  size: 34.0,
                );
              } else if (currentIndex <= _rating) {
                return Icon(
                  Icons.star,
                  color: _color,
                  size: 34.0,

                );
              } else {
                return Icon(
                  Icons.star_border,
                  color: _color,
                  size: 34.0,

                );
              }
            }),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Text("$_rating", style: TextStyle(fontSize: 27, color: _color),)
      ],
    );
  }
}

class MyClipper extends CustomClipper<Rect> {

  final double value;

  MyClipper({required this.value});

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, value, size.height);

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}


class CustomCenter extends SingleChildRenderObjectWidget {

  // Widget child;

  CustomCenter({Key? key, Widget? child})
      : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomCenter();
  }
}

class RenderCustomCenter extends RenderShiftedBox {
  RenderCustomCenter({RenderBox? child}) : super(child);

  @override
  void performLayout() {
    //1,先对子组件进行 layout，随后获取他的 size
    child?.layout(constraints.loosen(), //将约束传递给子节点
        parentUsesSize: true //因为接下来要使用 child 的 size，所以不能为 false
    );
    //2，根据子组件的大小确定自身的大小
    size = constraints.constrain(Size(
        constraints.maxWidth == double.infinity
            ? (child?.size.width ?? 0)
            : double.infinity,
        constraints.maxHeight == double.infinity
            ? (child?.size.height ?? 0)
            : double.infinity));

    size = Size(200, 200);

    //3，根据父节点大小，算出子节点在父节点中居中后的偏移，
    //然后将这个偏移保存在子节点的 parentData 中，在后续的绘制节点会用到
    BoxParentData parentData = child?.parentData as BoxParentData;
    parentData.offset = ((size - (child?.size ?? const Size(0, 0))) as Offset) / 2;
  }
}



class TopBottomLayout extends MultiChildRenderObjectWidget {

  TopBottomLayout({Key? key, required List<Widget> list})
      : assert(list.length == 2, "只能传两个 child"),
        super(key: key, children: list);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TopBottomRender();
  }
}

class TopBottomParentData extends ContainerBoxParentData<RenderBox> {}

class TopBottomRender extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, TopBottomParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, TopBottomParentData> {
  /// 初始化每一个 child 的 parentData
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! TopBottomParentData)
      child.parentData = TopBottomParentData();
  }

  @override
  void performLayout() {
    //获取当前约束(从父组件传入的)，
    final BoxConstraints constraints = this.constraints;

    //获取第一个组件，和他父组件传的约束
    RenderBox? topChild = firstChild;
    TopBottomParentData childParentData =
    topChild?.parentData as TopBottomParentData;

    //获取下一个组件
    //至于这里为什么可以获取到下一个组件，是因为在 多子组件的 mount 中，遍历创建所有的 child 然后将其插入到到 child 的 childParentData 中了
    RenderBox? bottomChild = childParentData.nextSibling;

    //限制下孩子高度不超过总高度的一半
    bottomChild?.layout(
        constraints.copyWith(maxHeight: constraints.maxHeight / 2),
        parentUsesSize: true);

    //设置下孩子的 offset
    childParentData = bottomChild?.parentData as TopBottomParentData;
    //位于最下边
    childParentData.offset = Offset(0, constraints.maxHeight - (bottomChild?.size.height ?? 0));

    //上孩子的 offset 默认为 (0,0),为了确保上孩子能始终显示，我们不修改他的 offset
    topChild?.layout(
        constraints.copyWith(
          //上侧剩余的最大高度
            maxHeight: constraints.maxHeight - (bottomChild?.size.height ?? 0)),
        parentUsesSize: true);

    //设置上下组件的 size
    size = Size(
        max((topChild?.size.width ?? 0), (bottomChild?.size.width ?? 0)),
        constraints.maxHeight);
  }

  double max(double height, double height2) {
    if (height > height2)
      return height;
    else
      return height2;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset? position}) {
    return defaultHitTestChildren(result, position: position ?? Offset.zero);
  }
}


class TopBottomRender1 extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, TopBottomParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, TopBottomParentData> {
  /// 初始化每一个 child 的 parentData
  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! TopBottomParentData)
      child.parentData = TopBottomParentData();
  }

  @override
  void performLayout() {
    //获取当前约束(从父组件传入的)，
    final BoxConstraints constraints = this.constraints;

    //获取第一个组件，和他父组件传的约束
    RenderBox? leftChild = firstChild;
    TopBottomParentData childParentData =
    leftChild?.parentData as TopBottomParentData;
    //获取下一个组件
    //至于这里为什么可以获取到下一个组件，是因为在 多子组件的 mount 中，遍历创建所有的 child 然后将其插入到到 child 的 childParentData 中了
    RenderBox? rightChild = childParentData.nextSibling;

    //限制右孩子宽度不超过总宽度的一半
    rightChild?.layout(constraints.copyWith(maxWidth: constraints.maxWidth / 2),
        parentUsesSize: true);

    //设置右子节点的 offset
    childParentData = rightChild?.parentData as TopBottomParentData;
    //位于最右边
    childParentData.offset =
        Offset(constraints.maxWidth - (rightChild?.size.width ?? 0), 0);

    //左子节点的 offset 默认为 (0,0),为了确保左子节点能始终显示，我们不修改他的 offset
    leftChild?.layout(
        constraints.copyWith(
          //左侧剩余的最大宽度
            maxWidth: constraints.maxWidth - (rightChild?.size.width ?? 0)),
        parentUsesSize: true);

    //设置 leftRight 自身的 size
    size = Size(constraints.maxWidth,
        max((leftChild?.size.height ?? 0), (rightChild?.size.height ?? 0)));
  }

  double max(double height, double height2) {
    if (height > height2)
      return height;
    else
      return height2;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset? position}) {
    return defaultHitTestChildren(result, position: position ?? Offset(0, 0));
  }
}










