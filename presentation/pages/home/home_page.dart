import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/presentation/widgets/bottom_nav_bar.dart';
import 'package:myapp/presentation/widgets/custom_app_bar.dart';
import 'package:myapp/presentation/widgets/icon_action_button.dart';
import 'package:myapp/presentation/widgets/swipeable_card.dart'; // Import SwipeableCard

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Create a GlobalKey for the SwipeableCard
  final GlobalKey<SwipeableCardState> _swipeableCardKey = GlobalKey<SwipeableCardState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Discover',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SwipeableCard( // Assign the key to the SwipeableCard
                key: _swipeableCardKey,
                // TODO: Replace with actual user profile data
                child: Container(
                  color: Colors.blueGrey[200],
                  child: const Center(
                    child: Text(
                      'User Profile Card',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                onSwipedLeft: () {
                  print('Swiped Left (Pass)');
                  // TODO: Implement logic for passing on a profile
                },
                onSwipedRight: () {
                  print('Swiped Right (Like)');
                  // TODO: Implement logic for liking a profile
                },
                onSwipedUp: () {
                   print('Swiped Up (Super Like)');
                   // TODO: Implement logic for super liking a profile
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconActionButton(
                    icon: Icons.close,
                    color: Colors.red,
                    onPressed: () {
                      // Call swipeLeft() when the "Pass" button is pressed
                      _swipeableCardKey.currentState?.swipeLeft();
                    },
                  ),
                  IconActionButton(
                    icon: Icons.star,
                    color: Colors.blue,
                    onPressed: () {
                       // Call swipeUp() when the "Super Like" button is pressed
                       _swipeableCardKey.currentState?.swipeUp();
                    },
                    size: 60, // Make the super like button slightly larger
                  ),
                  IconActionButton(
                    icon: Icons.favorite,
                    color: Colors.green,
                    onPressed: () {
                      // Call swipeRight() when the "Like" button is pressed
                      _swipeableCardKey.currentState?.swipeRight();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0, // Assuming Home is the first item
        onTap: (index) {
          // TODO: Implement navigation based on index
          if (index == 1) {
             context.go('/matches'); // Example navigation
          } else if (index == 2) {
            context.go('/profile'); // Example navigation
          }
        },
      ),
    );
  }
}
