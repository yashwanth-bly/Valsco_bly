import 'dart:io';

import 'package:core/core.dart';

part 'image_upload_state.dart';

class ImageUploadCubit extends Cubit<ImageUploadState> {
  ImageUploadCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(ImageUploadInitial());
  final AuthRepository _authRepository;

  Future<void> uploadImage(File file) async {
    emit(ImageUploading());
    try {
      await _authRepository.uploadImage(file);
      emit(ImageUploaded());
    } catch (e) {
      print(e);
      emit(ImageUploadError());
    }
  }
}
