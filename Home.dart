import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //----------------------------------------------------------variables
  File? _image;
  final imagePicker = ImagePicker();
  //---------------------------------------------------------------------------------variables end
  //--------------------------------------------------------------------------------functions
  //--------------------------------------------------------------------------------imageshowfunction
  imageShow() {
    return Container(
      height: 300,
      width: 300,
      child: Center(
        child: _image == null
            ? Text('NO image picked')
            : Image.file(_image!, height: 300, width: 300, fit: BoxFit.contain),
      ),
    );
  }

  //---------------------------------------------------------------------------------imageshow function end
  Future imgpicker() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
        cropimage(File(_image!.path));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Select A Photo', style: TextStyle(fontSize: 18.0))));
      }
    });
  }

  dialogbox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Flexible(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(FontAwesomeIcons.close),
                    ),
                  ],
                ),
                Center(
                    child: Text("Upload Image",
                        style: TextStyle(fontSize: 18, color: Colors.grey))),
                SizedBox(height: 5.0),
                //--------------------------------------------------------------------------------------------image display
                imageShow(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          // minimumSize: Size(0.5, 50),
                          side: BorderSide(color: Colors.grey)),
                      onPressed: () {
                        print("original button pressed");
                      },
                      child: Text(
                        'Original',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                            // minimumSize: Size(0.5, 50),
                            side: BorderSide(color: Colors.grey)),
                        onPressed: () {
                          print("Heart button pressed");
                        },
                        child: ImageIcon(
                          AssetImage('Images/frame_1.png'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                            // minimumSize: Size(0.5, 50),
                            side: BorderSide(color: Colors.grey)),
                        onPressed: () {
                          print("Square button pressed");
                        },
                        child: ImageIcon(
                          AssetImage('Images/frame_2.png'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                            // minimumSize: Size(0.5, 50),
                            side: BorderSide(color: Colors.grey)),
                        onPressed: () {
                          print("round button pressed");
                          roundshapeimage();
                        },
                        child: ImageIcon(
                          AssetImage('Images/frame_3.png'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                            // minimumSize: Size(0.5, 50),
                            side: BorderSide(color: Colors.grey)),
                        onPressed: () {
                          print("rectangle button pressed");
                        },
                        child: ImageIcon(
                          AssetImage('Images/frame_4.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 10, 129, 116),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    onPressed: () {
                      print("Use this Image");
                    },
                    child: Text("Use this image",
                        style: TextStyle(color: Colors.white)))
              ],
            ),
          ),
        );
      },
    );
  }

//----------------------------------------------------------------------------------------------------------image cropping function
  cropimage(File imgFile) async {
    final CroppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarColor: Colors.green,
          toolbarTitle: " ",
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      ],
    );
    if (CroppedFile != null) {
      setState(() {
        imgFile = File(CroppedFile.path);
      });
      imageCache.clear();
    }
  }

//------------------------------------------------------------------------------------------------------------round shape image
  Widget roundshapeimage() {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(300)),
        child: imageShow());
  }

//-----------------------------------------------------------------------------------------------------square shape image

  Widget squareshapeimage() {
    return ClipPath(clipper: square(), child: imageShow());
  }
  //----------------------------------------------------------------------------------functions end

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 250, 247),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Center(child: Text('Add Image / Icon')),
      ),
      body: Column(
        children: [
          Container(
            // margin: EdgeInsets.fromLTRB(5, 10, 5, 400),
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: double.infinity,
              height: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey, width: 1.0),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10.0),
                  Text("Upload Image",
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 10, 129, 116),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    onPressed: () async {
                      var status = await Permission.storage.request();
                      if (status.isGranted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'storage permission granted',
                              style: TextStyle(fontSize: 15.0),
                            ),
                          ),
                        );
                      }
                      imgpicker();
                      dialogbox();
                    },
                    child: Text("Choose from Device",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class square extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
