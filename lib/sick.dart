import 'package:flutter/material.dart';
import 'service/db_helper.dart';

class Sick extends StatefulWidget {
  const Sick({super.key});

  @override
  State<Sick> createState() => _SickState();
}

class _SickState extends State<Sick> {
  List<Map> sickest = [];
  List<Map> filtterSeckest = [];
  TextEditingController txtSearch = TextEditingController();

  TextEditingController txtName = TextEditingController();
  TextEditingController txtAge = TextEditingController();

  void searchSick() {
    final quey = txtSearch.text.toLowerCase();
    setState(() {
      filtterSeckest = sickest.where((sick) {
        final id = sick["id_sick"].toString().toLowerCase();
        final name = sick["name"].toString().toLowerCase();
        final age = sick["age"].toString().toLowerCase();
        return name.contains(quey) | id.contains(quey) | age.contains(quey);
      }).toList();
    });
  }

  void addSick() {
    txtName.clear();
    txtAge.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text('اضافة مريض'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: txtName,
                decoration: InputDecoration(
                  hintText: 'اسم المريض',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: Colors.blue),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: txtAge,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'عمر المريض',
                  border: OutlineInputBorder(),

                  prefixIcon: Icon(
                    Icons.date_range_outlined,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (txtName.text.isNotEmpty && txtAge.text.isNotEmpty) {
                  DbHelper.insertSick(name: txtName.text, age: txtAge.text);
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

  void editSick(dynamic data) {
    txtName.text = data['name'];
    txtAge.text = data['age'].toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text('تعديل معلومات مريض'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: txtName,
                decoration: InputDecoration(
                  hintText: 'إسم المريض',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: Colors.blue),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: txtAge,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'عمر المريض',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.date_range_outlined,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (txtName.text.isNotEmpty && txtAge.text.isNotEmpty) {
                  DbHelper.updateSick(
                    idSick: data['id_sick'],
                    newName: txtName.text,
                    newAge: txtAge.text,
                  );
                  txtName.clear();
                  txtAge.clear();
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

  void delSick(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text('حذف بيانات مريض'),
          content: Text('هل أنت متأكد من الحذف؟'),
          actions: [
            ElevatedButton(
              onPressed: () {
                DbHelper.deleteSick(id);
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
    dynamic data = await DbHelper.getSick();
    setState(() {
      sickest = data;
      filtterSeckest = data;
      debugPrint(data.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    loadSick();
    searchSick();
    txtSearch.addListener(searchSick);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('بيانات المرضى'),
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
                hintText: 'بحث عن مريض...',
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
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          filtterSeckest[index]["name"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text('العمر:${filtterSeckest[index]["age"]}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            editSick(filtterSeckest[index]);
                            // print(filtter_deptds[index]["Id"]);
                          },
                          icon: Icon(Icons.edit, color: Colors.blue),
                        ),
                        IconButton(
                          onPressed: () {
                            // print(filtter_deptds[index]["id"]);
                            delSick(filtterSeckest[index]["id_sick"]);
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
        onPressed: addSick,
        child: Icon(Icons.add),
      ),
    );
  }
}
