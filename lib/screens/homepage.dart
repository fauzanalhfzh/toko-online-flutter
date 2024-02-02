import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toko_online/screens/add_product.dart';
import 'package:toko_online/screens/edit_product.dart';
import 'dart:convert';

import 'package:toko_online/screens/product_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = 'http://127.0.0.1:8000/api/products';

  Future getProducts() async {
    var response = await http.get(Uri.parse(url));
    // print(json.decode(response.body));
    return json.decode(response.body);
  }

  Future deleteProduct(String productId) async {
    String url = 'http://127.0.0.1:8000/api/products/' + productId;

    var response = await http.delete(Uri.parse(url));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    getProducts();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddProduct()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Antaranku"),
      ),
      body: FutureBuilder(
        future: getProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data['data'].length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 180,
                    child: Card(
                      elevation: 5,
                      child: Row(children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetail(
                                          product: snapshot.data['data'][index],
                                        )));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0)),
                            padding: EdgeInsets.all(2),
                            margin: EdgeInsets.only(right: 15),
                            height: 120,
                            width: 120,
                            child: Image.network(
                              snapshot.data['data'][index]['image_url'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  snapshot.data['data'][index]['name'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(snapshot.data['data'][index]
                                      ['description'])),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditProduct(
                                                          product: snapshot
                                                                  .data['data']
                                                              [index],
                                                        )));
                                          },
                                          child: Icon(Icons.edit)),
                                      GestureDetector(
                                          onTap: () {
                                            deleteProduct(snapshot.data['data']
                                                        [index]['id']
                                                    .toString())
                                                .then((value) {
                                              setState(() {});
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "data Berhasil di dihapus😐")));
                                            });
                                          },
                                          child: Icon(Icons.delete)),
                                    ],
                                  ),
                                  Text(snapshot.data['data'][index]['price']
                                      .toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  );
                  // return Text(snapshot.data['data'][index]['name']);
                });
          } else {
            return Text("Load data");
          }
        },
      ),
    );
  }
}
