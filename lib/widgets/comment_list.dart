import 'package:flutter/material.dart';
import 'package:appturismo/model/comment_model.dart'; // Importar CommentModel

class CommentList extends StatelessWidget {
  final List<CommentModel> comments; // Ahora recibe una lista de CommentModel

  const CommentList({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const Center(child: Text('No hay comentarios aún.'));
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        return ListTile(
          subtitle: Text(
            'Por: ${comment.username} el ${comment.createdAt.toLocal().toString().split(' ')[0]}',
          ), // Formato de fecha
        );
      },
    );
  }
}
