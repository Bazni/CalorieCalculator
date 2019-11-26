import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double poids;
  int calorieBase;
  int calorieActivite;
  bool genre = false;
  double age;
  double taille = 170.0;
  int radioSelectionne;
  Map mapActivite = {
    0: "Faible",
    1: "Modere",
    2: "Forte"
  };

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: (() => FocusScope.of(context).requestFocus(new FocusNode())),
        child: new Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: setColor(),
          ),
          body: Center(
            child: new SingleChildScrollView(
              padding: EdgeInsets.all(15.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  padding(),
                  texteAvecStyle("Remplissez tous les champs pour obtenir votre besoin journalier en calories"),
                  padding(),
                  new Card(
                    elevation: 10.0,
                    child: new Column(
                      children: <Widget>[
                        padding(),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            texteAvecStyle("Femme", color: Colors.pink),
                            new Switch(
                                value: genre,
                                inactiveTrackColor: Colors.pink,
                                activeTrackColor: Colors.blue,
                                onChanged: (bool b) {
                                  setState(() {
                                    genre = b;
                                  });
                                }),
                            texteAvecStyle("Homme", color: Colors.blue)
                          ],
                        ),
                        padding(),
                        new RaisedButton(
                          onPressed: () => montrerPicker(),
                          color: setColor(),
                          child: texteAvecStyle(
                            age == null ? "Appuyez pour entrer votre age" : "Votre age est de : ${age.toInt()} ans",
                            color: Colors.white,),

                        ),
                        padding(),
                        texteAvecStyle("Votre taille est de : ${taille.toInt()} cm.", color: setColor()),
                        padding(),
                        new Slider(
                            value: taille,
                            min: 100.0,
                            max: 215.0,
                            activeColor: setColor(),
                            onChanged: (double d) {
                              setState(() {
                                taille = d;
                              });
                            }),
                        padding(),
                        new TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (String str) {
                            setState(() {
                              poids = double.tryParse(str);
                            });
                          },
                          decoration: new InputDecoration(
                              labelText: "Entrez votre poids en Kilos"
                          ),
                        ),
                        padding(),
                        texteAvecStyle("Quelle est votre activite sportive ?", color: setColor()),
                        padding(),
                        rowRadio()
                      ],
                    ),
                  ),
                  padding(),
                  new RaisedButton(
                      color: setColor(),
                      child: texteAvecStyle("Calculer", color: Colors.white),
                      onPressed: calculerNombreDeCalories)
                ],
              ),
            ),
          ),
        )
    );
  }

  Row rowRadio() {
    List<Widget> l = [];
    mapActivite.forEach((key, value) {
      Column colonne = new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Radio(
              value: key,
              activeColor: setColor(),
              groupValue: radioSelectionne,
              onChanged: (Object i) {
                setState(() {
                  radioSelectionne = i;
                });
              }),
          texteAvecStyle(value, color: setColor())
        ],
      );
      l.add(colonne);
    });
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: l,
    );
  }

  Padding padding() {
    return new Padding(padding: EdgeInsets.only(top: 20));
  }

  Future<Null> montrerPicker() async{
    DateTime choix = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now(),
        initialDatePickerMode: DatePickerMode.year
    );
    if (choix != null) {
      Duration difference = new DateTime.now().difference(choix);
      int jours = difference.inDays;
      setState(() {
        age = jours / 365;
      });
    }
  }

  Color setColor() {
    return genre ? Colors.blue : Colors.pink;
  }

  Text texteAvecStyle(String data, {color: Colors.black, fontSize: 15.0}) {
    return new Text(
      data,
      textAlign: TextAlign.center,
      style: new TextStyle(
          color: color,
          fontSize: fontSize),
    );
  }

  void calculerNombreDeCalories() {
    if (age != null && poids != null && radioSelectionne != null) {
      if (genre)
        calorieBase = (66.4730 + (13.7516 * poids) + (5.0033 * taille) - (6.7550 * age)).toInt();
      else
        calorieBase = (655.0955 + (9.5634 * poids) + (1.8496 * taille) - (4.6756 * age)).toInt();
      switch(radioSelectionne) {
        case 0:
          calorieActivite = (calorieBase * 1.2).toInt();
          break;
        case 1:
          calorieActivite = (calorieBase * 1.5).toInt();
          break;
        case 2:
          calorieActivite = (calorieBase * 1.8).toInt();
          break;
        default:
          calorieActivite = calorieBase;
          break;
      }
      setState(() {
        dialogue();
      });
    } else{
      alerte();
    }
  }

  Future<Null> dialogue() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext bc) {
          return SimpleDialog(
            title: texteAvecStyle("Votre besoin en calories", color: setColor()),
            children: <Widget>[
              padding(),
              texteAvecStyle("Votre besoin de base est de: ${calorieBase}"),
              padding(),
              texteAvecStyle("Votre besoin avec activité est de : $calorieActivite"),
              padding(),
              new RaisedButton(
                  color: setColor(),
                  child: texteAvecStyle('OK', color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        }
    );
  }

  Future<Null> alerte() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return new AlertDialog(
            title: texteAvecStyle("Erreur"),
            content: texteAvecStyle("Tous les champs ne sont pas remplis"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: texteAvecStyle("OK", color: Colors.red)
              )
            ],
          );
        }
    );
  }
}
