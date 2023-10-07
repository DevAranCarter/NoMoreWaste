import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_more_waste/style/constants.dart';
import 'package:no_more_waste/dto/foodbank.dart';
import 'package:no_more_waste/foodbank_detail_page.dart';
import 'package:no_more_waste/foodbanks_maps_page.dart';
import 'package:no_more_waste/services/storage_service.dart';

class FoodbanksPage extends StatefulWidget {
  const FoodbanksPage({Key? key}) : super(key: key);

  @override
  _FoodbanksPageState createState() => _FoodbanksPageState();
}

class _FoodbanksPageState extends State<FoodbanksPage> {

  final StorageService _storageService = StorageService.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;
  final List<Foodbank> _foodbanksCache = [];

  fetchFoodbanks() async {
    List<Foodbank> foodbanksResult = [];

    DatabaseReference ref = database.ref("foodbanks");

    // Get the data once
    DatabaseEvent event = await ref.once();

    // Print the data of the snapshot
    List foodbanksList = event.snapshot.value as List;

    // If there are no foodbanks yet return an empty list
    if (foodbanksList == null || foodbanksList.isEmpty) {
      return List.empty();
    }

    foodbanksList.forEach((foodbank) {
      Map<dynamic, dynamic> foodbankJson = foodbank as Map<dynamic, dynamic>;

      Foodbank specificFoodbank = Foodbank(
            name: foodbankJson["name"],
            address: foodbankJson["address"],
            imagePath: foodbankJson["imageName"],
            phoneNumber: foodbankJson["phonenumber"],
            city: foodbankJson["location"],
            longitude: double.parse(foodbankJson["longitude"]),
            latitude: double.parse(foodbankJson["latitude"])
          );
      foodbanksResult.add(specificFoodbank);
    });

    _foodbanksCache.addAll(foodbanksResult);
    return foodbanksResult;
  }

  List<Widget> getStructuredGridCells(dynamic snapshotData) {
    List<Widget> result = [];

    List<Foodbank> foodbanks = snapshotData! as List<Foodbank>;

    foodbanks.forEach((element) {
      result.add(getStructuredGridCell(element));
    });

    return result;
  }

  GestureDetector getStructuredGridCell(Foodbank foodbank) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FoodbankDetailScreen(foodbank: foodbank)),
        );
      },
      child: Card(
          elevation: 1.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FutureBuilder <String>(
                  future: _storageService.loadImage(foodbank.imagePath),
                  builder: (BuildContext context, AsyncSnapshot<String> image) {
                    if (image.hasData) {
                      return Image.network(image.data.toString());  // image is ready
                      //return Text('data');
                    } else {
                      return const CircularProgressIndicator();  // placeholder
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(foodbank.name),
                    const Text('0.5 miles away'),
                    Text(foodbank.city),
                    const Text('Closes soon'),
                  ],
                ),
              )
            ],
          )),
    );
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
              actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FoodbanksMapsScreen(foodbanks: _foodbanksCache)),
                      );
                    },
                  )
              ],
          ),
          body: Scrollbar(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                            'FOOD BANKS',
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.comicNeue(fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.black)
                        ),
                      ),
                    ),
                    FutureBuilder(
                        future: fetchFoodbanks(),
                        builder: (BuildContext ctx, AsyncSnapshot snapshot) => snapshot.hasData ? GridView.count(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            primary: true,
                            crossAxisCount: 2,
                            childAspectRatio: 0.80,
                            children: getStructuredGridCells(snapshot.data)
                        ) : const Center (
                          child: CircularProgressIndicator(), // progress indicator if database query still running
                        )
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}