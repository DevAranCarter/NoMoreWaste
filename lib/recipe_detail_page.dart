import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_more_waste/components/bullet_list.dart';
import 'package:no_more_waste/dto/recipe_data.dart';
import 'package:no_more_waste/style/constants.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({Key? key, required this.recipeData}) : super(key: key);

  final RecipeData recipeData;

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {

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
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent, // make this transparent
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: Colors.black, // set color of back button
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 40.0),
                Text(widget.recipeData.name,
                  maxLines: 1,
                  style: Constants.HEADER_TEXT_STYLE,
                ),
                Text('Ingredients',
                  maxLines: 1,
                  style: GoogleFonts.comicNeue(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.shade500,
                      borderRadius: BorderRadius.circular(14)),
                  child: const SingleChildScrollView(
                    child: BulletList([
                      '400g Buckwheat flour',
                      '300ml Milk',
                      '2 tsp Baking powder',
                      '2 tbsp white sugar',
                      '1 banana',
                      '3 slices of THIS vegan bacon',
                      '2 tbsp vegetable oil',
                      '2 tsp salt',
                    ]),
                  ),
                ),
                Text('Method',
                  maxLines: 1,
                  style: GoogleFonts.comicNeue(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.shade500,
                      borderRadius: BorderRadius.circular(14)),
                  child: const SingleChildScrollView(
                    child: BulletList([
                      'Step 1: Add flour, Baking powder, sugar and salt',
                      'Step 2: Combine the banana and milk and mix together',
                      'Step 3: Mix together and fry in small fying pen',
                      'Step 4: Fry bacon and serve'
                    ]),
                  ),
                ),
              ],
            ),
          )
        )
    );
  }
}