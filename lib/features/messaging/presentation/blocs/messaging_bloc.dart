import 'package:bloc/bloc.dart';
import '/core/errors/failures.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/entities/message.dart';
import '../../../../core/usecases/get_messages.dart';
import 'messaging_event.dart';

// part of 'messaging_bloc.dart';
// messaging_bloc.dart

@injectable
class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  final GetMessages getMessages;
  MessagingBloc(this.getMessages) : super(MessagingInitial());
  @override
  Stream<MessagingState> mapEventToState(MessagingEvent event) async* {
    if (event is LoadMessages) {
      yield* _mapLoadMessagesToState();
    }
    // Handle more events as needed
  }

  Stream<MessagingState> _mapLoadMessagesToState() async* {
    yield MessagingLoading();
    final result = await getMessages();

    yield result.fold(
      (failure) => MessagingError(message: _mapFailureToMessage(failure)),
      (messages) => MessagingLoaded(messages: messages),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server Error';
    } else if (failure is NetworkFailure) {
      return 'Network Error';
    }
    return 'Unexpected Error';
  }
}class MessagingLoaded extends MessagingState {
  final List<String> messages;

  MessagingLoaded({required List<Message> messages})
      : messages = messages.map((message) => message.toString()).toList();

  @override
  List<Object?> get props => [messages];
}