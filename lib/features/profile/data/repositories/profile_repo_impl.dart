import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:fluttercleancode/core/error/failure.dart';
import 'package:fluttercleancode/features/profile/data/datasources/local_datascource.dart';
import 'package:fluttercleancode/features/profile/data/datasources/remote_datascource.dart';
import 'package:fluttercleancode/features/profile/data/models/profile_model.dart';
import 'package:fluttercleancode/features/profile/domain/entities/profile.dart';
import 'package:fluttercleancode/features/profile/domain/repositories/profile_repo.dart';
import 'package:hive/hive.dart';

class ProfileRepoImpl extends ProfileRepo {
  final ProfileLocalDataSource localDataSource;
  final ProfileRemoteDataSource remoteDataSource;
  final HiveInterface hive;

  ProfileRepoImpl(
    this.localDataSource,
    this.remoteDataSource,
    this.hive,
  );

  @override
  Future<Either<Failure, List<Profile>>> getAllUser(int page) async {
    try {
      //check internet
      final List<ConnectivityResult> connectivityResult =
          await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        //get data from local
        List<ProfileModel> hasil = await localDataSource.getAllUser(page);
        return Right(hasil);
      } else {
        //get data from api
        List<ProfileModel> hasil = await remoteDataSource.getAllUser(page);

        //put last data to local
        var box = hive.box('profileBox');
        box.put('getAllUser', hasil);
        return Right(hasil);
      }
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, Profile>> getUser(int id) async {
    try {
      //check internet
      final List<ConnectivityResult> connectivityResult =
          await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        //get data from local
        ProfileModel hasil = await localDataSource.getUser(id);
        return Right(hasil);
      } else {
        //get data from api
        ProfileModel hasil = await remoteDataSource.getUser(id);

        //put last data to local
        var box = hive.box('profileBox');
        box.put('getUser', hasil); 
        return Right(hasil);
      }
    } catch (e) {
      return Left(Failure());
    }
  }
}
