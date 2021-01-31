import 'dart:async';
import 'package:http/http.dart';

/* Host */
class Host {
  final List<String> _hosts;
  final Duration timeout;

  String host;
  int id;

  Host(this._hosts, this.timeout) {
    this.host = this._hosts[0];
    this.id = 0;
  }

  /* Change to the fast host */
  Future<void> fast(Client client) async {
    int id = this.id;
    Duration elapsed = Duration(seconds: 0);
    for (int i = 0; i < this._hosts.length; i++) {
      try {
        Stopwatch t = Stopwatch()..start();
        await client.get(this._hosts[id]).timeout(this.timeout);
        if (t.elapsed < elapsed) {
          this.id = id;
          this.host = this._hosts[id];
        }
      } on Exception catch (_) {
        if (this.id < this._hosts.length) {
          this.id += 1;
        } else {
          this.id = 0;
        }
        continue;
      }
    }
  }
}
