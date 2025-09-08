import 'package:flutter/material.dart';

class AddInterestDialog extends StatefulWidget {
  final List<String> existingInterests;

  const AddInterestDialog({
    super.key,
    required this.existingInterests,
  });

  @override
  State<AddInterestDialog> createState() => _AddInterestDialogState();
}

class _AddInterestDialogState extends State<AddInterestDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    final interest = _controller.text.trim();
    
    if (interest.isEmpty) {
      setState(() {
        _error = 'Veuillez entrer un intérêt';
      });
      return;
    }

    if (widget.existingInterests.contains(interest)) {
      setState(() {
        _error = 'Cet intérêt existe déjà';
      });
      return;
    }

    Navigator.of(context).pop(interest);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un intérêt'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Intérêt',
              errorText: _error,
              border: const OutlineInputBorder(),
            ),
            autofocus: true,
            onSubmitted: (_) => _validateAndSubmit(),
          ),
          const SizedBox(height: 16),
          if (widget.existingInterests.isNotEmpty) ...[
            const Text(
              'Intérêts existants :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: widget.existingInterests
                  .map((interest) => Chip(label: Text(interest)))
                  .toList(),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _validateAndSubmit,
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
} 