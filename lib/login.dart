import 'package:flutter/material.dart';
import 'package:train_flutter_application/service/db_helper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController name = TextEditingController();
  TextEditingController pass = TextEditingController();
  List<Map> users = [];
  String txt = '';
  final _formkey = GlobalKey<FormState>();

  void clearText() {
    name.clear();
    pass.clear();
    txt = '';
    setState(() {});
  }

  void checkLogin() {
    bool state = false;
    for (int i = 0; i < users.length; i++) {
      if (name.text == users[i]["name"] && pass.text == users[i]["password"]) {
        state = true;
        break;
      }
    }
    if (state) {
      // txt='User name is Found';
      Navigator.pushNamed(context, "/HomeScreen");
    } else {
      txt = 'user name is not Found';
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() async {
    users = await DbHelper.getUseres();
  }

  bool _obscurepassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Center(
          child: Text(
            "تطبيق للمختبرات لفحص المرضى\nتم تطويره من إبراهيم محمد عزي\nمحمد مقبول خضيري",
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('تسجيل الدخول', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        // color: Colors.grey,
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/logo.png',
                height: 150,
                width: 150,
                color: Colors.blueAccent,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: name,
                validator: (value) {
                  if (value!.isEmpty) return "يرجى ملئ الحقل";
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'الإسم',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: pass,
                validator: (value) {
                  if (value!.isEmpty) return "يرجى ملئ الحقل";
                  return null;
                },
                obscureText: _obscurepassword,
                decoration: InputDecoration(
                  hintText: 'كلمة السر',

                  prefixIcon: Icon(Icons.lock),
                  // suffixIcon: Icon(Icons.visibility),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _obscurepassword = !_obscurepassword;
                      setState(() {});
                    },
                    icon: Icon(
                      _obscurepassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          checkLogin();
                        }
                      },
                      height: 45,
                      color: Colors.blueAccent,
                      shape: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        'تسجيل الدخول',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: MaterialButton(
                      onPressed: clearText,
                      height: 45,
                      color: Colors.blueAccent,
                      shape: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        'مسح البيانات',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(txt, style: TextStyle(fontSize: 25)),
            ],
          ),
        ),
      ),
    );
  }
}
