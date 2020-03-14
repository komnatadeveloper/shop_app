

class HttpMyException implements Exception {

  final String message;

  HttpMyException(this.message);

  @override
  String toString() {

    return message;
    // TODO: implement toString
    // return super.toString();
  }
}