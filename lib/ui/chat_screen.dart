import 'package:flutter/material.dart';
import 'package:flutter_chat_app/components/message_item.dart';
import 'package:flutter_chat_app/controllers/chat_controller.dart';
import 'package:flutter_chat_app/models/message.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final purple = Colors.purple;
  final black = Colors.black;
  final msgInputController = TextEditingController();
  late IO.Socket socket;
  final chatController = ChatController();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    connection();

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // user returned to our app
      print("resume");
      socket.connect();
    } else if (state == AppLifecycleState.inactive) {
      // app is inactive
      print("inactive");
    } else if (state == AppLifecycleState.paused) {
      // user is about quit our app temporally
      print("pause");
      socket.dispose();
    }
  }

  void connection() {
    socket = IO.io(
      'http://192.168.43.197:4000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();
    setupSocketListener();
  }

  void sendMessage(msg) {
    msgInputController.text = "";
    final message = {
      "message": msg,
      "sendByMe": socket.id,
    };
    socket.emit('message', message);
    chatController.chatMessage.add(Message.fromJson(message));
  }

  void setupSocketListener() {
    socket.on('message-receive', (data) {
      print(data);
      chatController.chatMessage.add(Message.fromJson(data));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: Obx(
              () => ListView.builder(
                  itemCount: chatController.chatMessage.length,
                  itemBuilder: (context, index) {
                    final item = chatController.chatMessage[index];

                    return MessageItem(
                      message: item.message,
                      sendByMe: item.sendByMe == socket.id,
                    );
                  }),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                cursorColor: purple,
                controller: msgInputController,
                decoration: InputDecoration(
                  suffixIcon: Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: purple,
                    ),
                    child: IconButton(
                      onPressed: () {
                        sendMessage(msgInputController.text);
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
