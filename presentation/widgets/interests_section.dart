import 'package:flutter/material.dart';

class InterestsSection extends StatefulWidget {
  final List<String> interests;
  final Function(List<String>) onInterestsUpdated;

  const InterestsSection({
    super.key,
    required this.interests,
    required this.onInterestsUpdated,
  });

  @override
  State<InterestsSection> createState() => _InterestsSectionState();
}

class _InterestsSectionState extends State<InterestsSection> {
  final List<String> _availableInterests = [
    'Musique',
    'Cinéma',
    'Lecture',
    'Sport',
    'Voyage',
    'Cuisine',
    'Art',
    'Photographie',
    'Nature',
    'Technologie',
    'Mode',
    'Danse',
    'Théâtre',
    'Jeux vidéo',
    'Yoga',
    'Méditation',
    'Animaux',
    'Jardinage',
    'Histoire',
    'Science',
  ];

  late List<String> _selectedInterests;

  @override
  void initState() {
    super.initState();
    _selectedInterests = List.from(widget.interests);
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        if (_selectedInterests.length < 5) {
          _selectedInterests.add(interest);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vous ne pouvez sélectionner que 5 intérêts maximum'),
            ),
          );
        }
      }
      widget.onInterestsUpdated(_selectedInterests);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableInterests.map((interest) {
            final isSelected = _selectedInterests.contains(interest);
            return FilterChip(
              label: Text(interest),
              selected: isSelected,
              onSelected: (_) => _toggleInterest(interest),
              selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              checkmarkColor: Theme.of(context).colorScheme.primary,
            );
          }).toList(),
        ),
        if (_selectedInterests.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Intérêts sélectionnés (${_selectedInterests.length}/5)',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
} 