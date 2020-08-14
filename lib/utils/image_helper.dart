import 'dart:io';

import 'package:gallery/models/image.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  static ImageHelper _imageHelper;
  static Database _database;

  String imageTable = 'image_table';
  String colImage = 'image';
  String colId = 'id';
  String colName = 'name';

  ImageHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory ImageHelper() {
    if (_imageHelper == null) {
      _imageHelper = ImageHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _imageHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'images.db';

    // Open/create the database at a given path
    var imagesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return imagesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $imageTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colImage TEXT,$colName TEXT)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getImageMapList() async {
    Database db = await this.database;
    var result = await db.query(imageTable);
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertImage(ImageModel image) async {
    Database db = await this.database;
    var result = await db.insert(imageTable, image.toMap());
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteImage(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $imageTable WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $imageTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Image List' [ List<Image> ]
  Future<List<ImageModel>> getImageList() async {
    var imageMapList = await getImageMapList(); // Get 'Map List' from database
    int count =
        imageMapList.length; // Count the number of map entries in db table

    List<ImageModel> imageList = List<ImageModel>();
    // For loop to create a 'Image List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      imageList.add(ImageModel.fromMap(imageMapList[i]));
    }
    return imageList;
  }
}
