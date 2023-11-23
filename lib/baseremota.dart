import 'package:cloud_firestore/cloud_firestore.dart';

var baseRemota = FirebaseFirestore.instance;

class DB{
  static Future<List> mostrarTodos() async{
    List temporal = [];
    var query = await baseRemota.collection("contactos").get();

    query.docs.forEach((Element) {
      Map<String, dynamic> dataTemp = Element.data();
      dataTemp.addAll({'id':Element.id});
      temporal.add(dataTemp);
    });
    return temporal;
  }

  static Future insertar(Map<String, dynamic> persona) async{
    return await baseRemota.collection("contactos").add(persona);
  }

  static Future eliminar(String id) async {
    return await baseRemota.collection("contactos").doc(id).delete();
  }

  static Future actualizar(Map<String, dynamic> persona) async{
    String idActualizar = persona["id"];
    persona.remove("id");
    return await baseRemota.collection("contactos").doc(idActualizar).update(persona);
  }
}