import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class ReviewWriting extends StatelessWidget {
  final exercise;
  final rating;
  final review;
  final creationDate;
  const ReviewWriting(
      {this.exercise, this.rating, this.review, this.creationDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: RatingBar(
            initialRating:
                (rating == null) ? 0 : double.parse(rating.toString()),
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.yellow,
            ),
            onRatingUpdate: (value) {
              print(value);
              print('/exerciseReviewWriting?exercise=$exercise&rating=$value');
              // => 현재 레이팅을 가지고 리뷰 작성페이지로 보내기
              Get.toNamed(
                '/exerciseReviewWriting?exercise=$exercise&rating=$value',
              );
            },
          ),
        ),
        (review != null)
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "나의 리뷰    $creationDate",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        review,
                      ),
                    )
                  ],
                ),
              )
            : Container()
      ],
    );
  }
}
