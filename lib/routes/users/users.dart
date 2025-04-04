// import 'dart:nativewrappers/_internal/vm/lib/ffi_patch.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final int id;
  final String name;
  final int age;

  User({required this.id, required this.name, required this.age});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], name: json['name'], age: json['age']);
  }
}

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  late Future<List<User>> futureUsers;

  Future<List<User>> fetchUsers() async {
    // final response = await http.get(Uri.parse("http://localhost:6969/"));
    final response = await http.get(Uri.parse("http://192.168.100.9:6969"));
    //http://10.0.2.2:6969/

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users", textAlign: TextAlign.center),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: FutureBuilder(
          future: futureUsers,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].name),
                    subtitle: Text('Age: ${snapshot.data![index].age}'),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

// class Users extends StatelessWidget {
//   const Users({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Users", textAlign: TextAlign.center),
//         backgroundColor: Colors.blue,
//         body: FutureBuilder(future: future, builder: builder)
//       ),
//       // appBar: SliverAppBar(title: Text("Sliver title")),
//     );
//   }
// }
