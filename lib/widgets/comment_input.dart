// lib/widgets/comment_input.dart
import 'package:flutter/material.dart';

class CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const CommentInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Escribe...'),
          ),
        ),
        IconButton(icon: const Icon(Icons.send), onPressed: onSend),
      ],
    );
  }
}
