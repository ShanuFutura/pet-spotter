import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pet_spotter/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Products extends StatelessWidget {
  const Products({Key? key}) : super(key: key);

  Future<dynamic> getData() async {
    final res =
        await http.get(Uri.parse(Constants.BASE_URL + 'view_product.php'));
    print(res.body);
    return jsonDecode(res.body);
  }

  sendRequest(String prodId, String price) async {
    final spref = await SharedPreferences.getInstance();
    final res = await http
        .post(Uri.parse(Constants.BASE_URL + 'buy_product.php'), body: {
      'id': prodId.toString(),
      'login_id': spref.getString('user_id')
    });
    if (jsonDecode(res.body)['message'] as bool) {
      String upiurl =
          'upi://pay?pa=petshop@okicici&pn=petshop&tn=petsCorner&am=$price&cu=INR';
      await launchUrl(Uri.parse(upiurl));
      // Fluttertoast.showToast(msg: 'Request sent');
    }
    print(res.body);
  }

  // buyProduct() async {
  //   // launchUrl(Uri.parse('com.whatsapp'));
  //   final res = await http.post();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        foregroundColor: Colors.black,
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
                            backgroundImage: NetworkImage(Constants.BASE_URL +
                                'images/gallery/'
                                    '${(snap.data as dynamic)[index]['image']}')),
                        onTap: () {
                          // buyProduct();
                          sendRequest((snap.data as dynamic)[index]['id'],
                              (snap.data as dynamic)[index]['price']);
                        },
                        title: Text((snap.data as dynamic)[index]['name']),
                        subtitle: Text('Category :' +
                            (snap.data as dynamic)[index]['category']),
                        // trailing: Text(
                        //     'Experience: ${(snap.data as dynamic)[index]['experience']} years'),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
