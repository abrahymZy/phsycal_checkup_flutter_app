import 'package:flutter/material.dart';
import 'package:train_flutter_application/service/db_helper.dart';

class Checkup extends StatefulWidget {
  const Checkup({super.key});

  @override
  State<Checkup> createState() => _CheckupState();
}

class _CheckupState extends State<Checkup> {
  TextEditingController txtSearch = TextEditingController();
  TextEditingController txtCheckType = TextEditingController();
  TextEditingController txtDate = TextEditingController();
  int? selectedSickId;
  int? selectedSimpleId;

  List<Map> sickest = [];
  List<Map> simple = [];

  List<Map> checks = [];
  List<Map> filtterChecks = [];

  void searchCheck() {
    final quey = txtSearch.text.toLowerCase();
    setState(() {
      filtterChecks = checks.where((check) {
        final id = check["id_check"].toString().toLowerCase();
        final checkType = check["check_type"].toString().toLowerCase();
        final dateCheck = check["Date_check"].toString().toLowerCase();
        final simples = check["SimpleName"].toString().toLowerCase();
        final sick = check["sickest"].toString().toLowerCase();
        return checkType.contains(quey) |
            id.contains(quey) |
            dateCheck.contains(quey) |
            simples.contains(quey) |
            sick.contains(quey);
      }).toList();
    });
  }

  void loadSickest() async {
    dynamic data = await DbHelper.getSick();
    setState(() {
      sickest = data;
      // debugPrint(data);
    });
  }

  void loadSimples() async {
    dynamic data = await DbHelper.getSimple();
    setState(() {
      simple = data;
      debugPrint('Simples');
      debugPrint(data.toString());
    });
  }

  void loadCheckup() async {
    dynamic data = await DbHelper.getCheckup();
    setState(() {
      checks = data;
      filtterChecks = data;
      debugPrint(data.toString());
    });
  }

  void addCheckup() {
    txtCheckType.clear();
    txtDate.clear();
    selectedSickId = null;
    selectedSimpleId = null;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text('إضافة فحص'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: txtCheckType,
                decoration: InputDecoration(
                  hintText: 'نوع الفحص',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.medical_information_sharp,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.sick),
                  prefixIconColor: Colors.blueAccent,
                ),
                value: selectedSickId,
                hint: Text('اختر مريض'),
                items: sickest
                    .map<DropdownMenuItem<int>>(
                      (d) => DropdownMenuItem<int>(
                        value: d['id_sick'] as int,
                        child: Text(d['name'].toString()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  selectedSickId = value;
                  setState(() {});
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.water_drop),
                  prefixIconColor: Colors.blueAccent,
                ),
                value: selectedSimpleId,
                hint: Text('اختر نوع العينة'),

                items: simple
                    .map<DropdownMenuItem<int>>(
                      (d) => DropdownMenuItem<int>(
                        value: d['id_simple'] as int,
                        child: Text(d['name'].toString()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  selectedSimpleId = value;
                  setState(() {});
                },
              ),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (txtCheckType.text.isNotEmpty &&
                    selectedSickId != null &&
                    selectedSimpleId != null) {
                  DbHelper.insertCheck(
                    checkType: txtCheckType.text,
                    sickId: selectedSickId!,
                    simples: selectedSimpleId!,
                    isReady: 0,
                  );
                  Navigator.pop(context);
                  loadCheckup();
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
        ),
      ),
    );
  }

  void delCheck(int id) {
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text('حدف فحص '),
          content: Text('هل تريد الحدف '),
          actions: [
            ElevatedButton(
              onPressed: () {
                DbHelper.deleteCkeck(id);
                Navigator.pop(context);
                loadCheckup();
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
        ),
      ),
    );
  }

  void editCheck(Map data) {
    txtCheckType.text = data['check_type'];
    txtDate.text = data['Date_check'];
    selectedSickId = data['sick_id'];
    selectedSimpleId = data['simples'];

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text('تعديل بيانات فحص'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: txtCheckType,
                decoration: InputDecoration(
                  hintText: 'نوع الفحص',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: Colors.blue),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: txtDate,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  hintText: ' التاريخ',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money, color: Colors.blue),
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.sick),
                  prefixIconColor: Colors.blueAccent,
                ),
                value: selectedSickId,
                hint: Text('اختر مريض'),
                items: sickest
                    .map<DropdownMenuItem<int>>(
                      (d) => DropdownMenuItem<int>(
                        value: d['id_sick'] as int,
                        child: Text(d['name'].toString()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  selectedSickId = value;
                  setState(() {});
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.water_drop),
                  prefixIconColor: Colors.blueAccent,
                ),
                value: selectedSimpleId,
                hint: Text('اختر نوع العينة'),
                items: simple
                    .map<DropdownMenuItem<int>>(
                      (d) => DropdownMenuItem<int>(
                        value: d['id_simple'] as int,
                        child: Text(d['name'].toString()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  selectedSimpleId = value;
                  setState(() {});
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (txtCheckType.text.isNotEmpty && txtDate.text.isNotEmpty) {
                  DbHelper.updateCheck(
                    checkId: data['id_check'],
                    checkType: txtCheckType.text,
                    dateCheck: txtDate.text,
                    sickId: selectedSickId!,
                    simples: selectedSimpleId!,
                  );
                  Navigator.pop(context);
                  loadCheckup();
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
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadSickest();
    loadCheckup();
    loadSimples();

    txtSearch.addListener(searchCheck);

    // DbHelper.addSimples();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('بيانات الفحوصات'),
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
                hintText: 'بحث عن فحص...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search, color: Colors.blue),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filtterChecks.length,
                itemBuilder: (context, index) => Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Checkbox(
                      value: filtterChecks[index]["isReady"] == 0
                          ? false
                          : true,
                      onChanged: (value) {
                        DbHelper.readyCheck(
                          checkId: filtterChecks[index]["id_check"],
                          isReady: (value!) ? 1 : 0,
                        );
                        setState(() {
                          loadCheckup();
                        });
                      },
                    ),

                    title: Text(
                      filtterChecks[index]["check_type"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      children: [
                        Text(
                          'التاريخ:${filtterChecks[index]["Date_check"]}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'العينات:${filtterChecks[index]["SimpleName"]}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'المريض:${filtterChecks[index]["sickest"]}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            editCheck(filtterChecks[index]);
                          },
                          icon: Icon(Icons.edit, color: Colors.blue),
                        ),
                        IconButton(
                          onPressed: () {
                            delCheck(filtterChecks[index]["id_check"]);
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
        onPressed: addCheckup,
        child: Icon(Icons.add),
      ),
    );
  }
}
