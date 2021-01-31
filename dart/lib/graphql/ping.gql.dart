import 'dart:convert';
import 'package:http/http.dart';
import "package:cdr_today_sdk/graphql/schema.dart";

final String QUERY = r'''
query auth {
  ping
}
''';

/* Ping Query */
class PingQuery extends Schema {
  get query => QUERY;

  PingQuery();
}

/* Ping Result */
class Ping {
  String ping;

  Ping(this.ping);

  factory Ping.from(Response resp) {
    return Ping(jsonDecode(resp.body)['data']['ping'] as String);
  }
}
