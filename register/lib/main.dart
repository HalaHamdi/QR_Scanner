import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:register/models/controller.dart';
import 'package:register/models/scan_data.dart';


void main() {
  runApp(new MaterialApp(
    home: new MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _value = 'one';

  @override
  void initState() {
    super.initState();
  }

  String under_text = "please , remember to choose your sheet first";

  String result = "You didn't scan yet";
  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        final splitted=qrResult.split(",");
        final Map<int,String>person={
          for (int i = 0; i < splitted.length; i++)
            i: splitted[i]
        };
        result =person[0];
        ScanData scanData =ScanData(person[0],person[1]);
        print("Before add");
        under_text = "";
        Add(scanData);
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "camera permission denied";
          under_text = "";
        });
      } else {
        setState(() {
          result = "unknown error  $ex";
          under_text = "";
        });
      }
    } on FormatException {
      setState(() {
        result = "you pressed the back botton before scanning";
        under_text = "";
      });
    } catch (ex) {
      setState(() {
        result = "unknown error  $ex";
        under_text = "";
      });
    }
  }

Future Add(ScanData data)async{
  ScanController scanControl =ScanController((String response){
    print(response);
    if(response==ScanController.STATUS_SUCCESS){
    print("person added successfully");
    }
    else{
      print("Error Occured while adding person");

    }

  });
  print("Inprocess of adding");
  scanControl.AddPerson(data);
}


_showSnackBar(String message){
final snackBar=SnackBar(content: Text(message),);
}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new DropdownButton<String>(
                value: _value,
                items: <DropdownMenuItem<String>>[
                  new DropdownMenuItem(
                    child: new Text('Sheet 1'),
                    value: 'one',
                  ),
                  new DropdownMenuItem(child: new Text('Sheet 2'), value: 'two'),
                  new DropdownMenuItem(child: new Text('Sheet 3'), value: 'two'),
                  new DropdownMenuItem(child: new Text('Sheet 4'), value: 'two'),
                ],
                onChanged: (String value) {
                  setState(() => _value = value);
                },
              ),
            ],
          )),
      body: Column(
        children: [
          Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(result,
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                )
              ]),
          Text(under_text)
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text('Add'),
        onPressed: _scanQR,
      ),
    );
  }
}
