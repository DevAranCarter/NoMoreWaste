import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:no_more_waste/style/constants.dart';
import 'package:no_more_waste/dto/marketplace_item_data.dart';

class MarketplacePage extends StatefulWidget {

  const MarketplacePage({Key? key}) : super(key: key);

  @override
  _MarketplacePageState createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {

  fetchMarketplaceItems() async {
    List<MarketplaceItemData> marketplaceItemsResult = [];

    DatabaseReference ref = FirebaseDatabase.instance.ref("marketplace");

    // Get the data once
    DatabaseEvent event = await ref.once();

    // Print the data of the snapshot
    LinkedHashMap marketplaceItemsList = event.snapshot.value as LinkedHashMap;

    // If there are no marketplace items, return an empty list
    if (marketplaceItemsList == null || marketplaceItemsList.isEmpty) {
      return List.empty();
    }

    marketplaceItemsList.forEach((key, pantryItem) {
      Map<dynamic, dynamic> pantryItemJson = pantryItem as Map<dynamic, dynamic>;

      MarketplaceItemData specificMarketplaceItem = MarketplaceItemData(
          id: key,
          name: pantryItemJson["name"],
          distance: '0.5 miles away');
      marketplaceItemsResult.add(specificMarketplaceItem);
    });

    return marketplaceItemsResult;
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
            title: const Text("Marketplace"),
          ),
          body: FutureBuilder(
              future: fetchMarketplaceItems(),
              builder: (BuildContext ctx, AsyncSnapshot snapshot) => snapshot.hasData ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, index) => ListTile(
                    title : Text(snapshot.data![index].name),
                    subtitle: Text(snapshot.data![index].distance),
                    leading: CircleAvatar(
                        child: Text(snapshot.data![index].name[0])
                    ),
                    onTap: () {
                      // TODO show detail page
                    },
                  )
              ) : const Center(child: CircularProgressIndicator()) // progress indicator if database query still running
          )
      ),
    );
  }
}