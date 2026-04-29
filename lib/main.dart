import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ListUserDataPage());
  }
}

class ListUserDataPage extends StatefulWidget {
  const ListUserDataPage({super.key});

  @override
  State<ListUserDataPage> createState() => _ListUserDataPageState();
}

class UserModel {
  int? id;
  String nama = "";
  int umur = 0;

  UserModel({this.id, required this.nama, required this.umur});
}

class _ListUserDataPageState extends State<ListUserDataPage> {
  final TextEditingController _nameCTRL = TextEditingController();
  final TextEditingController _umurCTRL = TextEditingController();

  List<UserModel> userList = [
    UserModel(id: 1, nama: "sat", umur: 10),
    UserModel(id: 2, nama: "du", umur: 20),
    UserModel(id: 3, nama: "tig", umur: 10),
    UserModel(id: 4, nama: "empa", umur: 40),
  ];

  void _form(int? id) {
    if (id != null) {
      var user = userList.firstWhere((data) => data.id == id);
      _nameCTRL.text = user.nama;
      _umurCTRL.text = user.umur.toString();
    } else {
      _nameCTRL.clear();
      _umurCTRL.clear();
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsetsGeometry.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCTRL,
              decoration: InputDecoration(hintText: "Nama"),
            ),
            TextField(
              controller: _umurCTRL,
              decoration: InputDecoration(hintText: "Umur"),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () =>
                  _save(id, _nameCTRL.text, int.parse(_umurCTRL.text)),
              child: Text(id == null ? "tambah": "perbarui"),
            ),
          ],
        ),
      ),
    );
  }

  void _save(int? id, String nama, int umur) {
    if (id!=null){
      var user = userList.firstWhere((data) => data.id == id);
      setState(() {
        user.nama = nama;
        user.umur = umur;
      });

    }else{
    var nextId = userList.length + 1;
    var newuser = UserModel(id: nextId, nama: nama, umur: umur);
    setState(() {
      userList.add(newuser);
    });
    }
    Navigator.pop(context);
  }

  void _delete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("konfirmasi Hapus"),
        content: Text("apakah anda yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("batal"),
          ),
          TextButton(

            onPressed:(){
              setState(() => userList.removeWhere((data) => data.id. == id));
              Navigator.pop(context);
            },
            child: Text("hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('user list')),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (ctx, i) => ListTile(
          title: Text(userList[i].nama),
          subtitle: Text("umur: ${userList[i].umur} tahun"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () => _form(userList[i].id as int),
                child: Icon(Icons.edit),
              ),
              TextButton(
                onPressed: () => _delete(userList[i].id as int),
                child: Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _form(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
