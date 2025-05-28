import 'package:appturismo/core/constants/appwrite_constants.dart';
import 'package:appwrite/appwrite.dart';

final Client client =
    Client()
      ..setEndpoint(AppwriteConstants.endpoint)
      ..setProject(AppwriteConstants.projectId)
      ..setSelfSigned(status: true);
