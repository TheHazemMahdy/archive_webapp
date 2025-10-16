import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/archive_model.dart';
import '../../data/repositories/archive_repository.dart';
import 'archive_event.dart';
import 'archive_state.dart';

class ArchiveBloc extends Bloc<ArchiveEvent, ArchiveState> {
  final ArchiveRepository _repository;

  ArchiveBloc(this._repository) : super(const ArchiveState()) {
    on<LoadArchives>(_onLoad);
    on<AddArchive>(_onAdd);
    on<UpdateArchive>(_onUpdate);
    on<DeleteArchive>(_onDelete);
  }

  Future<void> _onLoad(LoadArchives event, Emitter<ArchiveState> emit) async {
    emit(state.copyWith(isLoading: true));
    final archives = await _repository.getArchives();
    emit(state.copyWith(archives: archives, isLoading: false));
  }

  Future<void> _onAdd(AddArchive event, Emitter<ArchiveState> emit) async {
    emit(state.copyWith(isLoading: true));
    await _repository.addArchive(event.archive);
    final archives = await _repository.getArchives();
    emit(state.copyWith(archives: archives, isLoading: false));
  }

  Future<void> _onUpdate(UpdateArchive event, Emitter<ArchiveState> emit) async {
    emit(state.copyWith(isLoading: true));
    await _repository.updateArchive(event.archive);
    final archives = await _repository.getArchives();
    emit(state.copyWith(archives: archives, isLoading: false));
  }

  Future<void> _onDelete(DeleteArchive event, Emitter<ArchiveState> emit) async {
    emit(state.copyWith(isLoading: true));
    await _repository.deleteArchive(event.archive);
    final archives = await _repository.getArchives();
    emit(state.copyWith(archives: archives, isLoading: false));
  }
}
