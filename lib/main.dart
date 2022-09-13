import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/module/task.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.lightBlueAccent,
      brightness: Brightness.light,
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final firestore=FirebaseFirestore.instance;
  bool? isChecked=false;
  String taskvalue = "";
  List<Task> todoo=[];
  // List todo = [];
  String input='';
  bool isdone=false;
  creatTodo<AsyncSnapshot>(input)
  {
    DocumentReference documentReference=FirebaseFirestore.instance.collection("Mytodo").doc(input);
 Map<String,String>todo={"todo":input};
 // Map<String,bool>isdone={"isdone":false};
 documentReference.set(todo).whenComplete(() {
   print("$input created");
 });

 // documentReference.set(isdone);
  }
deletTodo<AsyncSnapshot>(item) {
  DocumentReference documentReference = FirebaseFirestore.instance.collection(
      "Mytodo").doc(item);
  documentReference.delete();

}
  Widget bottomShhet(BuildContext context) {
    return Container(
      color: const Color(0xff757575),
      child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                  child: Text(
                "Add Task",
                style: TextStyle(color: Colors.lightBlueAccent),
              )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                onChanged: (newvalue) {
                  taskvalue = newvalue;
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              FlatButton(
                onPressed: () {
                  creatTodo(taskvalue);
                 Navigator.pop(context);
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.lightBlueAccent,
              ),
            ],
          )),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(context: context, builder: bottomShhet);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      appBar: AppBar(
        title: const Text('Mytodo'),
      ),
      body: StreamBuilder<QuerySnapshot<Object>>(
        stream: FirebaseFirestore.instance.collection("Mytodo").snapshots(),
        builder: (context,snapshots){
          return ListView.builder(
            itemBuilder: (context, index) {
              DocumentSnapshot documentSnapshot=snapshots.data!.docs[index] ;
              // var task=documentSnapshot['isdone'];
              return Card(
                color: Colors.lightBlueAccent,
                  margin: EdgeInsets.all(10),
                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)) ,
                  elevation: 10.0,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(documentSnapshot['todo'],style: TextStyle(
                          color: Colors.white,
                          // decoration: task?TextDecoration.lineThrough:null,
                        ),),
                        trailing: IconButton(icon:Icon(Icons.delete),onPressed: (){
                          deletTodo(documentSnapshot['todo']);
                        },color: Colors.red,),
                      ),
                    ],
                  ),
                );
            },
            itemCount: snapshots.data!.docs.length,
          );
        },
      ),
    );
  }
}
