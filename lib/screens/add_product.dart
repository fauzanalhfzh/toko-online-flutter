import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toko_online/screens/homepage.dart';
import 'package:http/http.dart' as http;

class AddProduct extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _imageUrlController = TextEditingController();

  Future saveProduct() async {
    final response =
        await http.post(Uri.parse("http://127.0.0.1:8000/api/products"), body: {
      "name": _nameController.text,
      "description": _deskripsiController.text,
      "price": _priceController.text,
      "image_url": _imageUrlController.text,
    });

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Product'),
      ),
      body: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nama Produk"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Masukkan nama produk";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _deskripsiController,
                decoration: InputDecoration(labelText: "Deskripsi"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Masukkan deskripsi produk";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: "Harga"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Masukkan harga produk";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: "image URL"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Masukkan alamat image produk";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      saveProduct().then((value) => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage())),
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text("data Berhasil di Ditambahkan😍")))
                          });
                    }
                  },
                  child: Text("Save"))
            ],
          )),
    );
  }
}
