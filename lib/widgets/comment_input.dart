import 'package:flutter/material.dart';

class CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const CommentInput({Key? key, required this.controller, required this.onSend})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Escribe un comentario...',
                border: InputBorder.none,
              ),
              maxLines: null,
            ),
          ),
          IconButton(icon: const Icon(Icons.send), onPressed: onSend),
        ],
      ),
    );
  }
}
