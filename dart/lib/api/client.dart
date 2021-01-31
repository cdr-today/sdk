/* Wrapper of http client */
import 'dart:async';
import 'dart:convert';
import 'package:cdr_today_sdk/pair.dart';
import 'package:cdr_today_sdk/api/host.dart';
import 'package:cdr_today_sdk/graphql/ping.gql.dart';
import 'package:http/http.dart' as http;

class Client {
  final Duration timeout;
  final Pair _pair;

  Host _host;
  http.Client _client;
  Map<String, String> headers;

  // Constructor
  Client(this._pair, List<String> host,
      {this.timeout = const Duration(seconds: 5)}) {
    this._client = http.Client();
    this._host = Host(host, this.timeout);

    // Set basic header
    this.headers = {
      'accept': 'application/json',
      'content-type': 'application/json',
      'cdr-today-address': this._pair.address(),
    };
  }

  // Recur Post
  Future<http.Response> query(Map<String, dynamic> body) async {
    try {
      return await this
          ._client
          .post(
            this._host.host,
            body: utf8.encode(jsonEncode(body)),
            headers: this.headers,
          )
          .timeout(this.timeout);
    } on TimeoutException catch (_) {
      await this._host.fast(this._client);
      return await this.query(body);
    }
  }

  /* Get auth token */
  Future<void> auth() async {
    await this._host.fast(this._client);
    Map<String, dynamic> query = PingQuery().toJson();
    http.Response resp = await this.query(query);
    if (resp.statusCode == 200) {
      return;
    }

    String uuid = resp.headers['cdr-today-uuid'];
    if (uuid != null) {
      List<int> bytes = utf8.encode(uuid);
      String signature = this._pair.sign(bytes);

      this.headers.addAll({
        'cdr-today-uuid': uuid,
        'cdr-today-token': signature,
      });
    }

    // Ping - Pong
    resp = await this.query(query);
    if (resp.statusCode == 200 && Ping.from(resp).ping == 'pong') {
      return;
    } else {
      await this._host.fast(this._client);
      return await this.auth();
    }
  }
}


