/* GraphQL Schema */
abstract class Schema {
  final String operationName;
  final String query;
  final Map<String, dynamic> variables;

  Schema({this.query, this.variables, this.operationName})
      : assert(query != null);

  /* Schema to Json */
  Map<String, dynamic> toJson() {
    Map<String, dynamic> query = {
      "query": this.query,
    };

    // add variables
    if (this.variables != null) {
      query.addAll({
        "variables": this.variables,
      });
    }

    // add operation name
    if (this.operationName != null) {
      query.addAll({
        "operationName": this.operationName,
      });
    }

    return query;
  }
}
