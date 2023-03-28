import 'package:flutter/material.dart';
import 'package:flutter_ratingbar/render_box/rich_score/rich_score_container.dart';
import 'package:flutter_ratingbar/samples/samples.dart';

import 'compose_score/my_score.dart';
import 'custom/custom_rating_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyScoreWidget(),
    );
  }
}

class MyScoreWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MyScoreState();
  }
}

class MyScoreState extends State<MyScoreWidget> {

  Key scoreKey = ValueKey('score_widget');

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(seconds: 3)).then((value) {
    //   setState(() {
    //     widget.v = 4.0;
    //     print('... ${widget.v}');
    //
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RatingBar'),
      ),
      body: _buildBody()
      // body: TopBottomLayout(
      //   list: [
      //     Text('上边的'),
      //     Text('下边的'),
      //   ],
      //
      // ),
    );
  }

  _buildBody(){
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.vertical,
        spacing: 20,
        children: [
          Text('自定义clip'),
          SponRatingWidget(
            key: scoreKey,
            maxRating: 5,
            value: 3.5,
            count: 5,
            size: 30,
            padding: 10,
            selectAble: true,
            onRatingUpdate: (String value) {
              print(value);
            },
          ),

          Text('组合形式'),
          RatingWidget(
            initialRating: 3.5,
            onRatingChanged: (value){

            },
          ),

          Text('继承renderBox绘制'),
          SizedBox(
            child: RichScoreContainer(score: 3.5,),
            width: 250,
          ),


          Sample(
            initialRating: 3.5,
            onRatingChanged: (double ) {

            },),



        ],
      ),
    );
  }
}
