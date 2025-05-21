import 'package:get/get.dart';
import 'package:appturismo/model/comment_model.dart';
import 'package:appturismo/repositories/comment_repository.dart';

class CommentController extends GetxController {
  final CommentRepository _commentRepository;
  final RxList<CommentModel> comments = <CommentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  CommentController(this._commentRepository);

  Future<void> fetchComments(String placeId) async {
    isLoading.value = true;
    error.value = '';
    try {
      comments.value = await _commentRepository.getCommentsForPlace(placeId);
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error al cargar comentarios',
        error.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addComment(CommentModel comment) async {
    isLoading.value = true;
    error.value = '';
    try {
      await _commentRepository.addComment(comment);
      // Recargar comentarios para el mismo lugar después de añadir
      fetchComments(comment.placeId);
      Get.snackbar(
        'Éxito',
        'Comentario añadido',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'No se pudo añadir el comentario',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
