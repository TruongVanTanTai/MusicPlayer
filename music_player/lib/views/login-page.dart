import 'package:flutter/material.dart';
import 'package:music_player/models/request/loginRequest.dart';
import 'package:music_player/models/token.dart';
import 'package:music_player/services/auth-service.dart';
import 'package:music_player/views/register-page.dart';
import 'package:music_player/views/songs-page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool isObcure = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Đăng nhập'),
          centerTitle: true,
          shadowColor: Color(0xFF1DB954),
        ),
        body: LoginForm(),
      ),
    );
  }

  Widget LoginForm() {
    return Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.all(24),
        children: [
          SizedBox(height: 50),
          Text(
            'Umac 🎧',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1DB954),
            ),
          ),
          SizedBox(height: 60),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              label: Text('Email'),
              prefixIcon: Icon(Icons.alternate_email, color: Color(0xFF1DB954)),
              border: OutlineInputBorder(borderSide: BorderSide()),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email không được để trống";
              }
              if (!RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              ).hasMatch(value)) {
                return "Email không hợp lệ";
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          TextFormField(
            controller: passwordController,
            obscureText: isObcure,
            decoration: InputDecoration(
              label: Text('Mật khẩu'),
              prefixIcon: Icon(Icons.lock, color: Color(0xFF1DB954)),
              border: OutlineInputBorder(borderSide: BorderSide()),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isObcure = !isObcure;
                  });
                },
                icon: Icon(isObcure ? Icons.visibility : Icons.visibility_off),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Mật khẩu không được để trống";
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1DB954),
              foregroundColor: Colors.black,
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                LoginRequest loginRequest = LoginRequest(
                  email: emailController.text,
                  password: passwordController.text,
                );

                AuthService authService = AuthService();
                Token? token = await authService.login(loginRequest);

                if (token != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đăng nhập thành công')),
                  );
                  print(token);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SongsPage(token: token),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đăng nhập thất bại')),
                  );
                }
              }
            },
            child: Text('Đăng nhập'),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1DB954),
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterPage()),
              );
            },
            child: Text('Chưa có tài khoản'),
          ),
        ],
      ),
    );
  }
}
