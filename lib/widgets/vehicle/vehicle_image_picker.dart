import 'dart:io';
import 'package:flutter/material.dart';

class VehicleImagePicker extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final bool readOnly;
  final VoidCallback onPickImage;

  const VehicleImagePicker({
    super.key,
    required this.imageFile,
    required this.imageUrl,
    required this.readOnly,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: readOnly ? null : onPickImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          imageFile!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => _buildErrorPlaceholder(),
        ),
      );
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          loadingBuilder: (_, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (_, __, ___) => _buildErrorPlaceholder(),
        ),
      );
    }

    return _buildPlaceholder();
  }

  Widget _buildErrorPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'Error al cargar imagen',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_camera,
            size: 40,
            color: readOnly ? Colors.grey[400] : Colors.blue[400],
          ),
          const SizedBox(height: 8),
          Text(
            readOnly ? 'Sin imagen' : 'Toca para agregar imagen',
            style: TextStyle(
              color: readOnly ? Colors.grey[600] : Colors.blue[600],
            ),
          ),
        ],
      ),
    );
  }
}
