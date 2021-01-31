/* GraphQL Client */
import 'package:cdr_today_sdk/pair.dart';
import 'package:cdr_today_sdk/api/client.dart';
import 'package:cdr_today_sdk/graphql/ping.gql.dart';

/* GraphQL API */
class Api {
  final Duration timeout;
  String token;
  Client client;

  Api({this.timeout = const Duration(seconds: 5)});

  init(Pair pair, List<String> host) async {
    this.client = Client(pair, host, timeout: this.timeout);
  }

  /* Ping pong */
  Future<Ping> ping() async {
    return Ping.from(await this.client.query(PingQuery().toJson()));
  }
}
