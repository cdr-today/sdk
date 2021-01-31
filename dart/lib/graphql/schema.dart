/* GraphQL Schema */
abstract class Schema {
  final String operationName;
  final String query;
  final Map<String, dynamic> variables;

  Schema({this.query, this.variables, this.operationName});

  /* Schema to Json */
  Map<String, dynamic> toJson() {
    if (this.operationName == null) {
      return {"query": this.query, "variables": this.variables};
    } else {
      return {
        "query": this.query,
        "operationName": this.operationName,
        "variables": this.variables
      };
    }
  }
}
