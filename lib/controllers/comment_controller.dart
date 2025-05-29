import 'package:get/get.dart';
import 'package:appturismo/model/comment_model.dart';
import 'package:appturismo/repositories/comment_repository.dart';

class CommentController extends GetxController {
  final CommentRepository _repository;
  final RxList<CommentModel> comments = <CommentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  CommentController(this._repository);

  Future<void> fetchComments(String placeId) async {
    try {
      isLoading.value = true;
      error.value = '';
      final results = await _repository.getComments(placeId);
      comments.value = results.cast<CommentModel>();
    } catch (e) {
      error.value = e.toString();
      print('Error fetching comments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addComment(CommentModel comment) async {
    try {
      isLoading.value = true;
      error.value = '';

      await _repository.addComment(comment);
      await fetchComments(
        comment.placeId,
      ); // Recargar comentarios después de agregar uno nuevo

      Get.snackbar(
        'Éxito',
        'Comentario agregado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'No se pudo agregar el comentario: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
