import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:quantum_it/View/Auth/sign_methods.dart';

import '../home_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final textfieldHeadingTextStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20);
  final headingTextStyle =
      TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 30);

  final formKey = GlobalKey<FormState>();
  var emailController = "";
  var passwordController = "";

  TextEditingController resetEmailController = TextEditingController();
  bool toggleIndex = true;
  bool ischecked = true;
  void index_reverse() {
    setState(() {
      toggleIndex = !toggleIndex;
    });
  }

  startauthentication() async {
    final validity = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (validity) {
      formKey.currentState!.save();
      submitform(
        emailController,
        passwordController,
      );
    }
  }

  submitform(
    String email,
    String password,
  ) async {
    final auth = FirebaseAuth.instance;

    UserCredential authResult;
    try {
      if (toggleIndex) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        Get.to(HomePage());
        Fluttertoast.showToast(
            msg: "Login Successful",
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red.shade300,
            textColor: Colors.white,
            fontSize: 16.0);
        index_reverse();
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        Get.to(HomePage());
        Fluttertoast.showToast(
            msg: "Account Created",
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red.shade300,
            textColor: Colors.white,
            fontSize: 16.0);
        index_reverse();
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "$e",
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red.shade300,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color themeColors = Theme.of(context).primaryColor;
    int _tabIconIndexSelected = 0;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: themeColors,
        title: Row(
          children: [
            Text(
              'Social',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            Text(
              'X',
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black38,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    border: Border.all(color: themeColors, width: 3),
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: toggleIndex ? themeColors : Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(27),
                              bottomRight: Radius.circular(27)),
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2.03,
                        child: GestureDetector(
                          onTap: () {
                            index_reverse();
                          },
                          child: Center(
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: !toggleIndex
                                    ? Colors.black38
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: !toggleIndex ? themeColors : Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(27),
                              bottomRight: Radius.circular(27)),
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2.03,
                        child: GestureDetector(
                          onTap: () {
                            index_reverse();
                          },
                          child: Center(
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color:
                                    toggleIndex ? Colors.black38 : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                //Body------------------------------------------------------
                Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(27)),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: toggleIndex
                          ? Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Signin into your',
                                      style: headingTextStyle),
                                  Text(
                                    'Account',
                                    style: headingTextStyle,
                                  ),
                                  size_box(),
                                  Text('Email',
                                      style: textfieldHeadingTextStyle),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    key: ValueKey('email'),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Incorrect';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      emailController = value!;
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.email,
                                        color: themeColors,
                                      ),
                                      hintText: 'jois@gmail.com',
                                    ),
                                  ),
                                  size_box(),
                                  Text('Password',
                                      style: textfieldHeadingTextStyle),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    key: ValueKey('password'),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Incorrect';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      passwordController = value!;
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.lock,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      hintText: 'Passowrd',
                                    ),
                                  ),
                                  size_box(),
                                  custom_button(
                                    pbottom: 0,
                                    pleft:
                                        MediaQuery.of(context).size.width / 3,
                                    ptop: 0,
                                    text: 'Login with',
                                    colour: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    onTap: index_reverse,
                                  ),
                                  size_box(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          AuthService().signInWithGoogle();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                            border: Border.all(
                                                color: Colors.black, width: 3),
                                          ),
                                          child: Image.asset(
                                            'images/google.png',
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          AuthService().signInWithFacebook();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                          ),
                                          child: Image.asset(
                                            'images/facebook.png',
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  size_box(),
                                  size_box(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Don' "'" 't have an Account ?'),
                                      custom_button(
                                        pbottom: 0,
                                        pleft: 0,
                                        ptop: 0,
                                        text: ' Register Now',
                                        colour: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        onTap: index_reverse,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ) //SIGNUP----------------------
                          : Form(
                              key: formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Create an', style: headingTextStyle),
                                    Text('Account', style: headingTextStyle),
                                    size_box(),
                                    Text('Name',
                                        style: textfieldHeadingTextStyle),
                                    TextField(
                                      decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          Icons.person,
                                          color: themeColors,
                                        ),
                                        hintText: 'jois',
                                      ),
                                    ),
                                    size_box(),
                                    Text('Email',
                                        style: textfieldHeadingTextStyle),
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      key: ValueKey('email'),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Incorrect';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        emailController = value!;
                                      },
                                      decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          Icons.email,
                                          color: themeColors,
                                        ),
                                        hintText: 'jois@gmail.com',
                                      ),
                                    ),
                                    size_box(),
                                    Text(
                                      'Contact no',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    IntlPhoneField(
                                      decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          Icons.call,
                                          color: Colors.red,
                                        ),
                                        hintText: '7619129190',
                                      ),
                                      initialCountryCode: 'IN',
                                      onChanged: (phone) {},
                                    ),
                                    size_box(),
                                    Text('Password',
                                        style: textfieldHeadingTextStyle),
                                    TextFormField(
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      key: ValueKey('password'),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Incorrect';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        passwordController = value!;
                                      },
                                      decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          Icons.lock,
                                          color: themeColors,
                                        ),
                                        hintText: '********',
                                      ),
                                    ),
                                    size_box(),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Checkbox(
                                              side: BorderSide(
                                                  color: Colors.red, width: 2),
                                              activeColor: Colors.red,
                                              checkColor: Colors.white,
                                              value: ischecked,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  ischecked = value!;
                                                });
                                              }),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12.0),
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: 'I agree with  ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        shadows: [
                                                          Shadow(
                                                              offset: Offset(
                                                                  0, -10),
                                                              color:
                                                                  Colors.black)
                                                        ],
                                                      )),
                                                  TextSpan(
                                                    text: 'term & condition',
                                                    style: TextStyle(
                                                        shadows: [
                                                          Shadow(
                                                              offset: Offset(
                                                                  0, -10),
                                                              color: Colors.red)
                                                        ],
                                                        color:
                                                            Colors.transparent,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        decorationColor:
                                                            Colors.red,
                                                        decorationThickness: 3,
                                                        decorationStyle:
                                                            TextDecorationStyle
                                                                .solid,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                    size_box(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Already have an Account ?'),
                                        custom_button(
                                          pbottom: 0,
                                          pleft: 0,
                                          ptop: 0,
                                          text: ' Sign In!',
                                          colour: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          onTap: index_reverse,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )),
                ),
                // Login / Register ----------------------------

                size_box(),

                Container(
                    height: 110,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: themeColors,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                    ),
                    child: toggleIndex
                        ? Center(
                            child:
                                //  ElevatedButton(child: Text('login'),onPressed: (){},)
                                custom_button(
                              colour: Colors.white70,
                              pbottom: 0,
                              pleft: 0,
                              ptop: 0,
                              fontWeight: FontWeight.bold,
                              text: 'LOGIN',
                              onTap: startauthentication,
                            ),
                          )
                        : Center(
                            child: custom_button(
                              colour: Colors.white70,
                              pbottom: 0,
                              pleft: 0,
                              ptop: 0,
                              fontWeight: FontWeight.bold,
                              text: 'Resgister',
                              onTap: startauthentication,
                            ),
                          )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class custom_button extends StatelessWidget {
  final Function onTap;
  custom_button({
    Key? key,
    required this.fontWeight,
    required this.colour,
    required this.text,
    required this.ptop,
    required this.pbottom,
    required this.pleft,
    required this.onTap,
  }) : super(key: key);
  String text;
  Color colour;
  double pleft;
  double ptop;
  double pbottom;
  FontWeight fontWeight;

  //fontSize _fontSize;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: pleft, top: ptop, bottom: pbottom),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Text(
          text,
          style: TextStyle(color: colour, fontWeight: fontWeight, fontSize: 20),
        ),
      ),
    );
  }
}

class size_box extends StatelessWidget {
  const size_box({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15,
    );
  }
}
