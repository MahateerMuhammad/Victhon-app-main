import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget buildServiceCard(String title, String imagePath) {
  return Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CachedNetworkImage(
            imageUrl: imagePath, // Network image URL
            height: 120,
            width: 120,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Container(),
          ),
          Container(
            color: Colors.black.withOpacity(0.4),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            width: 120,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
