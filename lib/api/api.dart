import 'package:lab_availability_checker/util/constants.dart';

class UriFactory {
  static Uri getRoute(String endpoint) {
    if (Constants.DEBUG) {
      return Uri.http(Constants.AUTHORITY, Constants.PATH + endpoint);
    }
    return Uri.https(Constants.AUTHORITY, Constants.PATH + endpoint);
  }
}
