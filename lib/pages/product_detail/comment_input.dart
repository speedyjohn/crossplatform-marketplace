import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final ImagePicker picker;

  const CommentInput({
    Key? key,
    required this.controller,
    required this.onSubmit,
    required this.picker,
  }) : super(key: key);

  Future<void> _pickImage(ImageSource source) async {
    try {
      await picker.pickImage(source: source);
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
              tooltip: 'Pick from gallery',
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () => _pickImage(ImageSource.camera),
              tooltip: 'Make photo',
            ),
            const SizedBox(width: 8),
            const Text(AppLocalizations.of(context)!.pinPhoto,
                style: TextStyle(color: Colors.grey)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.writeComment,
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: onSubmit,
              ),
            ],
          ),
        ),
      ],
    );
  }
} 