/* GraphQL Client */
import 'package:cdr_today_sdk/pair.dart';
import 'package:cdr_today_sdk/api/client.dart';

/* GraphQL API */
class Api {
  final Duration timeout;
  String token;
  Client client;

  Api({this.timeout = const Duration(seconds: 5)});

  init(List<String> host, Pair pair) async {
    this.client = Client(pair, host);
    // this.host = Host(host, this.timeout);
    // await this.host.fast(this.client);
    // this.token = await this.host.auth(this.client, pair);
  }
}
