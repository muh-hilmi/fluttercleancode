// MOCK -> profile_remote_datasource.dart

import 'dart:convert';

import 'package:fluttercleancode/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercleancode/features/profile/data/models/profile_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fluttercleancode/features/profile/data/datasources/remote_datascource.dart';

@GenerateNiceMocks(
    [MockSpec<ProfileRemoteDataSource>(), MockSpec<http.Client>()])
import 'remote_datascource_test.mocks.dart';

void main() async {
  var remoteDataSource = MockProfileRemoteDataSource();
  MockClient mockClient = MockClient();
  var remoteDataSourceImpl = ProfileRemoteDataSourceImpl(client: mockClient);

  const int userId = 1;
  const int page = 1;
  Uri urlGetAllUser = Uri.parse('https://reqres.in/api/users?page=$page');
  Uri urlGetUser = Uri.parse('https://reqres.in/api/users/$userId');

  Map<String, dynamic> fakeDataJson = {
    'id': userId,
    'email': 'user1@gmail.com',
    'first_name': 'user',
    'last_name': '1',
    'avatar': 'https://image.com/$userId',
  };

  ProfileModel fakeProfileModel = ProfileModel.fromJson(fakeDataJson);

  group('Profile Remote Data Source', () {
    group('getAllUser()', () {
      test('Berhasil', () async {
        when(remoteDataSource.getAllUser(page)).thenAnswer(
          (_) async => [fakeProfileModel],
        );

        try {
          var response = await remoteDataSource.getAllUser(page);
          expect(response, [fakeProfileModel]);
        } catch (e) {
          fail('Tidak akan terjadi error');
        }
      });

      test('Error', () async {
        when(remoteDataSource.getAllUser(page)).thenThrow(Exception());

        try {
          await remoteDataSource.getAllUser(page);
          fail('Tidak akan terjadi error');
        } catch (e) {
          expect(e, isException);
        }
      });
    });
    group('getUser()', () {
      test('Berhasil', () async {
        when(remoteDataSource.getUser(userId)).thenAnswer(
          (_) async => fakeProfileModel,
        );

        try {
          var response = await remoteDataSource.getUser(userId);
          expect(response, fakeProfileModel);
        } catch (e) {
          fail('Tidak akan terjadi error');
        }
      });

      test('Error', () async {
        when(remoteDataSource.getUser(userId)).thenThrow(Exception());

        try {
          await remoteDataSource.getUser(userId);
          fail('Tidak akan terjadi error');
        } catch (e) {
          expect(e, isException);
        }
      });
    });
  });

  group('Profile Remote Data Source Impl', () {
    group('getUser()', () {
      test('Berhasil - 200', () async {
        when(mockClient.get(urlGetUser)).thenAnswer(
          (_) async => http.Response(
            jsonEncode({
              'data': fakeDataJson,
            }),
            200,
          ),
        );

        try {
          var response = await remoteDataSourceImpl.getUser(userId);
          expect(response, fakeProfileModel);
        } catch (e) {
          fail('Tidak akan terjadi error');
        }
      });
      test('Error - 404', () async {
        when(mockClient.get(urlGetUser)).thenAnswer(
          (_) async => http.Response(
            jsonEncode({}),
            404,
          ),
        );

        try {
          await remoteDataSourceImpl.getUser(userId);
          fail('Tidak akan terjadi error');
        } on EmptyException catch (e) {
          expect(e, isException);
        } catch (e) {
          fail('Tidak akan terjadi error');
        }
      });
      test('Error - 500', () async {
        when(mockClient.get(urlGetUser)).thenAnswer(
          (_) async => http.Response(
            jsonEncode({}),
            500,
          ),
        );

        try {
          await remoteDataSourceImpl.getUser(userId);
          fail('Tidak akan terjadi error');
        } on EmptyException catch (e) {
          fail('Tidak akan terjadi error');
        } catch (e) {
          expect(e, isException);
        }
      });
    });
    group('getAllUser()', () {
      test('Berhasil - 200', () async {
        when(mockClient.get(urlGetAllUser)).thenAnswer(
          (_) async => http.Response(
            jsonEncode({
              'data': [fakeDataJson],
            }),
            200,
          ),
        );

        try {
          var response = await remoteDataSourceImpl.getAllUser(page);
          expect(response, [fakeProfileModel]);
        } on EmptyException catch (e) {
          fail('Tidak akan terjadi error');
        } on StatusCodeException catch (e) {
          fail('Tidak akan terjadi error');
        } catch (e) {
          fail('Tidak akan terjadi error');
        }
      });
      test('GAGAL - EMPTY', () async {
        when(mockClient.get(urlGetAllUser)).thenAnswer(
          (_) async => http.Response(
            jsonEncode({
              "data": [],
            }),
            200,
          ),
        );

        try {
          await remoteDataSourceImpl.getAllUser(page);
          fail('Tidak akan terjadi error');
        } on EmptyException catch (e) {
          expect(e, isException);
        } on StatusCodeException catch (e) {
          fail('Tidak akan terjadi error');
        } catch (e) {
          fail('Tidak akan terjadi error');
        }
      });
      test('Error - 404', () async {
        when(mockClient.get(urlGetAllUser)).thenAnswer(
          (_) async => http.Response(
            jsonEncode({}),
            404,
          ),
        );

        try {
          await remoteDataSourceImpl.getAllUser(page);
          fail('Tidak akan terjadi error');
        } on EmptyException catch (e) {
          fail('Tidak akan terjadi error');
        } on StatusCodeException catch (e) {
          expect(e, isException);
        } catch (e) {
          fail('Tidak akan terjadi error');
        }
      });
      test('Error - 500', () async {
        when(mockClient.get(urlGetAllUser)).thenAnswer(
          (_) async => http.Response(
            jsonEncode({}),
            500,
          ),
        );

        try {
          await remoteDataSourceImpl.getAllUser(page);
          fail('Tidak akan terjadi error');
        } on EmptyException catch (e) {
          fail('Tidak akan terjadi error');
        } on StatusCodeException catch (e) {
          fail('Tidak akan terjadi error');
        } catch (e) {
          expect(e, isException);
        }
      });
    });
  });
}
