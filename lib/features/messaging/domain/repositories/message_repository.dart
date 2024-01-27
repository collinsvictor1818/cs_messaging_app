import '/core/entities/message.dart';
import '/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class MessageRepository {
  Future<Either<Failure, List<Message>>> getMessages();
}
