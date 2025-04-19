import 'package:flutter/material.dart';
// import 'package:newflutter/auth/auth_actions.dart';
import 'package:newflutter/auth/auth_provider.dart';
import 'package:newflutter/components/_forms.dart';
import 'package:newflutter/firebase/transactions.dart';
import 'package:newflutter/routes/inventory-action/generateqr.dart';
import 'package:newflutter/routes/inventory-action/in/screen.dart';
import 'package:newflutter/routes/inventory-action/out/screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'components/custom_card.dart';
// import 'components/counter_state.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql/graphql_service.dart';
import 'routes/items/items.dart';
import 'routes/auths/login.dart';
import 'routes/auths/signup.dart';
import 'package:provider/provider.dart';
import 'auth/session.dart';
import 'dart:convert';
// import "package:mobile";
import 'routes/inventory-action/qrscanner.dart';

// flutter setup
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create and load AuthProvider before the app starts
  final authProvider = AuthProvider();
  await authProvider.loadToken();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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

  // Future<void> getItem() {}

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
              themeAnimationCurve: Curves.easeInExpo,
              themeAnimationDuration: Duration(milliseconds: 100),
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: _themeMode,
              home:
                  auth.isLoggedIn
                      // ? ItemInScreen()
                      ? Home(onToggleTheme: toggleTheme)
                      // ? QRScannerScreen()
                      : LoginScreen(),
              // home: ItemListScreen(),
              routes: {
                "/item": (ctx) => ItemById(),
                "/items": (ctx) => ItemListScreen(),
                "/login": (ctx) => LoginScreen(),
                "/signup": (ctx) => SignupScreen(),

                "/item-in": (ctx) => ItemInScreen(),
                "/item-out": (ctx) => ItemOutScreen(),
                "/generateqr": (ctx) => GenerateQRScreen(),
                "/scanqr": (ctx) => QRScannerScreen(),
                // "/inventory-action": (ctx) => InventoryActionScreen(),
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
  int _selectedBottomIndex = 0;

  Map<String, dynamic>? user;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onBottomTapped(int index) {
    setState(() {
      _selectedBottomIndex = index;
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

  static final List<String> _titles = [
    "Home",
    "Inventory actions",
    "Transactions",
  ];

  static final List<Widget> _widgetBottomOptions = [
    // homeBody(),
    testFirebase(),
    QrActionBody(),
    transactionsBody(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedBottomIndex])),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomIndex,
        // backgroundColor: Colors.red,
        selectedItemColor: Colors.blue,
        onTap: _onBottomTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: "Actions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.percent),
            label: 'Transactions',
            backgroundColor: Colors.pink,
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          // padding: EdgeInsets.zero,
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
                              Text(
                                user!["username"] ?? "Username",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("Admin"),
                              // Text(user!["id"] ?? "Null Fullname"),
                            ],
                          ),
                        ],
                      ),
            ),
            // ListTile(title: _widgetOptions[_selectedIndex]),
            ListTile(
              leading: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              title: Text(
                Theme.of(context).brightness == Brightness.dark
                    ? "Dark Mode"
                    : "Light Mode",
              ),
              trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                // leading: Icon(Icons.sunny),
                onChanged: widget.onToggleTheme,
              ),
            ),
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
                Navigator.pushNamed(context, "/items");
              },
            ),
            ListTile(
              leading: Icon(Icons.auto_graph),
              title: Text("Forecast products"),
              onTap: () {
                // setState(() {
                //   _selectedIndex = 2;
                // });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.qr_code_scanner),
              title: Text("Scan QR Code"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/scanqr");
              },
            ),
            Expanded(flex: 1, child: SizedBox()),
            ListTile(
              iconColor: Colors.red[400],
              textColor: Colors.red[400],
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                final auth = Provider.of<AuthProvider>(context, listen: false);
                auth.logout();
              },
            ),
            SizedBox(height: 48),
          ],
        ),
      ),
      body: _widgetBottomOptions[_selectedBottomIndex],
    );
  }
}

Widget testFirebase() {
  FirebaseTransactionService _transactionService = FirebaseTransactionService();
  return SingleChildScrollView(
    child: Container(
      color: Colors.blue,
      child: ElevatedButton(
        child: Text("Add transaction sample"),
        onPressed: () {
          _transactionService.addTransaction("in", 9090, [1, 2, 3]);
        },
      ),
    ),
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
  );
}

Widget homeBody() {
  return SingleChildScrollView(
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
                      child: Image.asset("assets/tina.jpg", fit: BoxFit.cover),
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
                      child: Image.asset("assets/tina.jpg", fit: BoxFit.cover),
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
                      child: Image.asset("assets/tina.jpg", fit: BoxFit.cover),
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
            bottomRightWidget: SizedBox(width: 100, height: 100),
          ),
          QrImageView(data: json.encode({"itemName": "HOTDOG"})),
          // Body
          // CounterState(),
        ],
      ),
    ),
  );
}

// Widget qrActionBody() {
// }

class QrActionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12),

      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/item-in");
                  },
                  style: btnStyle("pri"),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code),
                      SizedBox(width: 6),
                      Text("In"),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/item-out");
                  },
                  style: btnStyle("sec"),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code),
                      SizedBox(width: 6),
                      Text("Out"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget transactionsBody() {
  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 12),
    child: Text("Transactions"),
  );
}
