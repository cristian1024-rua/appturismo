// lib/widgets/comment_list.dart
import 'package:flutter/material.dart';
import 'package:appturismo/model/comment_model.dart';

class CommentList extends StatelessWidget {
  final List<CommentModel> comments;
  const CommentList({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const Center(child: Text('Sin comentarios aún'));
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: comments.length,
      itemBuilder: (_, idx) {
        final c = comments[idx];
        return ListTile(
          title: Text(c.text),
          subtitle: Text(
            'Por ${c.username} el ${c.createdAt.toLocal().toIso8601String().split("T")[0]}',
          ),
        );
      },
    );
  }
}
