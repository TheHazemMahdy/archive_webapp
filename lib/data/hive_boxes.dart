import 'package:hive/hive.dart';
import 'models/archive_model.dart';

class HiveBoxes {
  static Box<ArchiveModel> getArchives() =>
      Hive.box<ArchiveModel>('archives');
}
