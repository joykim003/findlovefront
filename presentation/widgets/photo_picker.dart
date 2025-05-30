import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/data/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoPicker extends StatelessWidget {
  final Function(File) onPhotoSelected;
  final ApiService apiService;

  const PhotoPicker({
    required this.onPhotoSelected,
    required this.apiService,
    Key? key,
  }) : super(key: key);

  Future<void> _pickImage(BuildContext context) async {
    // Demander la permission
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission refusée')),
        );
      }
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      try {
        final result = await apiService.uploadPhoto(file);
        if (result['status'] == 'success') {
          onPhotoSelected(file);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add_photo_alternate),
      onPressed: () => _pickImage(context),
    );
  }
} 