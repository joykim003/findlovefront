import 'package:flutter/material.dart';
import '../../data/services/api_service.dart';
import 'add_interest_dialog.dart';

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
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _addInterest() async {
    final newInterest = await showDialog<String>(
      context: context,
      builder: (context) => AddInterestDialog(
        existingInterests: widget.interests,
      ),
    );

    if (newInterest != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final updatedProfile = await _apiService.updateProfile(
          interests: [...widget.interests, newInterest],
        );
        widget.onInterestsUpdated(updatedProfile.interests);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de l\'ajout de l\'intérêt: $e'),
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
  }

  Future<void> _removeInterest(String interest) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final updatedInterests = List<String>.from(widget.interests)
        ..remove(interest);
      
      final updatedProfile = await _apiService.updateProfile(
        interests: updatedInterests,
      );
      widget.onInterestsUpdated(updatedProfile.interests);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la suppression de l\'intérêt: $e'),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Intérêts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!_isLoading)
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addInterest,
                tooltip: 'Ajouter un intérêt',
              ),
          ],
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.interests.map((interest) {
              return Chip(
                label: Text(interest),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => _removeInterest(interest),
              );
            }).toList(),
          ),
      ],
    );
  }
} 