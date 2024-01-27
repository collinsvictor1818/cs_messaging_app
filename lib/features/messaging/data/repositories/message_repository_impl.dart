import '/core/entities/message.dart';
import '/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repositories/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  @override
  Future<Either<Failure, List<Message>>> getMessages() async {
    // Implement fetching messages logic
    // Example: return Right<List<Message>>([Message(...), Message(...)]);
    throw UnimplementedError();
  }
}
