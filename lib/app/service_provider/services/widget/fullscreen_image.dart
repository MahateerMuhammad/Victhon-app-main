import 'dart:io';
import 'package:flutter/material.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;

  const FullScreenImageViewer({
    super.key,
    this.imageUrl,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: imageFile != null
            ? Image.file(imageFile!)
            : imageUrl != null
                ? Image.network(imageUrl!)
                : const Text(
                    "No Image",
                    style: TextStyle(color: Colors.white),
                  ),
      ),
    );
  }
}
