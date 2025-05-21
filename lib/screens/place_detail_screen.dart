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
    commentCtrl.fetchComments(
      place.id,
    ); // Asegura que se carguen los comentarios para este lugar
    return Scaffold(
      appBar: AppBar(title: Text(place.name)),
      body: Column(
        children: [
          Image.network(
            place.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                // El child debe ser un solo Widget. Si quieres varios, usa Column o Row.
                child: const Column(
                  // Usamos Column para centrar el icono y el texto
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    Text(
                      'Error al cargar imagen',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(place.description),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              return CommentList(
                comments:
                    commentCtrl
                        .comments, // Pasa la lista completa de CommentModel
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                if (_commentController.text.trim().isEmpty) {
                  Get.snackbar(
                    'Advertencia',
                    'El comentario no puede estar vacío',
                  );
                  return;
                }
                final comment = CommentModel(
                  id: '', // Appwrite asignará el ID
                  placeId: place.id,
                  userId: user.$id,
                  username:
                      user.username, // Usa el nombre de usuario del AuthController
                  content: _commentController.text.trim(),
                  createdAt: DateTime.now(),
                  text: '',
                );
                commentCtrl.addComment(comment);
                _commentController.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}

extension on User {
  get username => null;
}
