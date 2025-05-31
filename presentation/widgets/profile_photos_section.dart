import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/services/api_service.dart';
import '../../providers/auth_provider.dart';
import 'package:flutter/foundation.dart';

class ProfilePhotosSection extends ConsumerStatefulWidget {
  final List<String> photos;
  final Function(List<String>) onPhotosUpdated;

  const ProfilePhotosSection({
    super.key,
    required this.photos,
    required this.onPhotosUpdated,
  });

  @override
  ConsumerState<ProfilePhotosSection> createState() => _ProfilePhotosSectionState();
}

class _ProfilePhotosSectionState extends ConsumerState<ProfilePhotosSection> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _error;

  Future<void> _pickAndUploadImage() async {
    try {
      final authState = ref.read(authStateProvider);
      final user = authState.when(
        data: (user) => user,
        loading: () => null,
        error: (_, __) => null,
      );

      if (user == null) {
        throw 'Utilisateur non connecté';
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() {
        _isLoading = true;
        _error = null;
      });

      final imageFile = kIsWeb ? image : File(image.path);
      await _apiService.uploadPhoto(imageFile);
      
      // Recharger le profil pour obtenir la liste mise à jour des photos
      final updatedProfile = await _apiService.getProfile(user.id);
      widget.onPhotosUpdated(updatedProfile.photos);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo ajoutée avec succès !')),
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'ajout de la photo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deletePhoto(int index) async {
    try {
      final authState = ref.read(authStateProvider);
      final user = authState.when(
        data: (user) => user,
        loading: () => null,
        error: (_, __) => null,
      );

      if (user == null) {
        throw 'Utilisateur non connecté';
      }

      setState(() {
        _isLoading = true;
        _error = null;
      });

      await _apiService.deletePhoto(index);
      
      // Recharger le profil pour obtenir la liste mise à jour des photos
      final updatedProfile = await _apiService.getProfile(user.id);
      widget.onPhotosUpdated(updatedProfile.photos);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo supprimée avec succès !')),
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la suppression de la photo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildPhotoItem(String photoUrl, int index) {
    // Normaliser l'URL de la photo
    final normalizedUrl = photoUrl.replaceAll('\\', '/');
    // Utiliser l'URL de base sans /api pour les fichiers média
    final baseUrl = ApiService.baseUrl.replaceAll('/api', '');
    final fullUrl = normalizedUrl.startsWith('http')
        ? normalizedUrl
        : '$baseUrl$normalizedUrl';

    print('URL de l\'image construite: $fullUrl'); // Pour le débogage

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            fullUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Erreur de chargement de l\'image: $error');
              print('URL de l\'image: $fullUrl');
              return Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
                child: const Icon(Icons.error_outline),
              );
            },
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => _deletePhoto(index),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Photos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!_isLoading)
              IconButton(
                icon: const Icon(Icons.add_photo_alternate),
                onPressed: widget.photos.length < 5 ? _pickAndUploadImage : null,
                tooltip: widget.photos.length < 5
                    ? 'Ajouter une photo'
                    : 'Maximum 5 photos atteint',
              ),
          ],
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              _error!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.photos.length + (widget.photos.length < 5 ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == widget.photos.length) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: _pickAndUploadImage,
                      child: Container(
                        width: 150,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.add_photo_alternate,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final photoUrl = widget.photos[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildPhotoItem(photoUrl, index),
                );
              },
            ),
          ),
        if (widget.photos.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${widget.photos.length}/5 photos',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
} 