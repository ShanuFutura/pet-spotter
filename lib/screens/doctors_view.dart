import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:pet_spotter/utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorsView extends StatelessWidget {
  const DoctorsView({Key? key}) : super(key: key);

  Future<dynamic> getData() async {
    final res =
        await http.get(Uri.parse(Constants.BASE_URL + 'view_doctor.php'));
    print(res.body);
    return jsonDecode(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                  itemCount: (snap.data as List).length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                            // radius: 60,
                            backgroundImage: NetworkImage(
                                'https://st2.depositphotos.com/4226061/9064/v/950/depositphotos_90647730-stock-illustration-female-doctor-avatar-icon.jpg')),
                        onTap: () {
                          launchUrl(Uri.parse(
                              'http://maps.google.com/maps?q=${(snap.data as dynamic)[index]['lattitude']},${(snap.data as dynamic)[index]['longitude']}'
                              // 'https://www.google.com/maps/@${(snap.data as dynamic)[index]['lattitude']},${(snap.data as dynamic)[index]['longitude']},14.15z'
                              ));
                        },
                        title: Text((snap.data as dynamic)[index]['name']),
                        subtitle: Text(
                            (snap.data as dynamic)[index]['qualification']),
                        trailing: Text(
                            'Experience: ${(snap.data as dynamic)[index]['experience']} years'),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
