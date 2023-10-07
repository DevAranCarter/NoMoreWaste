import 'package:flutter/material.dart';
import 'package:no_more_waste/style/constants.dart';
import 'package:no_more_waste/components/flutter_tag_view.dart';
import 'package:no_more_waste/dto/recipe_data.dart';
import 'package:no_more_waste/recipe_detail_page.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({Key? key}) : super(key: key);

  @override
  _RecipesPageState createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {

  List<String> tags = <String>['Tomato', 'Bread'];

  final List<RecipeData> _allRecipes = [const RecipeData(name: "Bacon Pancakes", image: "assets/images/bacon_pancakes.png", time: "1h", country: "Canada"), const RecipeData(name: "Pizza", image: "assets/images/pizza.png", time: "1h", country: "Italy")];

  @override
  void initState() {
    super.initState();
  }

  Widget _getItemUI(BuildContext context, int index) {
    return Card(
        child: Column(
          children: <Widget>[
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecipeDetailPage(recipeData: _allRecipes[index])),
                );
              },
              leading: Image.asset(
                _allRecipes[index].image,
                fit: BoxFit.cover,
                width: 100.0,
              ),
              title: Text(
                _allRecipes[index].name,
                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Time: ${_allRecipes[index].time}',
                        style: const TextStyle(
                            fontSize: 11.0, fontWeight: FontWeight.normal)),
                    Text('Origin: ${_allRecipes[index].country}',
                        style: const TextStyle(
                            fontSize: 11.0, fontWeight: FontWeight.normal)),
                  ]
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: Constants.BACKGROUND_GRADIENT_COLORS)
      ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent, // make this transparent
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: Colors.black, // set color of back button
            ),
          ),
          body: Container(
            margin: const EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Text(
                    'Generate recipe',
                    maxLines: 1,
                    style: GoogleFonts.comicNeue(fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.black),
                    textAlign: TextAlign.center
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: FlutterTagView(
                    tags: tags,
                    maxTagViewHeight: 100,
                    deletableTag: true,
                  ),
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _allRecipes.length,
                  itemBuilder: _getItemUI,
                  padding: const EdgeInsets.all(0.0),
                )
              ],
            ),
          ),
        )
    );
  }
}