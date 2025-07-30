import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:spicy_eats/main.dart';

Future<File?> pickimage() async {
  ImagePicker picker = ImagePicker();
  File? image;
  final photo = await picker.pickImage(source: ImageSource.gallery);
  if (photo != null) {
    image = File(photo.path);
  }
  return image;
}

Future<String?> uploadImageToSupabaseStorage(
    {required File? file,
    required String folderName,
    required String imagePath}) async {
  final String publicUrlResponse;
  try {
    await supabaseClient.storage.from(folderName).upload(imagePath, file!);
    publicUrlResponse =
        supabaseClient.storage.from(folderName).getPublicUrl(imagePath);
  } catch (e) {
    throw Exception(e.toString());
  }

  return publicUrlResponse;
}
