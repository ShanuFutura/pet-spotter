import 'dart:convert';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_spotter/screens/doctors_view.dart';
import 'package:pet_spotter/screens/products.dart';
import 'package:pet_spotter/utils/network_service.dart';
import 'package:pet_spotter/widgets/ImagePredictor.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/single_card.dart';
import '/models/petmodel.dart';
import '/screens/adopt_pet_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var category = [];
  var selected = 0;
  @override
  void initState() {
    super.initState();
  }

  Widget _buildPetCategory(
      bool isSelected, String category, Function() onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.all(10.0),
        width: 80.0,
        decoration: BoxDecoration(
          color:
              isSelected ? Theme.of(context).primaryColor : Color(0xFFF8F2F7),
          borderRadius: BorderRadius.circular(20.0),
          border: isSelected
              ? Border.all(
                  width: 8.0,
                  color: Color(0xFFFED8D3),
                )
              : null,
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              // height: 80,
              child: Center(
                child: Lottie.network(
                  "https://assets1.lottiefiles.com/packages/lf20_erya171l.json",
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  'Doctors',
                  style: TextStyle(fontSize: 30),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DoctorsView();
                  }));
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  'Products',
                  style: TextStyle(fontSize: 30),
                ),
                onTap: () async {
                  // await LaunchApp.openApp(
                  //   androidPackageName: 'com.google.android.apps.messaging',
                  // );
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Products();
                  }));
                },
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Pet Spoter'),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 100.0,
              width: double.infinity,
              child: _buildPetCategory(true, 'have you seen any dog?', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyImagePicker()),
                );
              }),
            ),
            SizedBox(height: 50.0),
            Expanded(
              child: FutureBuilder(
                  future: getPets(),
                  builder: (context, AsyncSnapshot<List<Pet>> snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return SingleCard(
                                  pet: snapshot.data!.elementAt(index));
                            })
                        : const Center(
                            child: Text('Please wait..'),
                          );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Pet>> getPets() async {
    List json = await getData("view_pets.php");
    // print(json);
    return json.map((e) => Pet.fromJson(e)).toList();
  }
}
