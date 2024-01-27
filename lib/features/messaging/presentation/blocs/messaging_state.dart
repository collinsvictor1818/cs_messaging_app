part of 'messaging_bloc.dart';

abstract class MessagingState {}

class MessagingInitial extends MessagingState {}

class MessagingLoading extends MessagingState {}



class MessagingError extends MessagingState {
  final String message;

  MessagingError({required this.message});
}
