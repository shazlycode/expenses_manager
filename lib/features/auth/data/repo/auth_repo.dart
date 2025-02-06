import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../../../../core/utils/sucess.dart';

abstract class AuthRepo {
  Future<Either<Failure, Success>> login(
      {required String email, required String password});
  Future<Either<Failure, Success>> register(
      {required String email, required String password});
}
