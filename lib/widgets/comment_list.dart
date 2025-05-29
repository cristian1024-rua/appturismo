import 'package:flutter/material.dart';
import 'package:appturismo/model/comment_model.dart';

class CommentList extends StatelessWidget {
  final List<CommentModel> comments;

  const CommentList({Key? key, required this.comments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const Center(child: Text('Sin comentarios aún'));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: comments.length,
      itemBuilder: (_, index) {
        final comment = comments[index];
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(comment.text),
          subtitle: Text(
            'Por ${comment.username}', // Removido el formateo de fecha ya que no tenemos createdAt
          ),
        );
      },
    );
  }
}
