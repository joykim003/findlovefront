// lib/presentation/widgets/photo_carousel.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Pour charger les images depuis le réseau
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Pour l'indicateur de page

class PhotoCarousel extends StatefulWidget {
  final List<String> photos; // Liste des URLs des photos

  const PhotoCarousel({super.key, required this.photos});

  @override
  _PhotoCarouselState createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<PhotoCarousel> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.photos.isEmpty) {
      // Afficher un placeholder si aucune photo n'est disponible
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
        ),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: widget.photos.length,
          itemBuilder: (context, index) {
            final photoUrl = widget.photos[index];
            return CachedNetworkImage( // Utilisation de CachedNetworkImage
              imageUrl: photoUrl,
              fit: BoxFit.cover, // Couvre la zone allouée
              placeholder: (context, url) => Container( // Placeholder pendant le chargement
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container( // Widget en cas d'erreur
                 color: Colors.grey[300],
                 child: const Center(child: Icon(Icons.error_outline, color: Colors.red)),
              ),
            );
          },
        ),
        if (widget.photos.length > 1) // Afficher l'indicateur seulement s'il y a plus d'une photo
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0), // Espacement par rapport au bas
              child: SmoothPageIndicator(
                controller: _pageController,
                count: widget.photos.length,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Colors.white, // Couleur du point actif (visible sur les photos)
                  dotColor: Colors.white54, // Couleur des points inactifs
                  dotHeight: 6,
                  dotWidth: 6,
                  spacing: 8,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
// TODO Implement this library.
