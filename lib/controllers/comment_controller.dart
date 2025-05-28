// lib/controllers/comment_controller.dart
import 'package:get/get.dart';
import 'package:appturismo/model/comment_model.dart';
import 'package:appturismo/repositories/comment_repository.dart';

class CommentController extends GetxController {
  final CommentRepository _repo = Get.find<CommentRepository>();

  /// Lista de comentarios
  final RxList<CommentModel> comments = <CommentModel>[].obs;

  /// Indicador de carga
  final RxBool isLoading = false.obs;

  /// Mensaje de error
  final RxString error = ''.obs;

  CommentController(
    CommentRepository find,
  ); // <-- Asegúrate de tener esta línea

  Future<void> fetchComments(String placeId) async {
    isLoading.value = true;
    error.value = '';
    try {
      comments.value = await _repo.getCommentsForPlace(placeId);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addComment(CommentModel comment) async {
    isLoading.value = true;
    error.value = '';
    try {
      await _repo.addComment(comment);
      await fetchComments(comment.placeId);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
