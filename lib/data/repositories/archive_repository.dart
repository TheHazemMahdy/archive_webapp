import 'package:hive_flutter/hive_flutter.dart';
import '../models/archive_model.dart';

class ArchiveRepository {
  final String boxName = 'archives';

  Future<List<ArchiveModel>> getArchives() async {
    final box = await Hive.openBox<ArchiveModel>(boxName);
    return box.values.toList();
  }

  Future<void> addArchive(ArchiveModel archive) async {
    final box = await Hive.openBox<ArchiveModel>(boxName);
    await box.put(archive.id, archive);
  }

  Future<void> updateArchive(ArchiveModel archive) async {
    final box = await Hive.openBox<ArchiveModel>(boxName);
    await box.put(archive.id, archive);
  }

  Future<void> deleteArchive(ArchiveModel archive) async {
    final box = await Hive.openBox<ArchiveModel>(boxName);
    await box.delete(archive.id);
  }
}
