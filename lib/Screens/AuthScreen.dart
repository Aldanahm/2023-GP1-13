import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inner_joy/Screens/ForgetPasswordPage.dart';
import 'package:inner_joy/Screens/tabs.dart';
import 'package:google_fonts/google_fonts.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  bool _showVerificationMessage = false;
  bool _showPolicyMessage = false;

  void _togglePolicyMessage() {
    setState(() {
      _showPolicyMessage = !_showPolicyMessage;
    });
  }

  String getHeaderText() {
    return _isLogin ? 'Login' : 'Sign up';
  }

// Inside the _submit() method
  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    try {
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );

        // Log in successful
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const Tabs(selectedIndex: 0)),
        );

        // Show a SnackBar with a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logged in successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );

        // Send email verification link
        await _firebase.currentUser!.sendEmailVerification();

        // Clear the registration fields and show the verification message
        setState(() {
          _enteredEmail = '';
          _enteredPassword = '';
          _enteredUsername = '';
          _showVerificationMessage = true;
        });

        // Save the username to Firebase
        await _firebase.currentUser!
            .updateProfile(displayName: _enteredUsername);

        print(userCredentials);

        // Show a SnackBar with a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Account created successfully! Check your email for verification.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'Authentication Failed. Wrong Email or Password!';

      // Check for specific error codes
      if (error.code == 'user-not-found' || error.code == 'wrong-password') {
        errorMessage = 'Invalid email or password';
      } else if (error.code == 'email-already-in-use') {
        // Handle the error as needed
        errorMessage = 'Email is already in use';
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    }
  }

  void _showPolicyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Policy'),
          content: Text(
            'By registering, you agree that your email address will be the only personal data collected and stored. Only administrators have access to this information to ensure partial anonymity.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getHeaderText(),
                    style: GoogleFonts.nunito(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF694F79),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _form,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Email Address',
                                  labelStyle: GoogleFonts.nunito(
                                    color: Color(0xFF694F79),
                                  ),
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
                                  _enteredEmail = value!;
                                },
                              ),
                              if (!_isLogin)
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Username',
                                    labelStyle: GoogleFonts.nunito(
                                      color: Color(0xFF694F79),
                                    ),
                                  ),
                                  enableSuggestions: false,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.trim().length < 2) {
                                      return 'Please enter a valid username';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enteredUsername = value!;
                                  },
                                ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: GoogleFonts.nunito(
                                    color: Color(0xFF694F79),
                                  ),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredPassword = value!;
                                },
                              ),
                              if (_isLogin)
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        child: Text(
                                          'Forgot Password?',
                                          style: GoogleFonts.nunito(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Color(0xFF694F79),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return const ForgotPasswordPage();
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  onPrimary: Colors.transparent,
                                  minimumSize: Size(double.infinity, 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.all(0),
                                  shadowColor: Colors.transparent,
                                ).copyWith(
                                  overlayColor: MaterialStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  textStyle: MaterialStateProperty.all(
                                    GoogleFonts.nunito(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  foregroundColor:
                                      MaterialStateProperty.resolveWith(
                                    (states) {
                                      if (states
                                          .contains(MaterialState.pressed)) {
                                        return Colors.transparent;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFB8A2B9),
                                        Color(0xFFA18AAE),
                                      ],
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
                                      getHeaderText(),
                                      style: GoogleFonts.nunito(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(
                                  _isLogin
                                      ? 'Create an account'
                                      : 'I already have an account',
                                  style: GoogleFonts.nunito(
                                    color: Color(0xFF694F79),
                                  ),
                                ),
                              ),
                              if (!_isLogin)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        _showPolicyDialog();
                                      },
                                      child: Text(
                                        'Policy',
                                        style: GoogleFonts.nunito(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xFF694F79),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
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
          ),
        ],
      ),
    );
  }
}
