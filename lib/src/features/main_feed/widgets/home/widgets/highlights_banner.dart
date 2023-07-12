import 'package:flutter/material.dart';

class HighlightsBanner extends StatelessWidget {
  const HighlightsBanner({super.key, this.onPressed, this.image});

  final Function()? onPressed;
  final String? image;

  factory HighlightsBanner.fromSnapshot(Map<String, dynamic> data) {
    return HighlightsBanner(image: data['imageUrl']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 132,
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
                image ??
                    "https://firebasestorage.googleapis.com/v0/b/report-it-ips.appspot.com/o/placeholder_banner.png?alt=media&token=8cd139d4-5370-402c-811f-c1dd4b0ee6dd",
                fit: BoxFit.fill)),
      ]),
    );
  }
}
