import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../Utils/utils.dart';
import 'package:weight_tracker_firestore/view/add_weight_screen.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({Key? key}) : super(key: key);

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}



class _FireStoreScreenState extends State<FireStoreScreen> {

  late final editController = TextEditingController();
  CollectionReference ref1 = FirebaseFirestore.instance.collection('Weights');
  final fireStore = FirebaseFirestore.instance
      .collection('Weights').orderBy('date').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 75),
        child: Text('Weight entries'),
      ),),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();
                if(snapshot.hasError)
                  return Text('Error');
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index){
                        return ListTile(
                          title: Text('Weight:  ${snapshot.data!.docs[index]['Weight'].toString()}'),
                          subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                          trailing: PopupMenuButton(
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    value : 1,
                                    child: ListTile(
                                      onTap: (){
                                        Navigator.pop(context);
                                        editDialog(
                                            title: snapshot.data!.docs[index]['Weight'].toString(),
                                            id: snapshot.data!.docs[index]['id'].toString());
                                      },
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                    ) ),
                                PopupMenuItem(
                                    value: 1 ,
                                    child: ListTile(
                                      onTap: (){
                                        Navigator.pop(context);
                                        ref1.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                                      },
                                      leading: Icon(Icons.delete),
                                      title: Text('Delete'),
                                    ) )
                              ]),
                        );
                      }),
                );
              }
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddWeightScreen()));
          }),
    );
  }

  Future<void> editDialog({
    required String title,
    required String id
  })async{
    editController.text = title;
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Update'),
          content: Container(
            child: TextField(
              keyboardType: TextInputType.number,
              controller: editController,
            ),
          ),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text('Cancel')),
            TextButton(onPressed: (){
              ref1.doc(id).update({
                'Weight' : editController.text.toString()
              }).then((value) {
                Utils().toastMessage('Updated');
              }).onError((error, stackTrace) {
                Utils().toastMessage('Error');
              });
              Navigator.pop(context);
            }, child: Text('Update')),
          ],
        );
      },
    );
  }
}
