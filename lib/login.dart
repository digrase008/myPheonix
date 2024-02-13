import 'package:flutter/material.dart';
import 'package:my_pheonix/FormController/IntrestedLanding.dart';
import 'Utility/AppColor.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Form',
      theme: ThemeData(
        primarySwatch: AppColors.primaryMaterialColor,
      ),
      home: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'User ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return 'Please enter a valid user ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if ((value?.isEmpty ?? false) || (value?.length ?? 0) < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null && _formKey.currentState!.validate())  {
                    // Perform login functionality here
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    // print('UserID: $email\nPassword: $password');
                    /*Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => IntrestedLanding()),
                    );*/
                    
                    if (email == 'Advaya' && password == 'Advaya') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>  IntrestedLanding()),
                    );
                    } else {
                      showDialog(
                      context: context,
                      builder: (BuildContext context) {
                      return AlertDialog(
                          title: const Text('Login Failed'),
                          content: const Text('Invalid username or password.'),
                          actions: <Widget>[
                        TextButton(
                            onPressed: () {
                          Navigator.of(context).pop();
                         },
                     child: const Text('OK'),
                        ),
                      ],
                      );
                    },
                  );
                    } 
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 20.0,
          alignment: Alignment.center,
          child: const Text(
            '@Powered by Advaya',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
