import 'package:flutter/material.dart';
// import 'package:newflutter/auth/auth_actions.dart';
import 'package:newflutter/auth/auth_provider.dart';
import 'components/custom_card.dart';
// import 'components/counter_state.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql/graphql_service.dart';
import 'routes/items/items.dart';
import 'routes/auths/login.dart';
import 'routes/auths/signup.dart';
import 'package:provider/provider.dart';
import 'auth/session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create and load AuthProvider before the app starts
  final authProvider = AuthProvider();
  await authProvider.loadToken();

  runApp(MyApp(authProvider: authProvider));
}

class MyApp extends StatefulWidget {
  final AuthProvider authProvider;
  const MyApp({super.key, required this.authProvider});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // const MyApp({super.key, required this.authProvider});

  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: widget.authProvider,
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return GraphQLProvider(
            client: GraphQLService.client,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Auth with GraphQL',
              // theme: ThemeData(primarySwatch: Colors.blue),
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: _themeMode,
              home:
                  auth.isLoggedIn
                      ? Home(onToggleTheme: toggleTheme)
                      : LoginScreen(),
              // home: ItemListScreen(),
              routes: {
                "/item": (ctx) => ItemById(),
                "/items": (ctx) => ItemListScreen(),
                "/login": (ctx) => LoginScreen(),
                "/signup": (ctx) => SignupScreen(),
                //           "/item": (ctx) => ItemById(),
                //           "/customers": (ctx) => CustomersScreen(),
              },
            ),
          );
        },
      ),
    );
  }
}

Widget header() {
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

Widget card2BottomRightWidgetBar(double height, Color color) {
  return Container(
    width: 10,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

class Home extends StatefulWidget {
  final void Function(bool) onToggleTheme;
  const Home({super.key, required this.onToggleTheme});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  Map<String, dynamic>? user;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // static const List<Widget> _widgetOptions = [Text("0: Hello"), Text("1: Hi")];

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  // onToggleTheme: toggleTheme

  void loadUser() async {
    final userData = await getUserInfo();
    setState(() {
      user = userData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("This is my app")),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "List"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.pink,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child:
                  user == null
                      ? CircularProgressIndicator()
                      : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 12,
                        children: [
                          CircleAvatar(maxRadius: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user!["username"] ?? "Username"),
                              Text("Fullname"),
                            ],
                          ),
                        ],
                      ),
            ),
            // ListTile(title: _widgetOptions[_selectedIndex]),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text("Profile"),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_basket),
              title: Text("Items"),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_basket),
              title: Text("Forecast products"),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Dark Mode"),
              trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: widget.onToggleTheme,
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                final auth = Provider.of<AuthProvider>(context, listen: false);
                auth.logout();
              },
            ),
          ],
        ),
      ),
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
              header(),
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
                    card2BottomRightWidgetBar(25, Colors.red),
                    card2BottomRightWidgetBar(35, Colors.black),
                    card2BottomRightWidgetBar(17, Colors.red),
                    card2BottomRightWidgetBar(25, Colors.black),
                    card2BottomRightWidgetBar(15, Colors.red),
                    card2BottomRightWidgetBar(30, Colors.black),
                    card2BottomRightWidgetBar(25, Colors.red),
                    card2BottomRightWidgetBar(35, Colors.black),
                    card2BottomRightWidgetBar(15, Colors.red),
                    card2BottomRightWidgetBar(35, Colors.black),
                  ],
                ),
              ),
              CustomCard(
                headerText: "Inventing the future\nof design",
                hightlightText: "X.X",
                bottomRightWidget: Container(width: 100, height: 100),
              ),
              // Body
              // CounterState(),
            ],
          ),
        ),
      ),
    );
  }
}
