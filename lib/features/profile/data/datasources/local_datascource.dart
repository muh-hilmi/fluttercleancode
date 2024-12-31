import 'package:hive/hive.dart';

import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<List<ProfileModel>> getAllUser(int page);
  Future<ProfileModel> getUser(int id);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final HiveInterface hive;

  ProfileLocalDataSourceImpl({required this.hive});

  @override
  Future<List<ProfileModel>> getAllUser(int page) {
    var box = hive.box('profileBox');
    return box.get('getAllUser');
  }

  @override
  Future<ProfileModel> getUser(int id) async {
    var box = hive.box('profileBox');
    return box.get('getUser');
  }
}
