// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:newflutter/components/forms.dart';
import 'components/custom_card.dart';
import 'components/counter_state.dart';
// import 'routes/about.dart';
// import 'routes/products/products.dart';
// import 'routes/users/main.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql/graphql_service.dart';
import 'routes/items/items.dart';
// // import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:hive_flutter/hive_flutter.dart'; // Import hive_flutter

void main() async {
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return graphQLProvider(
//       MaterialApp(
//         home: Home(),
//         // initialRoute: "/users",
//         // routes: {
//         //   "/": (ctx) => Home(),
//         //   // "/about": (ctx) => About(),
//         //   // "/products": (ctx) => Products(),
//         //   "/users": (ctx) => Users(),
//         // },
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphQLService.client,
      child: MaterialApp(
        // home: ItemListScreen(),
        home: Home(),
        routes: {
          "/items": (ctx) => ItemListScreen(),
          "/item": (ctx) => ItemById(),
        },
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext build) {
    return Container(
      margin: EdgeInsets.only(top: 80, bottom: 60, left: 24, right: 24),
      child: Column(
        spacing: 18,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Global Partners",
            style: TextStyle(
              letterSpacing: -2.5,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
              fontSize: 40,
            ),
          ),
          Text(
            "Agency that build many amazing product\nto boost your business to next level",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class Card2BottomRightWidgetBar extends StatelessWidget {
  final double height;
  final Color color;
  const Card2BottomRightWidgetBar({
    required this.height,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("This is my app"),
      //   backgroundColor: Colors.transparent,
      // ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple[100]!, Colors.blue[200]!],
            ),
          ),
          // This is the body
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // List of elements inside
            spacing: 4,
            children: [
              Header(),
              CustomCard(
                headerText: "Companies\nJoined us",
                hightlightText: "300+",
                bottomRightWidget: Stack(
                  clipBehavior: Clip.none,
                  // alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    Positioned(
                      child: Container(
                        height: 45,
                        width: 45,
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            "assets/tina.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 30,
                      child: Container(
                        height: 45,
                        width: 45,
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            "assets/tina.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 60,
                      child: Container(
                        height: 45,
                        width: 45,
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            "assets/tina.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CustomCard(
                headerText: "Exclusive\nBudget 55,000",
                hightlightText: "45M",
                bottomRightWidget: Row(
                  spacing: 6,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Card2BottomRightWidgetBar(height: 25, color: Colors.red),
                    Card2BottomRightWidgetBar(height: 35, color: Colors.black),
                    Card2BottomRightWidgetBar(height: 17, color: Colors.red),
                    Card2BottomRightWidgetBar(height: 25, color: Colors.black),
                    Card2BottomRightWidgetBar(height: 15, color: Colors.red),
                    Card2BottomRightWidgetBar(height: 30, color: Colors.black),
                    Card2BottomRightWidgetBar(height: 25, color: Colors.red),
                    Card2BottomRightWidgetBar(height: 35, color: Colors.black),
                    Card2BottomRightWidgetBar(height: 15, color: Colors.red),
                    Card2BottomRightWidgetBar(height: 35, color: Colors.black),
                  ],
                ),
              ),
              CustomCard(
                headerText: "Inventing the future\nof design",
                hightlightText: "X.X",
                bottomRightWidget: Container(width: 100, height: 100),
              ),

              // Body
              Text(" IMMA TEXT"),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/items");
                    },
                    child: Text("Items"),
                  ),
                ],
              ),
              CounterState(),
              FormInput(),
            ],
          ),
        ),
      ),
    );
  }
}
