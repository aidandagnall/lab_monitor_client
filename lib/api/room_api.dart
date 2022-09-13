import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lab_availability_checker/models/room.dart';
import 'package:lab_availability_checker/util/constants.dart';

class RoomApi {
  final client = http.Client();

  Future<List<Room>?> getRooms(String token) async {
    final response = await client.get(Uri.http(Constants.API_URL, 'room'),
        headers: {HttpHeaders.authorizationHeader: token});

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
