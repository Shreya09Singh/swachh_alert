import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class ReportModel extends HiveObject {
  @HiveField(0)
  String imageUrl;

  @HiveField(1)
  String location;

  @HiveField(2)
  String description;

  ReportModel({
    required this.imageUrl,
    required this.location,
    required this.description,
  });
}
