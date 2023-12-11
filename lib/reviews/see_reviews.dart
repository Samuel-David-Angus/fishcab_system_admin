import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ReviewModel {
  late String reviewer;
  late String reviewee;

  ReviewModel(this.reviewer, this.reviewee);

  Future<String> makeReview(String review, int starRating) async {
    await FirebaseFirestore.instance
        .collection("reviews")
        .doc(reviewee)
        .collection("user_reviews")
        .add({'starRating': starRating, 'review': review, 'reviewedBy': reviewer}).catchError((onError) {
      return onError.toString();
    });
    return "success";
  }

  Future<List<dynamic>> getReviews() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("reviews").doc(reviewee).collection("user_reviews").get();

    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }
}

class ReviewController {
  late ReviewModel model;
  double average = 0;

  ReviewController(this.model);

  Future<SnackBar> makeReview(String review, int starRating) async {
    String message = await model.makeReview(review, starRating).onError((error, stackTrace) {
      return "Error: $error";
    });

    if (message == "success") {
      return const SnackBar(
        content: Text(
          "Successfully sent review",
          style: TextStyle(
            fontSize: 36,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 5),
      );
    }
    return SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 36,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 5),
    );
  }

  Future<List<Widget>> getReviews() async {
    List<dynamic> list = await model.getReviews();
    List<Widget> reviews = [];
    for (var review in list) {
      List<Icon> stars = [];
      average += review["starRating"] as double;
      for (int i = 0; i < review["starRating"]; i++) {
        stars.add(const Icon(Icons.star));
      }
      reviews.add(ExpansionTile(
        title: Row(
          children: stars,
        ),
        subtitle: Text(review["reviewedBy"]),
        children: [
          ListTile(
            title: const Text("Review:"),
            subtitle: Text(review["review"]),
          )
        ],
      ));
    }
    average /= list.length;
    if (list.isNotEmpty) {
      reviews.insert(0, Text("Average Rating $average stars"));
    } else {
      reviews.insert(0, const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("No reviews yet",),
      ));
    }

    return reviews;
  }
}

class ViewReviewView extends StatefulWidget {
  late String reviewee;
  late ReviewController controller = ReviewController(ReviewModel("sam for now", reviewee));

  ViewReviewView({super.key, required this.reviewee});

  @override
  State<ViewReviewView> createState() => _ViewReviewViewState();
}

class _ViewReviewViewState extends State<ViewReviewView> {
  late final Future<List<Widget>> r = widget.controller.getReviews();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reviews"),),
      body: FutureBuilder<List<Widget>>(
        future: r,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  // AsyncSnapshot<Your object type>
          if( snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: Text('Please wait its loading...'));
          }else{
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Column(
                children: snapshot.data,
              );
            }// snapshot.data  :- get your object which is pass from your downloadData() function
          }
        },),
    );
  }
}