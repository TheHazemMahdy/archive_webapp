import '../../data/models/archive_model.dart';

class ArchiveState {
  final List<ArchiveModel> archives;
  final bool isLoading;

  const ArchiveState({
    this.archives = const [],
    this.isLoading = false,
  });

  ArchiveState copyWith({
    List<ArchiveModel>? archives,
    bool? isLoading,
  }) {
    return ArchiveState(
      archives: archives ?? this.archives,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
