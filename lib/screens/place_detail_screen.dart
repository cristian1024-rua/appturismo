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
  final CommentController commentCtrl = Get.find<CommentController>();
  final AuthController authCtrl = Get.find<AuthController>();
  final TextEditingController _commentController = TextEditingController();

  PlaceDetailScreen({required this.place, super.key});

  @override
  Widget build(BuildContext context) {
    // Cargar comentarios al entrar a la pantalla
    commentCtrl.fetchComments(place.id);

    return Scaffold(
      appBar: AppBar(title: Text(place.title)),
      body: Column(
        children: [
          // Imagen del lugar
          if (place.imageUrl.isNotEmpty)
            Image.network(
              place.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

          // Detalles del lugar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(place.description),
              ],
            ),
          ),

          const Divider(),

          // Sección de comentarios
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.comment),
                SizedBox(width: 8),
                Text(
                  'Comentarios',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
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
              return CommentList(comments: commentCtrl.comments);
            }),
          ),

          // Input para nuevo comentario
          Padding(
            padding: const EdgeInsets.all(8),
            child: CommentInput(
              controller: _commentController,
              onSend: () {
                final user = authCtrl.user.value;
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
                    'Error',
                    'El comentario no puede estar vacío',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }

                final newComment = CommentModel(
                  id: '',
                  userId: user.$id,
                  placeId: place.id,
                  text: text,
                  username: user.name.isNotEmpty ? user.name : 'Anónimo',
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
