import '/core/entities/message.dart';
import '/core/errors/failures.dart';
import '/features/messaging/domain/repositories/message_repository.dart';
import 'package:dartz/dartz.dart';

class GetMessages {
  final MessageRepository repository;

  GetMessages(this.repository);

  Future<Either<Failure, List<Message>>> call() async {
    return repository.getMessages();
  }
}
