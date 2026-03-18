import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';

import '../../../../core/api/http_client.dart';

part 'file_provider.g.dart';

/// Represents an uploaded attachment returned from the server.
class UploadedFile {
  const UploadedFile({
    required this.id,
    required this.name,
    required this.mimeType,
    required this.url,
    this.sizeBytes,
  });

  final String id;
  final String name;
  final String mimeType;
  final String url;
  final int? sizeBytes;

  bool get isImage =>
      mimeType.startsWith('image/') &&
      (mimeType.contains('jpeg') ||
          mimeType.contains('jpg') ||
          mimeType.contains('png') ||
          mimeType.contains('gif') ||
          mimeType.contains('webp'));

  factory UploadedFile.fromJson(Map<String, dynamic> json) => UploadedFile(
        id: json['id'] as String,
        name: json['name'] as String,
        mimeType: json['mimeType'] as String,
        url: json['url'] as String,
        sizeBytes: json['sizeBytes'] as int?,
      );
}

/// Upload progress state for a single file.
class FileUploadState {
  const FileUploadState({
    this.file,
    this.progress = 0.0,
    this.isUploading = false,
    this.uploaded,
    this.error,
  });

  final PlatformFile? file;
  final double progress;
  final bool isUploading;
  final UploadedFile? uploaded;
  final String? error;

  bool get isDone => uploaded != null;
  bool get hasError => error != null;
}

/// Manages pending file uploads for the current composer session.
@riverpod
class FileUploadQueue extends _$FileUploadQueue {
  @override
  List<FileUploadState> build() => const [];

  /// Adds a file to the queue and begins uploading it.
  Future<UploadedFile?> upload({
    required PlatformFile file,
    required String channelId,
  }) async {
    final entry = FileUploadState(file: file, isUploading: true);
    final index = state.length;
    state = [...state, entry];

    try {
      final dio = ref.read(httpClientProvider);
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path!,
          filename: file.name,
        ),
        'channelId': channelId,
      });

      final response = await dio.post<Map<String, dynamic>>(
        '/files',
        data: formData,
        onSendProgress: (sent, total) {
          if (total > 0) {
            _updateAt(index, state[index].copyWith(progress: sent / total));
          }
        },
      );

      final uploaded = UploadedFile.fromJson(response.data!);
      _updateAt(index, FileUploadState(uploaded: uploaded));
      return uploaded;
    } catch (e) {
      _updateAt(
        index,
        FileUploadState(file: file, error: e.toString()),
      );
      return null;
    }
  }

  void removeAt(int index) {
    final list = [...state];
    list.removeAt(index);
    state = list;
  }

  void clear() => state = const [];

  void _updateAt(int index, FileUploadState newState) {
    if (index >= state.length) return;
    final list = [...state];
    list[index] = newState;
    state = list;
  }
}

extension on FileUploadState {
  FileUploadState copyWith({double? progress}) => FileUploadState(
        file: file,
        progress: progress ?? this.progress,
        isUploading: isUploading,
        uploaded: uploaded,
        error: error,
      );
}
