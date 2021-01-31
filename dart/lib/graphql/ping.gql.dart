import "package:cdr_today_sdk/graphql/schema.dart";

final String QUERY = r'''
query auth {
  ping
}
''';

class PingQuery extends Schema {
  get operationName => null;
  get query => QUERY;

  PingQuery();
}

