import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<List<ProfileModel>> getAllUser(int page);
  Future<ProfileModel> getUser(int id);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;

  ProfileRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProfileModel>> getAllUser(int page) async {
    //https://reqres.in/api/users?page=1
    Uri url = Uri.parse('https://reqres.in/api/users?page=$page');
    var response = await client.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> users = data['data'];
      if (users.isEmpty)
        throw const EmptyException(message: 'Error empty data');
      return ProfileModel.fromJsonList(users);
    } else if (response.statusCode == 404) {
      throw const StatusCodeException(message: 'Data not found - 404');
    } else {
      throw const GeneralException(message: 'Cannot get data');
    }
  }

  @override
  Future<ProfileModel> getUser(int id) async {
    //https://reqres.in/api/users/1
    Uri url = Uri.parse('https://reqres.in/api/users/$id');
    var response = await client.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> dataBody = jsonDecode(response.body);
      Map<String, dynamic> data = dataBody['data'];
      return ProfileModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw const EmptyException(message: 'Data not found');
    } else {
      throw const GeneralException(message: 'Cannot get data');
    }
  }
}
