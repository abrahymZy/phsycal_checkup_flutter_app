import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الرئيسية'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'مرحبًا بك في تطبيق الفحوصات',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),

            // شبكة الأيقونات (Grid of mental health conditions)
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2, // ثلاثة أعمدة
              crossAxisSpacing: 16.0, // المسافة بين الأعمدة
              mainAxisSpacing: 16.0, // المسافة بين الصفوف
              children: [
                createCard(
                  context: context,
                  title: "المرضى",
                  icon: Icons.sick,
                  color: Colors.blueAccent,
                  route: '/sick',
                ),
                createCard(
                  context: context,
                  title: 'فحوصات ',
                  icon: Icons.medication_liquid,
                  color: Colors.green,
                  route: '/check',
                ),
                createCard(
                  context: context,
                  title: 'عينات ',
                  icon: Icons.water_drop,
                  color: Colors.red,
                  route: '/simple',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget createCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card( 
        color: color,
        elevation: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 70, color: Colors.white),
            // SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
