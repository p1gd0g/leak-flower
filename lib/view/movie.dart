import 'package:flutter/material.dart';
import 'package:myapp/controller/connect.dart';

class MovieItem extends StatelessWidget {
  const MovieItem(this.outputCard, {super.key});

  final OutputCard outputCard;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(outputCard.imgUrl!),
          ),
        ],
      ),
    );
  }
}
