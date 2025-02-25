import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

//1. Provider
final apiProvider = FutureProvider.autoDispose<User>((ref) async {
  final user = await RandomUserService.shared.getRandom();
  return user;
});

//2. Consumer

class RandomUserScreen extends StatelessWidget {
  const RandomUserScreen({super.key});

  @override
  Widget build(Object context) {
    return Center(
      child: Consumer(builder: (context, ref, child) {
        final apiUser = ref.watch(apiProvider);
        return apiUser.when(
          data: (user) => CardUser(
            user: user,
          ),
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        );
      }),
    );
  }
}

//3. Logique

class CardUser extends StatelessWidget {
  final User user;
  const CardUser({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 10,
      child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(backgroundImage: NetworkImage(user.picture.large), radius: 64),
              Text(user.name.fullName, style: Theme.of(context).textTheme.headlineMedium,),
              const Divider(),
              Text("${user.location.street}, ${user.location.city},", style: Theme.of(context).textTheme.titleSmall,),
              Text("${user.location.state}, ${user.location.country}", style: Theme.of(context).textTheme.titleMedium,),
              const Divider(),
              infos(Icons.email, user.email),
              infos(Icons.phone, user.phone),
              infos(Icons.phone_android, user.cell),
           
            ],
          )),
    );
  }
}

Widget infos(IconData iconData, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.max,
    children: [
      Icon(iconData, color: Colors.blueGrey),
      const SizedBox(width: 16),
      Text(value, style: const TextStyle(color: Colors.blueGrey,),),      
    ],
  );
}

class RandomUserService {
  static final shared = RandomUserService();
  final String urlString = "https://randomuser.me/api/";

  Future<User> getRandom() async {
    final Uri url = Uri.parse(urlString);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonDecoded = json.decode(response.body);
      final List<dynamic> results = jsonDecoded["results"];
      if (results.isNotEmpty) {
        final Map<String, dynamic> userJson = results.first;
        final User user = User.fromJson(userJson);
        return user;
      } else {
        throw Exception("Impossible de récupérer l'utilisateur");
      }
    } else {
      throw Exception("Impossible de récupérer l'utilisateur");
    }
  }
}

//4. Models

class User {
  final String? _gender;
  final Name _name;
  final Location _location;
  final String _email;
  final String _phone;
  final String _cell;
  final Picture _picture;

  String get gender => _gender ?? "";
  Picture get picture => _picture;
  Name get name => _name;
  Location get location => _location;
  String get email => _email;
  String get cell => _cell;
  String get phone => _phone;

  User.fromJson(Map<String, dynamic> json)
      : _gender = json["gender"] as String,
        _name = Name.fromJson(json['name']),
        _location = Location.fromJson(json["location"]),
        _email = json["email"] ?? "",
        _phone = json["phone"] ?? "",
        _cell = json["cell"] ?? "",
        _picture = Picture.fromJson(json["picture"]);
}

class Name {
  final String? _title;
  final String? _first;
  final String? _last;

  String get title => _title ?? "";
  String get first => _first ?? "";
  String get last => _last ?? "";
  String get fullName => "$title $first $last";

  Name.fromJson(Map<String, dynamic> json)
      : _title = json["name"],
        _first = json["first"],
        _last = json["last"];
}

class DOB {
  final String? _date;
  final int? _age;

  String get date => _date ?? "";
  int get age => _age ?? 0;

  DOB.fromJson(Map<String, dynamic> json)
      : _date = json["date"],
        _age = json["age"];
}

class Location {
  final String? _streetName;
  final dynamic _streetNumber;
  final String? _city;
  final String? _state;
  final String? _country;
  final dynamic _postcode;
  final Map<String, dynamic> _coordinates;

  String get street => "${(_streetNumber == null) ? "" : _streetNumber.toString()} ${_streetName ?? ""}";
  String get city => _city ?? "";
  String get state => _state ?? "";
  String get country => _country ?? "";
  String get postcode => _postcode;
  Map<String, dynamic> get coordinates => _coordinates;

  Location.fromJson(Map<String, dynamic> json)
      : _streetName = json["street"]["name"],
        _streetNumber = json["street"]["number"],
        _city = json["city"],
        _state = json["state"],
        _country = json["country"],
        _postcode = json["postcode"],
        _coordinates = json["coordinates"];
}

class Picture {
  final String? _large;
  final String? _medium;
  final String? _thumbnail;

  String get thumb => _thumbnail ?? "";
  String get medium => _medium ?? "";
  String get large => _large ?? "";

  Picture.fromJson(Map<String, dynamic> json)
      : _large = json["large"],
        _medium = json["medium"],
        _thumbnail = json["thumbnail"];
}
