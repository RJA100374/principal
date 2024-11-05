import 'package:flutter/material.dart';
import '../auth/register_page.dart';
import '../events.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState()=> _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async{
    try{
      final res = await Supabase.instance.client.auth.signInWithPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      if(res.session != null){
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder:(context)=> EventsController()));
      }else{
        setState(() {
          errorMessage = 'please enter your credentials';
        });
      }
    }catch(e){
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('LOGIN')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "please enter your email";
                    }else if(!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)){
                      return "please enter a valid email";
                    }
                    return null;
                  }
              ),
              TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "please enter your password";
                    }else if(value.length < 8){
                      return "please enter a longer password";
                    }
                    return null;
                  }
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      signIn();
                    }
                  },
                  child: Text('Log In')
              ),
              SizedBox(height: 10),
              if(errorMessage.isNotEmpty) Text(errorMessage, style: TextStyle(color: Colors.red)),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text('You do not have an account, register here')
              )

            ],
          ),
        )

      ),
    );
  }
}




