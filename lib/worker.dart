
import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:async/async.dart';

enum Command
{
  getLocalImage,
  saveImage
}

class Message
{
  Command command;
  late String path;
  late Uint8List image;

  Message(
    this.command,
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
    Message message = Message(Command.saveImage);
    message.path = path;
    toWorker.send(message);
    Uint8List? response = await fromWorker.next;
    return response;
  }

  void saveImage(String path, Uint8List image) {
    Message message = Message(Command.saveImage);
    message.path = path;
    message.image = image;
    toWorker.send(message);
  }

  Future<void> _worker(SendPort p) async {
    final commandPort = ReceivePort();
    p.send(commandPort.sendPort);
    await for (final message in commandPort) {
      if (message is Message) {
        dynamic res;
        switch (message.command) {
          case Command.getLocalImage:
            res = null;
            String path = message.path;
            File file = File(path);
            if(await file.exists())
            {
              res = await File(path).readAsBytes();
            }
            break;
          case Command.saveImage:
            res = null;
            String path = message.path;
            File file = File(path);
            if(!await file.exists())
            {
              await file.create();
            }
            file.writeAsBytes(message.image);
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


