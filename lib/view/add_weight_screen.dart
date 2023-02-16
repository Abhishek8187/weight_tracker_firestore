import 'package:firebase_auth/firebase_auth.dart';
import 'package:weight_tracker_firestore/view/login_screen.dart';
import 'package:weight_tracker_firestore/view/weight_list_screen.dart';
import 'package:weight_tracker_firestore/widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weight_tracker_firestore/utils/utils.dart';
import 'package:intl/intl.dart';

class AddWeightScreen extends StatefulWidget {
  const AddWeightScreen({Key? key}) : super(key: key);

  @override
  State<AddWeightScreen> createState() => _AddWeightScreenState();
}

class _AddWeightScreenState extends State<AddWeightScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final postController = TextEditingController();
  final fireStore = FirebaseFirestore.instance
      .collection('Weights'); //user is name of collection
  bool loading = false;

  void logout() async{
    await _auth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 65),
          child: Text('Add Weight'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              maxLines: 1,
              controller: postController,
              decoration: const InputDecoration(
                  hintText: 'How much you weight today ?',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 50,
            ),
            RoundButton(
                title: 'Add',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  String id = DateTime.now().toString();//giving id..if we dont give then it will create automaticallyy
                  fireStore.doc(id).set({
                    //creating document in collection
                    'Weight': postController.text.toString(),
                    'id': id,
                    'date' : DateFormat('dd-MM-yyyy').format(DateTime.now())
                  }).then(
                        (value) {
                      setState(
                            () {
                          loading = false;
                        },
                      );
                      Utils().toastMessage('Data added');
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>FireStoreScreen()));
                    },
                  ).onError((error, stackTrace) {
                    setState(
                          () {
                        loading = false;
                      },
                    );
                    Utils().toastMessage(error.toString());
                  });
                }),
            SizedBox(height: 30,),
            RoundButton(
              //loading: loading,
              title: 'Logout',
              onTap: () {
                logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
