import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> imagePicker(BuildContext context) async {
  File? image;
  try {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (photo != null) {
      image = File(photo.path);
    }
  } on Exception catch (e) {
    throw Exception(e);
  }

  return image;
}

Future<File?> pickImageFromGallerymob(BuildContext context) async {
  File? selected;
  try {
    final pickedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedimage != null) {
      selected = File(pickedimage.path);
    }
  } catch (e) {
    throw e.toString();
    // showsnackbar(context: context, content: e.toString());
  }
  return selected;
}
