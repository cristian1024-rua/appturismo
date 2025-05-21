// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Importa el modelo Document de Appwrite
import 'package:appturismo/controllers/auth_controller.dart';
import 'package:appturismo/controllers/user_controller.dart';
// Quita el import de user_model.dart si no tienes un modelo UserModel explícito
// Si tienes un user_model.dart, asegúrate de que tiene un factory constructor
// para crear un objeto a partir de un Appwrite Document.
// Si no lo tienes, simplemente omite esta línea.
// import 'package:appturismo/model/user_model.dart'; // <--- Descomenta y ajusta si tienes uno, si no, déjalo comentado

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final AuthController authController = Get.find<AuthController>();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    // Puedes definir un modelo simple de usuario si lo necesitas para la UI,
    // o puedes trabajar directamente con Map<String, dynamic> si es más sencillo.
    // Para este ejemplo, asumiremos que los datos del usuario se manejan como Map<String, dynamic>
    // o que el 'Document' de Appwrite se mapea directamente.
    // Si necesitas un UserModel, agrégalo a un archivo user_model.dart como este:
    /*
    class UserModel {
      final String id;
      final String username;
      final String email;

      UserModel({required this.id, required this.username, required this.email});

      factory UserModel.fromDocument(Document doc) {
        return UserModel(
          id: doc.$id,
          username: doc.data['name'] as String, // Asume que el campo es 'name' en Appwrite
          email: doc.data['email'] as String,
        );
      }

      Map<String, dynamic> toMap() {
        return {
          'name': username, // Nombre del campo en Appwrite
          'email': email,
        };
      }
    }
    */

    void submitUser({String? userIdToUpdate}) {
      if (formKey.currentState!.validate()) {
        final userData = {
          // Si tu colección de usuarios usa 'name' en lugar de 'username', cámbialo aquí.
          'name':
              usernameController.text
                  .trim(), // Asume que el campo es 'name' en Appwrite
          'email': emailController.text.trim(),
        };

        if (userIdToUpdate != null && userIdToUpdate.isNotEmpty) {
          userController.updateUser(userIdToUpdate, userData);
        } else {
          // Si estás añadiendo un usuario nuevo con un ID específico (ej. el ID de Appwrite Auth)
          // puedes pasarlo en el mapa. Si no, Appwrite generará uno.
          // Por ahora, asumimos que 'addUser' manejará la creación del ID.
          userController.addUser(userData);
        }
        usernameController.clear();
        emailController.clear();
        Get.back(); // Cierra el diálogo si se abrió para editar
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de Usuarios',
        ), // Cambiado para mayor claridad
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        // Corrección: usar userController.errorMessage
        if (userController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              'Error: ${userController.errorMessage.value}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 12.0,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de Usuario',
                      ),
                      validator:
                          (value) =>
                              (value == null || value.isEmpty)
                                  ? 'Campo requerido'
                                  : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator:
                          (value) =>
                              (value == null || value.isEmpty)
                                  ? 'Campo requerido'
                                  : null,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed:
                          () => submitUser(), // Para añadir nuevo usuario
                      child: const Text('Agregar Usuario'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child:
                  userController.users.isEmpty
                      ? const Center(
                        child: Text('No hay usuarios registrados.'),
                      )
                      : ListView.builder(
                        itemCount: userController.users.length,
                        itemBuilder: (context, index) {
                          final userDoc = userController.users[index];
                          // Accede a los campos del documento usando .data
                          final String userId = userDoc.$id;
                          final String username =
                              userDoc.data['name'] as String? ??
                              'N/A'; // Asume que el campo es 'name'
                          final String email =
                              userDoc.data['email'] as String? ?? 'N/A';

                          return ListTile(
                            title: Text(username),
                            subtitle: Text(email),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    usernameController.text = username;
                                    emailController.text = email;
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: const Text(
                                              'Actualizar Usuario',
                                            ),
                                            content: Form(
                                              key:
                                                  formKey, // Reutiliza el formKey
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFormField(
                                                    controller:
                                                        usernameController,
                                                    decoration:
                                                        const InputDecoration(
                                                          labelText:
                                                              'Nombre de Usuario',
                                                        ),
                                                    validator:
                                                        (value) =>
                                                            (value == null ||
                                                                    value
                                                                        .isEmpty)
                                                                ? 'Campo requerido'
                                                                : null,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  TextFormField(
                                                    controller: emailController,
                                                    decoration:
                                                        const InputDecoration(
                                                          labelText: 'Email',
                                                        ),
                                                    validator:
                                                        (value) =>
                                                            (value == null ||
                                                                    value
                                                                        .isEmpty)
                                                                ? 'Campo requerido'
                                                                : null,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  usernameController.clear();
                                                  emailController.clear();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancelar'),
                                              ),
                                              ElevatedButton(
                                                onPressed:
                                                    () => submitUser(
                                                      userIdToUpdate: userId,
                                                    ), // Pasa el ID del usuario
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue,
                                                ),
                                                child: const Text('Actualizar'),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: const Text(
                                              'Confirmar eliminación',
                                            ),
                                            content: const Text(
                                              '¿Está seguro de eliminar este usuario?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: const Text('Cancelar'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  userController.deleteUser(
                                                    userId,
                                                  );
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                child: const Text('Eliminar'),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
          ],
        );
      }),
    );
  }
}
