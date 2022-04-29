
import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:mad/data.dart';

enum Command
{
  getLocalImage,
  saveImage,
  saveDatabase,
}

class Message
{
  Command command;
  late String path;
  late String database;
  late Uint8List image;

  Message(
    this.command,
  );
}

class Worker
{
  late SendPort toWorker;
  late StreamQueue<dynamic> fromWorker;
  bool initialized = false;


  static final Worker _worker = Worker._internal();

  factory Worker() {
    return _worker;
  }

  Worker._internal();

  Future<bool> initialize() async
  {
    if(!initialized)
    {
      ReceivePort rp = ReceivePort();
      await Isolate.spawn(_workerBody, rp.sendPort);
      fromWorker = StreamQueue<dynamic>(rp);
      toWorker = await fromWorker.next;
      initialized = true;
      return true;
    }
    return false;
  }

  void shutdown() async
  {
    toWorker.send(null);
    await fromWorker.cancel();
    initialized = false;
  }
  
  Future<Uint8List?> getLocalImage(String path) async {
    Message message = Message(Command.getLocalImage);
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

  void saveDatabase(String db) {
    Message message = Message(Command.saveDatabase);
    message.database = db;
    assert(database.dbPath != "");
    message.path = database.dbPath;
    toWorker.send(message);
  }

  Future<void> _workerBody(SendPort p) async {
    final commandPort = ReceivePort();
    p.send(commandPort.sendPort);
    await for (final message in commandPort) {
      if (message is Message) {
        switch (message.command) {
          case Command.getLocalImage:
            Uint8List? res;
            String path = message.path;
            File file = File(path);
            if(await file.exists())
            {
              res = await File(path).readAsBytes();
            }
            p.send(res);
            break;
          case Command.saveImage:
            String path = message.path;
            File file = File(path);
            if(!await file.exists())
            {
              await file.create();
            }
            file.writeAsBytes(message.image);
            break;
          case Command.saveDatabase:
            File file = File(message.path);
            file.writeAsString(message.database, mode: FileMode.write, flush: true);
            break;
          default:
        }
      } else if (message == null) {
        break;
      }
    }
    Isolate.exit();
  }
}


