import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File? _pickedImage;
  bool imgExits = false;
  late String url;
  String scannedText = "";

  Future _pickCamera() async {
    try {
      final pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 10);
      if (pickedImage == null) return;

      final pickedImageFile = File(pickedImage.path);

      setState(() {
        _pickedImage = pickedImageFile;
        imgExits = true;
      });
      getRecognisedText(pickedImage);
    } on PlatformException catch (e) {
      print("Fasho $e");
    }
  }

  Future _pickGalery() async {
    try {
      final pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 10);
      if (pickedImage == null) return;

      final pickedImageFile = File(pickedImage.path);

      setState(() {
        _pickedImage = pickedImageFile;
        imgExits = true;
      });
      getRecognisedText(pickedImage);
    } on PlatformException catch (e) {
      print("Fasho  $e");
    }
  }

  Future _pickImageRemove() async {
    setState(() {
      _pickedImage = null;
      imgExits = false;
      scannedText = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Opciones de Camara'),
        ),
        body: Stack(
          children: [
            Positioned(top: 0, child: BacdgroundCamera()),
            Positioned(
              right: 0,
              top: 0,
              child: TextButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.greenAccent)),
                onPressed: (){
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => textScan( texto: scannedText,)));
                },
                
                icon: const Icon(Icons.document_scanner, color: Colors.white),
                label: const Text('Convertir a Texto',style: TextStyle(color: Colors.white),),
              ),
            ),
            Positioned(
              right: 0,
              top: 70,
              child: TextButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
                onPressed: () {
                   _pickImageRemove();
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Imagen eliminada!", style: TextStyle(color: Colors.black),),
                      backgroundColor: Colors.white,
                    ));
                   },
                icon: const Icon(Icons.remove_circle, color: Colors.white),
                label: const Text(
                  'Remover imagen',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.add_event,
            backgroundColor: Colors.orange.shade900,
            closeManually: true,
            children: [
              SpeedDialChild(
                  child: const Icon(Icons.camera_alt),
                  label: 'Camara',
                  onTap: () => _pickCamera()),
              SpeedDialChild(
                  child: const Icon(Icons.image),
                  label: 'Galeria',
                  onTap: () => _pickGalery()),
            ]));
  }

  Widget BacdgroundCamera() {
    if (imgExits == false) {
      return Container(
        height: 200,
        width: 200,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.white, blurRadius: 1.0),
          ],
        ),
      );
    } else {
      return SizedBox(
          width: 410,
          height: 600,
          child: Image.file(
            _pickedImage!,
            fit: BoxFit.contain,
          ));
    }
  }

  void getRecognisedText(XFile imagen) async {
    final inputImagen = InputImage.fromFilePath(imagen.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText =
        await textDetector.processImage(inputImagen);
    await textDetector.close();

    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
  }
}

class textScan extends StatelessWidget {
  String texto;
  textScan({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Texto Reconocido'),
              TextButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: texto));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Copiado con exito!", style: TextStyle(color: Colors.black),),
                      backgroundColor: Colors.white,
                    ));
                  },
                  icon: const Icon(Icons.copy_all, size: 20, color: Colors.white),
                  label: const Text('Copiar todo', style: TextStyle(fontSize: 20, color: Colors.white), ))
            ],
          ),
          
        ),
        body: SingleChildScrollView(child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(texto))));
  }
}