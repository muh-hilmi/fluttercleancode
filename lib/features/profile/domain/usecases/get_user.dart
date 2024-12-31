import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/profile.dart';
import '../repositories/profile_repo.dart';

class GetUser {
  final ProfileRepo profileRepo;

  GetUser(this.profileRepo);

  Future<Either<Failure, Profile>> execute(int id) async {
    return await profileRepo.getUser(id);
  }
}
