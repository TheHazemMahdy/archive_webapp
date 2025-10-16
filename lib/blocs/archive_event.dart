import '../../data/models/archive_model.dart';

abstract class ArchiveEvent {}

class LoadArchives extends ArchiveEvent {}

class AddArchive extends ArchiveEvent {
  final ArchiveModel archive;
  AddArchive(this.archive);
}

class UpdateArchive extends ArchiveEvent {
  final ArchiveModel archive;
  UpdateArchive(this.archive);
}

class DeleteArchive extends ArchiveEvent {
  final ArchiveModel archive;
  DeleteArchive(this.archive);
}
