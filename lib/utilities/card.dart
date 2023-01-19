import 'package:flutter/material.dart';
import 'constants.dart';

class ItemCard extends StatelessWidget {
  ItemCard({required this.card});

  final Color cl = Color(0xCD000000).withOpacity(0.25);
  final Widget card;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: card,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: cl,
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
