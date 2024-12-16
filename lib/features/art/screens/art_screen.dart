import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../constants/global_variables.dart';

class ArtsScreen extends StatefulWidget {
  const ArtsScreen({super.key});

  @override
  State<ArtsScreen> createState() => _ArtsScreenState();
}

class _ArtsScreenState extends State<ArtsScreen> {
  var textcontroller = TextEditingController();
  String image = '';
  var isLoaded = false;
  List<FileSystemEntity> imgList = [];

  getimages() async {
    final directory = Directory(
        "/storage/emulated/0/Android/data/com.example.pictureai/files/Picture Ai Image/");
    setState(() {
      imgList = directory.listSync();
    });
    print(imgList);
  }

  popimg(filepath) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                clipBehavior: Clip.antiAlias,
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: GlobalVariables.whitecolor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.file(
                  filepath,
                  fit: BoxFit.cover,
                ),
              ),
            ));
  }

  confirmDelete(FileSystemEntity file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this image?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              deleteImage(file);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  deleteImage(FileSystemEntity file) {
    file.deleteSync();
    getimages(); // Refresh the image list
  }

  @override
  void initState() {
    super.initState();
    getimages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: GlobalVariables.whitecolor,
                backgroundColor: GlobalVariables.btncolor,
                shape: const StadiumBorder(),
                minimumSize: Size(5, 40), // Adjust the size as needed
              ),
              onPressed: () async {
                setState(() {
                  isLoaded = false;
                });
                getimages();
              },
              child: Icon(
                Icons.refresh,
              ),
            ),
          ),
        ],
        backgroundColor: GlobalVariables.backgroundColor,
        centerTitle: true,
        title: const Text(
          'Picture AI My Arts',
          style: TextStyle(
            fontFamily: 'Poppins-Bold',
            letterSpacing: 1.0,
            fontSize: 20,
            color: GlobalVariables.whitecolor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            mainAxisExtent: 300,
          ),
          itemCount: imgList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                popimg(imgList[index]);
              },
           child: Column(
  children: [
    Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.file(imgList[index] as File, fit: BoxFit.cover),
      ),
    ),
    GestureDetector(
      onTap: () {
        confirmDelete(imgList[index]);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
),
 );
          },
        ),
      ),
    );
  }
}
