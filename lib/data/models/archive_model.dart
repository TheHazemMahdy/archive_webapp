import 'package:hive/hive.dart';

part 'archive_model.g.dart';

@HiveType(typeId: 0)
class ArchiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String lastUpdated;

  @HiveField(3)
  String capacity;

  @HiveField(4)
  String? notes;

  @HiveField(5)
  String status;

  ArchiveModel({
    required this.id,
    required this.name,
    required this.lastUpdated,
    required this.capacity,
    this.notes,
    required this.status,
  });
}
