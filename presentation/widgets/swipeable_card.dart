// lib/presentation/widgets/swipeable_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:myapp/data/models/user_profile.dart';
import 'package:myapp/presentation/widgets/photo_carousel.dart'; // Importez PhotoCarousel
import 'package:myapp/presentation/widgets/user_info_tile.dart'; // Importez UserInfoTile

class SwipeableCard extends StatefulWidget {
  final UserProfile user;
  final VoidCallback? onSwipedLeft;
  final VoidCallback? onSwipedRight;
  final VoidCallback? onSwipedUp;

  const SwipeableCard({
    this.onSwipedLeft,
    this.onSwipedRight,
    this.onSwipedUp,
    required this.user,
    super.key, // TODO: Ajouter les paramètres pour les callbacks
  });

  @override
  _SwipeableCardState createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  Offset _dragPosition = Offset.zero;
  double _rotationAngle = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragPosition = _animation.value;
        _rotationAngle = _dragPosition.dx / 1000;
      });
    });
  }

  @override
void dispose() {
    _controller.dispose();
    super.dispose();
}

  void _runAnimation(Offset pixelsPerSecond, Offset startPosition) {
    _animation = _controller.drive(
      Tween<Offset>(
        begin: startPosition,
        end: Offset.zero,
      ),
    );
    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -pixelsPerSecond.distance);

    _controller.animateWith(simulation);
  }

  void swipeLeft() {
    _animation = Tween<Offset>(begin: _dragPosition, end: const Offset(-1000, 0)).animate(_controller);
    _controller.forward().whenComplete(() => widget.onSwipedLeft?.call());
  }

  void swipeRight() {
    _animation = Tween<Offset>(begin: _dragPosition, end: const Offset(1000, 0)).animate(_controller);
    _controller.forward().whenComplete(() => widget.onSwipedRight?.call());
  }

  void swipeUp() {
     _animation = Tween<Offset>(begin: _dragPosition, end: const Offset(0, -1000)).animate(_controller);
     _controller.forward().whenComplete(() => widget.onSwipedUp?.call());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Implémenter la gestion des gestes de swipe (GestureDetector ou Draggable)
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Card(

          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _dragPosition += details.delta;
                // Simple rotation based on horizontal drag
                _rotationAngle = _dragPosition.dx / 1000;
              });
            },
            onPanEnd: (details) {
              // Define threshold for a swipe
              const double swipeThreshold = 100.0;

              if (_dragPosition.dx > swipeThreshold) { // Swiped right (like)
                // Swiped right (like)
                widget.onSwipedRight?.call();
              } else if (_dragPosition.dx < -swipeThreshold) { // Swiped left (pass)
                // Swiped left (pass)
                widget.onSwipedLeft?.call();
              } else if (_dragPosition.dy < -swipeThreshold) { // Swiped up (super like)
                // Swiped up (super like)
                widget.onSwipedUp?.call();
              }

              _runAnimation(details.velocity.pixelsPerSecond, _dragPosition);
            },
            child: Transform.translate(
              offset: _dragPosition,
              child: Transform.rotate(
                angle: _rotationAngle,
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Stack(
              children: [
                // Afficher les photos du profil en utilisant PhotoCarousel
                PhotoCarousel(photos: widget.user.photos),
                    // Afficher les informations de l'utilisateur en bas de la carte
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.4],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.user.name}, ${widget.user.age}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Afficher la localisation en utilisant UserInfoTile si disponible
                            if (widget.user.location != null && widget.user.location!.isNotEmpty)
                              UserInfoTile(
                                icon: Icons.location_on,
                                text: widget.user.location!,
                                iconColor: Colors.white70,
                                textStyle: const TextStyle(color: Colors.white70, fontSize: 16),
                              ),
                            const SizedBox(height: 8),
                            // Afficher une version courte de la bio ou les intérêts en utilisant UserInfoTile
                            if (widget.user.bio != null && widget.user.bio!.isNotEmpty)
                              UserInfoTile(
                                icon: Icons.info_outline,
                                text: widget.user.bio!.length > 100 // Afficher une version courte de la bio
                                    ? '${widget.user.bio!.substring(0, 100)}...'
                                    : widget.user.bio!,
                                iconColor: Colors.white70,
                                textStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                            // TODO: Afficher les intérêts si la bio n'est pas présente ou si vous voulez les montrer en plus
                            // if (widget.user.bio == null || widget.user.bio!.isEmpty)
                            //   UserInfoTile(
                            //     icon: Icons.interests,
                            //     text: 'Intérêts: ${widget.user.interests.join(', ')}', // Joindre les intérêts
                            //      iconColor: Colors.white70,
                            //      textStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                            //   ),
                          ],
                        ),
                      ),
                    ),
                // TODO: Afficher les indicateurs visuels "LIKE", "PASS", "SUPER LIKE" pendant le swipe
                 // Utiliser Positioned et Opacity ou Transform.rotate/translate
                 // Exemple de placeholder:
                 // if (_dragPosition.dx > 50)
                 //    Positioned(top: 40, right: 40, child: Text('LIKE', style: TextStyle(color: Colors.green, fontSize: 48, fontWeight: FontWeight.bold))),
                 // if (_dragPosition.dx < -50)
                 //    Positioned(top: 40, left: 40, child: Text('PASS', style: TextStyle(color: Colors.red, fontSize: 48, fontWeight: FontWeight.bold))),
                 // if (_dragPosition.dx.abs() > 50 || _dragPosition.dy.abs() > 50) // Show indicator only when dragging
                 //   Positioned.fill(child: Center(child: _buildSwipeIndicator())), // Implement _buildSwipeIndicator

                 // if (_dragPosition.dy < -50)
                 //    Positioned(bottom: 100, child: Center(child: Text('SUPER LIKE', style: TextStyle(color: Colors.blue, fontSize: 48, fontWeight: FontWeight.bold)))),
              ],
            ),
          ),
        ),
      ),
            ),
          ),
        ),
      ),
    );
  }
}

// Remarque: Les classes UserProfile, PhotoCarousel et UserInfoTile
// doivent être définies dans leurs propres fichiers comme prévu.
// Leurs définitions placeholder dans ce fichier ne sont là que pour
// montrer comment elles sont utilisées dans SwipeableCard.
// Assurez-vous que les imports sont corrects après avoir déplacé ces classes.
