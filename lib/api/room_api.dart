import 'dart:convert';
import 'package:lab_availability_checker/models/lab.dart';
import 'package:http/http.dart' as http;
import 'package:lab_availability_checker/models/room.dart';

class RoomApi {
  final client = http.Client();
  final String url = "localhost:8080";

  Future<List<Room>?> getRooms() async {
    final response = await client.get(Uri.http(url, 'room'));

    if (response.statusCode != 200) {
      return null;
    }

    final roomsBody = jsonDecode(response.body) as List;
    final List<Room> rooms = [];

    for (var value in roomsBody) {
      rooms.add(Room.fromJson(value));
    }

    return rooms;
  }
}
