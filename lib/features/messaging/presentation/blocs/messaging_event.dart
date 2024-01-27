
// messaging_event.dart
import 'package:equatable/equatable.dart';
// part of 'messaging_bloc.dart';

abstract class MessagingEvent extends Equatable {
  const MessagingEvent();
}

class LoadMessages extends MessagingEvent {
  @override
  List<Object?> get props => [];
}

// messaging_state.dart

abstract class MessagingState extends Equatable {
  const MessagingState();
}

class MessagingInitial extends MessagingState {
  @override
  List<Object?> get props => [];
}

class MessagingLoading extends MessagingState {
  @override
  List<Object?> get props => [];
}

class MessagingError extends MessagingState {
  final String message;

  const MessagingError({required this.message});

  @override
  List<Object?> get props => [message];
}
// messaging_bloc.dart
class MessagingLoaded extends MessagingState {
  final List<String> messages; // Change the type here to String

  const MessagingLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];
}
