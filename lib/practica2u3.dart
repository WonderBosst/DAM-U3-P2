import 'package:flutter/material.dart';
import 'package:dam_u3_practica2/baseremota.dart';

class appPractica2 extends StatefulWidget {
  const appPractica2({super.key});

  @override
  State<appPractica2> createState() => _appPractica2State();
}

class _appPractica2State extends State<appPractica2> {
  int _indice = 0;
  final nombre = TextEditingController();
  final correo = TextEditingController();
  final telefono = TextEditingController();
  bool finado = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App de contactos telefonicos"),
      ),
      body: dinamico(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.list, size: 20,),
              label: "Lista general"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add, size: 20,),
              label: "Agregar"),
        ],
        currentIndex: _indice,
        onTap: (valor) {
          setState(() {
            _indice = valor;
          });
        },
      ),
    );
  }

  Widget dinamico() {
    switch (_indice) {
      case 0:
        {
          return listaGeneral();
        }
      case 1:
        {
          return agregar();
        }
      default:
        {
          return listaGeneral();
        }
    }
  }

  Widget listaGeneral() {
    return FutureBuilder(
        future: DB.mostrarTodos(),
        builder: (context, listaJSON) {
          if (listaJSON.hasData) {
            return ListView.builder(
                itemCount: listaJSON.data?.length,
                itemBuilder: (context, indiceTemp) {
                  String nombreContacto = listaJSON.data?[indiceTemp]['nombre'];
                  String correoContacto = listaJSON.data?[indiceTemp]['correo'];
                  int telefonoContacto = listaJSON.data?[indiceTemp]['telefono'];
                  bool finadoContacto = listaJSON.data?[indiceTemp]['finado'] == 'true';
                  String idContacto = listaJSON.data?[indiceTemp]['id'];
                  return ListTile(
                    title: Text("${listaJSON.data?[indiceTemp]['nombre']}"),
                    subtitle: Text(
                        "Telefono: ${listaJSON.data?[indiceTemp]['telefono']}\nCorreo: ${listaJSON.data?[indiceTemp]['correo']}\nFinado: ${listaJSON.data?[indiceTemp]['finado']}"),
                    trailing: IconButton(onPressed: () {
                      DB.eliminar(listaJSON.data?[indiceTemp]['id']).then((
                          value) {
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Se elimino el contacto'),
                            ),
                          );
                        });
                      });
                    },
                        icon: Icon(Icons.delete)),
                    onTap: () {
                      actualizar(
                          nombreContacto, correoContacto, telefonoContacto,
                          finadoContacto, idContacto);
                    },
                  );
                });
          }
          return Center(child: CircularProgressIndicator(),);
        });
  }

  Widget agregar() {
    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        TextField(
          controller: nombre,
          decoration: InputDecoration(
            labelText: "NOMBRE",
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: correo,
          decoration: InputDecoration(
            labelText: "CORREO",
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: telefono,
          decoration: InputDecoration(
            labelText: "TELEFONO",
          ),
        ),
        SizedBox(height: 10,),
        DropdownButton(
          value: finado,
          onChanged: (newValue) {
            setState(() {
              finado = newValue!;
            });
          },
          items: [
            DropdownMenuItem(
              value: true,
              child: Text('Sí'),
            ),
            DropdownMenuItem(
              value: false,
              child: Text('No'),
            ),
          ],
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(onPressed: () {
              var JSONTEMPORAL = {
                'nombre': nombre.text,
                'correo': correo.text,
                'telefono': int.parse(telefono.text),
                'finado': finado,
              };

              DB.insertar(JSONTEMPORAL).then((value) {
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Se inserto el contacto'),
                    ),
                  );
                });
                nombre.text = '';
                correo.text = '';
                telefono.text = '';
                finado = false;
              });
            }, child: Text("Insertar")),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _indice = 0;
                  });
                },
                child: Text("Cancelar")
            ),
          ],
        )
      ],
    );
  }

  void actualizar(String nombreContacto, String correoContacto, int telefonoContacto, bool finadoContacto, String? idContacto) {
    bool nuevoFinado = finadoContacto;
    nombre.text = nombreContacto;
    correo.text = correoContacto;
    telefono.text = telefonoContacto.toString();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 5,
      builder: (builder) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 30,
              right: 30,
              bottom: MediaQuery.of(context).viewInsets.bottom + 50,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombre,
                  decoration: InputDecoration(
                    labelText: "NOMBRE",
                  ),
                ),
                TextField(
                  controller: correo,
                  decoration: InputDecoration(
                    labelText: "CORREO",
                  ),
                ),
                TextField(
                  controller: telefono,
                  decoration: InputDecoration(
                    labelText: "TELEFONO",
                  ),
                  keyboardType: TextInputType.number,
                ),
                DropdownButton(
                  value: nuevoFinado,
                  onChanged: (newValue) {
                    setState(() {
                      nuevoFinado = newValue as bool;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: true,
                      child: Text('Sí'),
                    ),
                    DropdownMenuItem(
                      value: false,
                      child: Text('No'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Map<String, dynamic> datosActualizados = {
                          'nombre': nombre.text,
                          'correo': correo.text,
                          'telefono': int.parse(telefono.text),
                          'finado': nuevoFinado,
                        };

                        Map<String, dynamic> datosActualizadosContacto = Map<String, dynamic>.from({'id': idContacto});
                        datosActualizadosContacto.addAll(datosActualizados);

                        DB.actualizar(datosActualizadosContacto).then((value) {
                          setState(() {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Se actualizó el contacto'),
                              ),
                            );
                          });
                        });
                      },
                      child: Text("Actualizar"),
                    ),
                    SizedBox(width: 20,),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
