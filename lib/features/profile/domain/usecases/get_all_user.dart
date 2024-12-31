import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/profile.dart';
import '../repositories/profile_repo.dart';

class GetAllUser {
  final ProfileRepo profileRepo;

  const GetAllUser(this.profileRepo);

  Future<Either<Failure, List<Profile>>> execute(int page) async {
    return await profileRepo.getAllUser(page);
  }
}
