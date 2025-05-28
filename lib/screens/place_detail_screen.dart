// lib/screens/place_detail_screen.dart
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appturismo/controllers/comment_controller.dart';
import 'package:appturismo/controllers/auth_controller.dart';
import 'package:appturismo/model/place_model.dart';
import 'package:appturismo/model/comment_model.dart';
import 'package:appturismo/widgets/comment_list.dart';
import 'package:appturismo/widgets/comment_input.dart';

class PlaceDetailScreen extends StatelessWidget {
  final Place place;
  PlaceDetailScreen({required this.place, super.key});

  final CommentController commentCtrl = Get.find<CommentController>();
  final AuthController authCtrl = Get.find<AuthController>();
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    commentCtrl.fetchComments(place.id);

    return Scaffold(
      appBar: AppBar(title: Text(place.title)),
      body: Column(
        children: [
          // ... imagen y descripción omitidos por brevedad ...
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Comentarios:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (commentCtrl.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (commentCtrl.error.value.isNotEmpty) {
                return Center(child: Text('Error: ${commentCtrl.error.value}'));
              }
              if (commentCtrl.comments.isEmpty) {
                return const Center(child: Text('No hay comentarios aún.'));
              }
              return CommentList(comments: commentCtrl.comments);
            }),
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: CommentInput(
              controller: _commentController,
              onSend: () {
                final User? user = authCtrl.user.value;
                if (user == null) {
                  Get.snackbar(
                    'Error',
                    'Debe iniciar sesión para comentar',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }
                final text = _commentController.text.trim();
                if (text.isEmpty) {
                  Get.snackbar(
                    'Advertencia',
                    'El comentario no puede estar vacío',
                  );
                  return;
                }
                final newComment = CommentModel(
                  id: '',
                  placeId: place.id,
                  userId: user.$id,
                  username: user.name.isNotEmpty ? user.name : 'Anónimo',
                  text: text,
                  createdAt: DateTime.now(),
                  content: '',
                );
                commentCtrl.addComment(newComment);
                _commentController.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}
