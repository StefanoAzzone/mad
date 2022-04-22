
import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:async/async.dart';

enum Command
{
  image,
}

class Message
{
  Command command;
  dynamic body;

  Message(
    this.command,
    this.body
  );
}

class Worker
{
  late SendPort toWorker;
  late StreamQueue<dynamic> fromWorker;

  Worker();

  Future<bool> initialize() async
  {
    ReceivePort rp = ReceivePort();
    await Isolate.spawn(_worker, rp.sendPort);
    fromWorker = StreamQueue<dynamic>(rp);
    toWorker = await fromWorker.next;
    return true;
  }

  void shutdown() async
  {
    toWorker.send(null);
    await fromWorker.cancel();
  }
  
  Future<Uint8List?> getLocalImage(String path) async {
    toWorker.send(Message(Command.image, path));
    Uint8List? message = await fromWorker.next;
    return message;
  }

  Future<void> _worker(SendPort p) async {
    final commandPort = ReceivePort();
    p.send(commandPort.sendPort);
    await for (final message in commandPort) {
      if (message is Message) {
        dynamic res;
        switch (message.command) {
          case Command.image:
            res = null;
            String? path = message.body;
            if(path != null)
            {
              File file = File(path);
              if(await file.exists())
              {
                res = await File(path).readAsBytes();
              }
            }
            break;
          default:
        }
        p.send(res);
      } else if (message == null) {
        break;
      }
    }
    Isolate.exit();
  }
}


