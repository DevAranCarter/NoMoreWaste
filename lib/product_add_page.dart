import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:no_more_waste/style/constants.dart';
import 'package:no_more_waste/dto/pantry_page_state.dart';
import 'package:no_more_waste/dto/product_description.dart';
import 'package:no_more_waste/pantry_page.dart';
import 'package:no_more_waste/recipes_screen.dart';
import 'package:no_more_waste/services/barcode_service.dart';

class ProductAddPage extends StatefulWidget {
  const ProductAddPage({Key? key}) : super(key: key);

  @override
  _ProductAddPageState createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  final _auth = FirebaseAuth.instance;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final BarcodeService _barcodeService = BarcodeService.instance;
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemQuantityController = TextEditingController();
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );
  final _units = <String> [
    "kg",
    "g",
    "quantity"
  ];
  TextStyle style = GoogleFonts.comicNeue(fontSize: 20.0, fontWeight: FontWeight.bold);
  String _selectedDate = 'Expiry date';
  String _scanBarcode = 'Tap to scan';
  String _selectedUnit = '';

  @override
  void initState() {
    super.initState();
  }

  // TODO: move database interaction to service class
  Future<void> addItemToDatabase(String name, String quantity, DateTime addedDate, String expiryDate) async {
    if (expiryDate.isEmpty || expiryDate == 'Expiry date') {
      expiryDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }

    String currentUserId = _auth.currentUser!.uid;
    DatabaseReference ref_users = database.ref("pantry/$currentUserId");

    await ref_users.push().set(<String, String>{
      'name': name,
      'expiredate': expiryDate,
      'addeddate': addedDate.millisecondsSinceEpoch.toString(),
      'quantity': quantity
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      //we wait for the dialog to return
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2050),
    );
    if (d != null) {
      setState(() {
        // we format the selected date and assign it to the state variable
        _selectedDate = DateFormat('yyyy-MM-dd').format(d);
      });
    }
  }

  Future<ProductDescription> getProductDescription(String barcode) async {
    ProductDescription productDescription = await _barcodeService.fetchProductDescription(barcode);

    itemNameController.text = productDescription.title; // still too hacky

    return productDescription;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcode() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _scanBarcode = barcodeScanRes;

      getProductDescription(_scanBarcode);
    });
  }

  Widget getUnitField() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
             // labelStyle: textStyle,
              errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 16.0),
              hintText: 'Tap to select a unit',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          isEmpty: _selectedUnit == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedUnit.isNotEmpty ? _selectedUnit : null, // guard it with null if empty
              isDense: true,
              onChanged: (newValue) {
                setState(() {
                  if (newValue != null) {
                    _selectedUnit = newValue;
                    state.didChange(newValue);
                  }
                });
              },
              items: _units.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget getExpireDateField() {
    return TextFormField(
      onTap: () {
        _selectDate(context);
      },
      showCursor: true,
      readOnly: true,
      style: style,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 0, 0, 10.0),
        labelText: _selectedDate,
        hintText: "Tap to select date",
      ),
    );
  }

  Widget getItemNameField() {
    return TextFormField(
      controller: itemNameController,
      style: style,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 0, 0, 10.0),
        labelText: "Item",
        hintText: "Name of the item",
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
          child: GestureDetector(
            onTap: () {
              scanBarcode();
            },
            child: const Icon(Icons.qr_code_scanner, size: 24),
          ),
        ),
      ),
    );
  }

  Widget getQuantityField() {
    return TextFormField(
      controller: itemQuantityController,
      keyboardType: TextInputType.number,
      style: style,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 0, 0, 10.0),
        labelText: "Quantity",
        hintText: "Quantity of your item",
      ),
    );
  }

  Widget getAddItemButton() {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      color: Colors.blueGrey,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          addItemToDatabase(itemNameController.text, itemQuantityController.text, DateTime.now(), _selectedDate);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PantryScreen(pantryPageState: PantryPageState.view)),
          );
        },
        child: Text(
          "Add Item",
          textAlign: TextAlign.center,
          style: style.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: Constants.BACKGROUND_GRADIENT_COLORS
            )
        ),
        child: Scaffold(
          // By default, Scaffold background is white
          // Set its value to transparent
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent, // make this transparent
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: Colors.black, // set color of back button
            ),
          ),
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 50,
                    ),
                    Text('ADD NEW ITEMS',
                        maxLines: 1,
                        style: Constants.HEADER_TEXT_STYLE,
                    ),
                    ButtonBar(
                      mainAxisSize: MainAxisSize.min,
                      // this will take space as minimum as possible(to center)
                      children: <Widget>[
                        ElevatedButton(
                          style: raisedButtonStyle,
                          child: const Text('Remove Items'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PantryScreen(pantryPageState: PantryPageState.deleteItems)),
                            );
                          },
                        ),
                        ElevatedButton(
                          style: raisedButtonStyle,
                          child: const Text('Generate recipe'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RecipesPage()),
                            );
                          },
                        ),
                      ],
                    ),
                    getProductAddFormCard(),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget getProductAddFormCard() {
    return Container(
        margin: const EdgeInsets.all(30),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 15.0),
                    getItemNameField(),
                    const SizedBox(height: 15.0),
                    getExpireDateField(),
                    const SizedBox(height: 15.0),
                    getUnitField(),
                    const SizedBox(height: 15.0),
                    getQuantityField(),
                    const SizedBox(height: 15.0),
                    getAddItemButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
