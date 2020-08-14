import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery/models/image.dart';
import 'package:gallery/screens/add_image.dart';
import 'package:gallery/screens/image_detail.dart';
import 'package:gallery/utils/image_helper.dart';
import 'package:sqflite/sqflite.dart';

class ImageList extends StatefulWidget {
  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  ImageHelper databaseHelper = ImageHelper();
  List<ImageModel> imageList;
  bool result;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (imageList == null) {
      imageList = List<ImageModel>();
      updateListView();
    }

    return Scaffold(
      body: getGridView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddImage(),
              ));

          if (result == true) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageList(),
                ));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  getGridView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          itemCount: count,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 7, mainAxisSpacing: 7),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageDetail(
                      image: imageList[index].image,
                      name: imageList[index].name,
                    ),
                  )),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    File(imageList[index].image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }),
    );
  }

  void _delete(BuildContext context, ImageModel image) async {
    int result = await databaseHelper.deleteImage(image.id);
    if (result != 0) {
      _showSnackBar(context, 'Image Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ImageModel>> imageListFuture = databaseHelper.getImageList();
      imageListFuture.then((contactList) {
        setState(() {
          this.imageList = contactList;
          this.count = contactList.length;
        });
      });
    });
  }
}
