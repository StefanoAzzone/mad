
import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:async/async.dart';

enum Command
{
  image,
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
    final events = StreamQueue<dynamic>(rp);
    toWorker = await events.next;
    return true;
  }

  void shutdown() async
  {
    toWorker.send(null);
    await fromWorker.cancel();
  }
  
  dynamic getImage(String path) async {
    toWorker.send({Command.image: path});
    dynamic message = await fromWorker.next;
    return message;
  }

  Future<void> _worker(SendPort p) async {
    final commandPort = ReceivePort();
    p.send(commandPort.sendPort);
    await for (final message in commandPort) {
      if (message is Map<Command, String>) {
        dynamic res;
        switch (message.keys.first) {
          case Command.image:
            res = null;
            String? path = message[Command.image];
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


