/* Wrapper of http client */
import 'dart:async';
import 'dart:convert';
import 'package:cdr_today_sdk/pair.dart';
import 'package:cdr_today_sdk/api/host.dart';
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
      "cdr-today-address": this._pair.address(),
    };
  }

  // Recur Get
  Future<http.Response> get(String url) async {
    try {
      return await this
          ._client
          .get(url, headers: this.headers)
          .timeout(this.timeout);
    } on TimeoutException catch (_) {
      await this._host.fast(this._client);
      return await this.get(url);
    }
  }

  // Recur Post
  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    try {
      return await this
          ._client
          .post(
            url,
            body: body,
            headers: this.headers,
          )
          .timeout(this.timeout);
    } on TimeoutException catch (_) {
      await this._host.fast(this._client);
      return await this.post(url, body);
    }
  }

  /* Get auth token */
  Future<void> auth() async {
    await this._host.fast(this._client);
    http.Response resp = await this.get(this._host.host);
    if (resp.statusCode == 200) {
      return;
    }

    String uuid = resp.headers["cdr-today-uuid"];
    if (uuid != null) {
      List<int> bytes = utf8.encode(uuid);
      String signature = this._pair.sign(bytes);
      this.headers.update("cdr-today-uuid", (String _) => uuid,
          ifAbsent: () => uuid);
      this.headers.update("cdr-today-token", (String _) => signature,
          ifAbsent: () => signature);
    }

    print(this.headers);
    resp = await this.get(this._host.host);
    print(resp.body);
  }
}

void main() async {
  Client client = Client(Pair(), ["http://0.0.0.0:3000/graphql"]);
  await client.auth();
}
