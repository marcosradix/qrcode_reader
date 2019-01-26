import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String barcode = "";
  final snackBar = new SnackBar(
    content: new Text("Texto copiado com sucesso!"),
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          key: this._scaffoldKey,
          appBar: new AppBar(
            backgroundColor: Colors.amberAccent,
            title: new Text('Leitor QRCODE'),
          ),
          body: new Center(
            child: new Column(
              children: <Widget>[
                new IconButton(
                  icon: new Icon(
                      const IconData(0xe8fc, fontFamily: 'MaterialIcons')),
                  tooltip: 'Ler código',
                  onPressed: () {
                    scan();
                  },
                ),
                new TextField(
                  controller: new TextEditingController.fromValue(
                      new TextEditingValue(text: barcode)),
                  style: Theme.of(context).textTheme.body2,
                  decoration: new InputDecoration(
                    hintText: 'aqui ficará o código encontrado.',
                    labelText: "QRcode",
                    labelStyle: Theme.of(context).textTheme.display1,
                    contentPadding: new EdgeInsets.all(8.0),
                  ),
                ),
                new Divider(),
                new Container(
                  width: 330.0,
                  height: 40.0,
                  child: new RaisedButton(
                    color: Colors.amberAccent,
                    child: new Text("Copiar"),
                    onPressed: () {
                      Clipboard.setData(new ClipboardData(text: barcode));
                      this._scaffoldKey.currentState.showSnackBar(snackBar);
                    },
                  ),
                ),
                new Divider(),
                new Container(
                  width: 330.0,
                  height: 40.0,
                  child: new RaisedButton(
                    color: Colors.amberAccent,
                    child: new Text("Limpar"),
                    onPressed: () {
                      setState(() => barcode = "");
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'Usuário não concedeu permissão para a câmera';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode = '(Não foi possível ler o código)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
