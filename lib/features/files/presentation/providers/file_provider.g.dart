// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fileUploadQueueHash() => r'ca2c3689a2a8a8a97164b072b42b046caa1ade89';

/// Manages pending file uploads for the current composer session.
///
/// Copied from [FileUploadQueue].
@ProviderFor(FileUploadQueue)
final fileUploadQueueProvider = AutoDisposeNotifierProvider<FileUploadQueue,
    List<FileUploadState>>.internal(
  FileUploadQueue.new,
  name: r'fileUploadQueueProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fileUploadQueueHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FileUploadQueue = AutoDisposeNotifier<List<FileUploadState>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
