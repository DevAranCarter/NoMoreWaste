import 'package:flutter/material.dart';
import 'package:no_more_waste/dto/pantry_page_state.dart';
import 'package:no_more_waste/foodbanks_page.dart';
import 'package:no_more_waste/home_page.dart';
import 'package:no_more_waste/pantry_page.dart';
import 'package:no_more_waste/product_add_page.dart';

class NavigationMainPage extends StatefulWidget {
  const NavigationMainPage({Key? key}) : super(key: key);

  @override
  _NavigationMainPageState createState() => _NavigationMainPageState();
}

class _NavigationMainPageState extends State<NavigationMainPage> {
  int _currentIndex = 0;

  final _page1 = GlobalKey<NavigatorState>();
  final _page2 = GlobalKey<NavigatorState>();
  final _page3 = GlobalKey<NavigatorState>();
  final _page4 = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          Navigator(
            key: _page1,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => const HomePage(),
            ),
          ),
          Navigator(
            key: _page2,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => const PantryScreen(pantryPageState: PantryPageState.view),
            ),
          ),
          Navigator(
            key: _page3,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => const ProductAddPage(),
            ),
          ),
          Navigator(
            key: _page4,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => FoodbanksPage(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 13,
          unselectedFontSize: 13,
          iconSize: 30,
          selectedItemColor: Colors.blue[700],
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Pantry'),
            BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Add Item'),
            BottomNavigationBarItem(icon: Icon(Icons.volunteer_activism), label: 'Donate'),
          ],
        ),
      ),
    );
  }
}