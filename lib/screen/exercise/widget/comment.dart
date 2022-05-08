import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:heathee/model/exercise/review.dart';

class Comment extends StatelessWidget {
  final Review review;

  const Comment({this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("${review.nickname}"),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              RatingBarIndicator(
                rating: review.rating.toDouble(),
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 15.0,
                direction: Axis.horizontal,
              ),
              SizedBox(
                width: 7,
              ),
              Text(review.creationDate),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text("${review.content}")
        ],
      ),
    );
  }
}
