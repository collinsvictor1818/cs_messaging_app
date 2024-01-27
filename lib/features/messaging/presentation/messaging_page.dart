import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/messaging/presentation/blocs/messaging_bloc.dart';

import '../../../core/usecases/get_messages.dart';
import '../data/repositories/message_repository_impl.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CS Messaging App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MessagingPage(),
    );
  }
}

class MessagingPage extends StatefulWidget {
  final String? username; // Add this line

  const MessagingPage({super.key, 
    this.username, // Add this line
  });

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}


class _MessagingPageState extends State<MessagingPage> {
  @override
  Widget build(BuildContext context) {
    final getMessages = GetMessages(MessageRepositoryImpl());
    final messagingBloc = MessagingBloc(getMessages);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messaging Page'),
      ),
      body: BlocProvider(
        create: (context) => messagingBloc,
        child: const MessagingContent(),
      ),
    );
  }
}

  
class MessagingContent extends StatelessWidget {
  const MessagingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Assuming GetMessages constructor requires MessageRepository
        final getMessages = GetMessages(MessageRepositoryImpl());
        return MessagingBloc(getMessages);
      },
      child: const MessagingPage(), // Replace with your actual widget
    );
  }
}