import 'package:flutter/material.dart';
import 'package:no_more_waste/style/constants.dart';
import 'package:no_more_waste/dto/foodbank.dart';
import 'package:no_more_waste/services/storage_service.dart';
import 'package:url_launcher/url_launcher.dart';

class FoodbankDetailScreen extends StatefulWidget {

  final Foodbank foodbank;

  const FoodbankDetailScreen({Key? key, required this.foodbank}) : super(key: key);

  @override
  _FoodbankDetailScreenState createState() => _FoodbankDetailScreenState();
}

class _FoodbankDetailScreenState extends State<FoodbankDetailScreen> {

  final StorageService _storageService = StorageService.instance;

  void _launchMapsUrl(String address) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$address';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
          body: Stack(
            children: <Widget>[
              SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FutureBuilder <String>(
                        future: _storageService.loadImage(widget.foodbank.imagePath),
                        builder: (BuildContext context, AsyncSnapshot<String> image) {
                          if (image.hasData) {
                            return CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(image.data.toString()),
                            );
                          } else {
                            return Container();  // placeholder
                          }
                        },
                      ),
                      Text(
                        widget.foodbank.name,
                        style: const TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        widget.foodbank.city,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'SourceSansPro',
                          color: Colors.red[400],
                          letterSpacing: 2.5,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                        width: 200,
                        child: Divider(
                          color: Colors.teal[100],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // make phone call
                          launch("tel://" + widget.foodbank.phoneNumber);
                        },
                        child: Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                            child: ListTile(
                              leading: Icon(
                                Icons.phone,
                                color: Colors.teal[900],
                              ),
                              title: Text(
                                widget.foodbank.phoneNumber,
                                style: const TextStyle(fontFamily: 'BalooBhai', fontSize: 20.0),
                              ),
                            )
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _launchMapsUrl(widget.foodbank.address);
                        },
                        child: Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                          child: ListTile(
                            leading: Icon(
                              Icons.location_on,
                              color: Colors.teal[900],
                            ),
                            title: Text(
                              widget.foodbank.address,
                              style: const TextStyle(fontSize: 20.0, fontFamily: 'Neucha'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: AppBar(
                  title: const Text('Foodbank Details', style: TextStyle(color: Colors.black)),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  backgroundColor: Colors.transparent, // make this transparent
                  elevation: 0.0, //No shadow
                ),),
            ],
          )
      ),
    );
  }
}