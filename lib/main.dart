import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=0fbf71eb";
void main() async {

  runApp(MaterialApp(
     home: Home(),
      theme: ThemeData(
          hintColor: Colors.amber,
          primaryColor: Colors.white,

          //Nao funciona o input...
          //inputDecorationTheme: InputDecorationTheme(
           //   enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber))
          //)
      )

  ));


}

Future<Map> getData() async{

  http.Response response = await http.get(request);
  //print(jsonDecode(response.body));
  return json.decode(response.body);

}

/////////////////////////////////////////////////////////////////////////
///////////////////////////HOME/////////////////////////////////////////
///////////////////////////////////////////////////////////////////////

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _mudouReal(String text){
    if(text.isEmpty){
      _limparCampos();
      return;

    }
      double real = double.parse(text);
      dolarController.text = (real/dolar).toStringAsFixed(2); //2 casas decimais
      euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _mudouDolar(String text){
    if(text.isEmpty){
      _limparCampos();
      return;

    }
      double dolar = double.parse(text);
      realController.text = (dolar * this.dolar).toStringAsFixed(2);
      euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2); // Convertendo em reais e depois dividido em dolar

  }

  void _mudouEuro(String text){
    if(text.isEmpty){
      _limparCampos();
      return;

    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);

  }

  void _limparCampos(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("  Converter  "),
        backgroundColor: Colors.amber,
        centerTitle: true,

    ),
      body: FutureBuilder<Map>(
        future: getData(),
        // ignore: missing_return
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: Text ("Carregando...",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0
                  ),
                  textAlign: TextAlign.center),
              );
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text ("Dados não encontrados!",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0
                    ),
                    textAlign: TextAlign.center,),
                );
              } else {
                dolar=snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro=snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                      Divider(),
                      buildTextField("Reais", "R\$", realController, _mudouReal),

                      Divider(),
                      buildTextField("Dólares", "US\$", dolarController, _mudouDolar),

                      Divider(),
                      buildTextField("Euros", "€\$", euroController, _mudouEuro),

                    ],
                  ),
                );

              }
          }
        })
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController valor, Function change) {
  return TextField(
    controller: valor,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix

    ),
    style: TextStyle(
        color: Colors.amber, fontSize: 25.0
    ),
    onChanged: change,
    keyboardType: TextInputType.number, //SÓ NUMEROS NOS CAMPOS
  );
}
