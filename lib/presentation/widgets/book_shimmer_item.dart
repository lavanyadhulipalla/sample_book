import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookShimmerItem extends StatelessWidget {
  const BookShimmerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        leading: Container(width: 50, height: 70, decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
        ),),
        title: Container(width: double.infinity, height: 16.0, decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: Colors.white,
        ),),
        subtitle: Container(width: double.infinity, height: 14.0, decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: Colors.white,
        ),),
      ),
    );
  }
}