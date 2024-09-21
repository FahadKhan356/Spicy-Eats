import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:spicy_eats/main.dart';

Future<File?> pickimage() async {
  ImagePicker picker = await ImagePicker();
  File? image;
  final photo = await picker.pickImage(source: ImageSource.gallery);
  if (photo != null) {
    image = File(photo.path);
  }
  return image;
}

Future<String?> uploadImage(File? file) async {
  final publicUrlResponse;
  try {
    final userid = supabaseClient.auth.currentUser!.id;
    await supabaseClient.storage
        .from('restaurant_register_photos')
        .upload('/$userid/photos', file!);

    publicUrlResponse = supabaseClient.storage
        .from('restaurant_register_photos')
        .getPublicUrl('/$userid/photos');
  } catch (e) {
    throw Exception(e.toString());
  }

  return publicUrlResponse.data;
}
