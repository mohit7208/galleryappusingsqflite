import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery/models/image.dart';
import 'package:gallery/utils/image_helper.dart';
import 'package:image_picker/image_picker.dart';

class AddImage extends StatefulWidget {
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  TextEditingController imageNameController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String name;
  ImageHelper helper = ImageHelper();
  File _image;
  String path;
  final picker = ImagePicker();
  ImageModel imageModel;
  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
      path = pickedFile.path;
    });
    print(_image);
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
      path = pickedFile.path;
    });
    print(_image);
  }

  _save() async {
    int result;
    ImageModel image = ImageModel(image: path, name: name);
    result = await helper.insertImage(image);
    if (result != 0) {
      // Success
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Image'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: ClipOval(
                  child: _image == null
                      ? Image.asset(
                          'assets/noprofile.png',
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        )
                      : Image.file(
                          _image,
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: imageNameController,
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Enter image name',
                    labelText: 'Image Name'),
              ),
              SizedBox(
                height: 20,
              ),
              customRaisedButton(
                  color: Colors.transparent,
                  text: 'Select Image From Camera',
                  textColor: Colors.white,
                  onPressed: getImageFromCamera),
              SizedBox(
                height: 20,
              ),
              customRaisedButton(
                  color: Colors.transparent,
                  text: 'Select Image From Gallery',
                  textColor: Colors.white,
                  onPressed: getImageFromGallery),
              SizedBox(
                height: 20,
              ),
              customRaisedButton(
                  color: Colors.white,
                  text: 'Save',
                  textColor: Colors.black,
                  onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }

  Widget customRaisedButton(
      {String text, Color textColor, Color color, Function onPressed}) {
    return Container(
      height: 60,
      child: RaisedButton(
        color: color,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
          ),
        ),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.white, width: 1)),
      ),
    );
  }
}
