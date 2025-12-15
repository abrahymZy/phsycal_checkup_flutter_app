import 'package:flutter/material.dart';
import 'service/db_helper.dart';

class Simples extends StatefulWidget {
  const Simples({super.key});

  @override
  State<Simples> createState() => _SimplesState();
}

class _SimplesState extends State<Simples> {
  List<Map> simples = [];
  List<Map> filtterSeckest = [];
  TextEditingController txtSearch = TextEditingController();

  TextEditingController txtName = TextEditingController();

  void searchSimple() {
    final quey = txtSearch.text.toLowerCase();
    setState(() {
      filtterSeckest = simples.where((sick) {
        final id = sick["id_sick"].toString().toLowerCase();
        final name = sick["name"].toString().toLowerCase();
        return name.contains(quey) | id.contains(quey);
      }).toList();
    });
  }

  void addSimple() {
    txtName.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text('اضافة عينة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: txtName,
                decoration: InputDecoration(
                  hintText: 'اسم العينة',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: Colors.blue),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (txtName.text.isNotEmpty ) {
                  DbHelper.insertSimple(name: txtName.text);
                  Navigator.pop(context);
                  loadSick();
                }
              },
              child: Text('حفظ'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('الغاء'),
            ),
          ],
        );
      },
    );
  }

  void editSimple(dynamic data) {
    txtName.text = data['name'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text('تعديل إسم عينة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: txtName,
                decoration: InputDecoration(
                  hintText: 'إسم العينة',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: Colors.blue),
                ),
              ),
              SizedBox(height: 10),
              
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (txtName.text.isNotEmpty ) {
                  DbHelper.updateSimple(
                    idSimple: data['id_simple'],
                    newName: txtName.text,
                  );
                  txtName.clear();
                  Navigator.pop(context);
                  loadSick();
                }
              },
              child: Text('حفظ'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('الغاء'),
            ),
          ],
        );
      },
    );
  }

  void delSimple(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text('حذف بيانات udkm'),
          content: Text('هل أنت متأكد من الحذف؟'),
          actions: [
            ElevatedButton(
              onPressed: () {
                DbHelper.deleteSimple(id);
                Navigator.pop(context);
                loadSick();
              },
              child: Text('موافق'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('الغاء'),
            ),
          ],
        );
      },
    );
  }

  void loadSick() async {
    dynamic data = await DbHelper.getSimple();
    setState(() {
      simples = data;
      filtterSeckest = data;
      debugPrint(data.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    loadSick();
    searchSimple();
    txtSearch.addListener(searchSimple);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('بيانات العينات'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: txtSearch,
              decoration: InputDecoration(
                hintText: 'بحث عن عينة...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search, color: Colors.blue),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filtterSeckest.length,
                itemBuilder: (context, index) => Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      // child: Text('${filtter_deptds[index]["id"]}'),
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      filtterSeckest[index]["name"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            editSimple(filtterSeckest[index]);
                            // print(filtter_deptds[index]["Id"]);
                          },
                          icon: Icon(Icons.edit, color: Colors.blue),
                        ),
                        IconButton(
                          onPressed: () {
                            // print(filtter_deptds[index]["id"]);
                            delSimple(filtterSeckest[index]['id_simple']);
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addSimple,
        child: Icon(Icons.add),
      ),
    );
  }
}
