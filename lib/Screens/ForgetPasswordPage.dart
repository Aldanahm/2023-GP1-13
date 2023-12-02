import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _enteredEmail = TextEditingController();

  @override
  void dispose() {
    _enteredEmail.dispose();
    super.dispose();
  }

  Future<void> passwordReset() async {
    // ... existing code for password reset

    // Snack bar for password reset link sent
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Password reset link sent, please check your email'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Background2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 23,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF694F79)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // Align content to the top
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF694F79),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Enter Your Email, and we will send you a password reset link',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17, color: Color(0xFF694F79)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredEmail.text = value!;
                      },
                      controller: _enteredEmail,
                    ),
                  ),
                  const SizedBox(height: 10),
                  MaterialButton(
                    onPressed: passwordReset,
                    elevation: 9,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFB8A2B9), Color(0xFFA18AAE)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      width: double.infinity,
                      height: 60,
                      child: Center(
                        child: Text(
                          'Send an email',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Color.fromARGB(223, 247, 247, 248),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
