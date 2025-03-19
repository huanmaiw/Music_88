import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


void showRatingDialog(BuildContext context) {
  double rating = 0;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Bình chọn cho Zing MP3"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Hãy đánh giá ứng dụng của chúng tôi!"),
            SizedBox(height: 10),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (value) {
                rating = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Cảm ơn bạn đã đánh giá: $rating sao!")),
              );
            },
            child: Text("Gửi"),
          ),
        ],
      );
    },
  );
}
