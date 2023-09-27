part of 'image_upload_cubit.dart';

abstract class ImageUploadState extends Equatable {
  const ImageUploadState();
}

class ImageUploadInitial extends ImageUploadState {
  @override
  List<Object> get props => [];
}

class ImageUploading extends ImageUploadState {
  @override
  List<Object> get props => [];
}

class ImageUploaded extends ImageUploadState {
  @override
  List<Object> get props => [];
}

class ImageUploadError extends ImageUploadState {
  @override
  List<Object> get props => [];
}
