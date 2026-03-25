import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatelessWidget {

  final TextEditingController userController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Newen Traceability Login"),
      ),

      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            TextField(
              controller: userController,
              decoration: InputDecoration(
                  labelText: "Employee ID"
              ),
            ),

            SizedBox(height:20),

            ElevatedButton(
              child: Text("LOGIN"),

              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context)=>DashboardScreen()
                    )
                );
              },
            )

          ],
        ),
      ),
    );
  }
}