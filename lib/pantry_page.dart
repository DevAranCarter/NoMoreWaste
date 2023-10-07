import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:no_more_waste/style/constants.dart';
import 'package:no_more_waste/dto/pantry_item.dart';
import 'package:no_more_waste/dto/pantry_page_state.dart';
import 'package:no_more_waste/recipes_screen.dart';
import 'package:no_more_waste/util/alert_util.dart';
import 'package:no_more_waste/util/date_util.dart';

class PantryScreen extends StatefulWidget {
  const PantryScreen({Key? key, required this.pantryPageState}) : super(key: key);

  final PantryPageState pantryPageState;

  @override
  _PantryScreenState createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  late User loggedinUser;
  final _auth = FirebaseAuth.instance;
  final List<PantryItem> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  fetchPantry(String userId) async {
    List<PantryItem> pantryItemsResult = [];

    DatabaseReference ref = database.ref("pantry");

    // Get the data once
    DatabaseEvent event = await ref.child(userId).once();

    // If there are no pantry items yet return an empty list
    if (!event.snapshot.exists) {
      return List.empty();
    }

    // Print the data of the snapshot
    LinkedHashMap pantryItemsList = event.snapshot.value as LinkedHashMap;

    pantryItemsList.forEach((key, pantryItem) {
      Map<dynamic, dynamic> pantryItemJson = pantryItem as Map<dynamic, dynamic>;

      PantryItem specificPantryItem = PantryItem(
          id: key,
          name: pantryItemJson["name"],
          expiredate: DateTime.parse(pantryItemJson["expiredate"]),
          addeddate: DateTime.fromMicrosecondsSinceEpoch(int.parse(pantryItemJson["addeddate"])),
          quantity: int.parse(pantryItemJson["quantity"]));
      pantryItemsResult.add(specificPantryItem);
    });

    return pantryItemsResult;
  }

  deletePantryItem(String userId, String itemId) async {
    DatabaseReference ref = database.ref("pantry/$userId");

    ref.child(itemId.toString()).remove();
  }

  String getDaysRemainingString(PantryItem pantryItem) {
    int daysUntilExpireDate = DateUtil.daysBetween(DateTime.now(), pantryItem.expiredate);

    if (daysUntilExpireDate > 0) {
      return daysUntilExpireDate.toString() + " days remaining";
    } else if (daysUntilExpireDate == 0) {
      return "Expiring today";
    } else {
      return daysUntilExpireDate.abs().toString() + " days overdue";
    }
  }

  //using this function you can use the credentials of the user
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _selectDate(BuildContext context, PantryItem pantryItem) async {
    final DateTime? d = await showDatePicker(
      //we wait for the dialog to return
      context: context,
      initialDate: pantryItem.expiredate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (d != null) {

      // we format the selected date and assign it to the state variable
      String selectedDate = DateFormat.yMMMMd("en_US").format(d);
    }
  }

  void actionPopUpItemSelected(String value, PantryItem pantryItem) {
    if (value == 'ate-this') {
      // delete item from database
      deletePantryItem(_auth.currentUser!.uid, pantryItem.id);
      setState(() {
        // hack to reload page state
      });
    } else if (value == 'add-new-date') {
      _selectDate(context, pantryItem);
    } else if (value == 'generate-recipe') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const RecipesPage()),
      );
    } else {
      AlertUtil.showNotYetImplementedDialog(context);
    }
  }

  Future<void> _pullRefresh() async {
    setState(() {
      // TODO update
    });
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
            leading: null,
            title: const Text('Pantry'),
          ),
          body: FutureBuilder(
              future: fetchPantry(_auth.currentUser!.uid),
              builder: (BuildContext ctx, AsyncSnapshot snapshot) => snapshot.hasData ? RefreshIndicator(
                onRefresh: _pullRefresh,
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, index) => Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        onTap: widget.pantryPageState == PantryPageState.view ? null : () {
                          setState(() {
                            _selectedItems.add(snapshot.data![index]);
                          });
                        },
                        selected: _selectedItems.contains(snapshot.data![index]),
                        contentPadding: const EdgeInsets.all(10),
                        title: Text(snapshot.data![index].name.toString()),
                        subtitle: Text(getDaysRemainingString(snapshot.data![index])),
                        trailing: widget.pantryPageState == PantryPageState.view ? PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) {
                            return [
                              const PopupMenuItem(
                                value: 'ate-this',
                                child: Text('I ate this'),
                              ),
                              const PopupMenuItem(
                                value: 'add-new-date',
                                child: Text('Add new date'),
                              ),
                              const PopupMenuItem(
                                value: 'view-alternatives',
                                child: Text('View alternatives'),
                              ),
                              const PopupMenuItem(
                                value: 'generate-recipe',
                                child: Text('Generate recipe'),
                              ),
                              const PopupMenuItem(
                                value: 'view-nutrition-details',
                                child: Text('View nutrition details'),
                              )
                            ];
                          },
                          onSelected: (String value) => actionPopUpItemSelected(value, snapshot.data![index]),
                        ) : Radio(
                          value: "2",
                          groupValue: [],
                          onChanged: (val) {
                            setState(() {
                              //radioValues[index] = val;
                            });
                          },
                        ),
                      ),
                  ))) : const Center (
                child: CircularProgressIndicator(), // progress indicator if database query still running
              )
          )
      ),
    );
  }
}