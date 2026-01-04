import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/models/token.dart';
import 'package:music_player/models/user.dart';
import 'package:music_player/services/auth-service.dart';
import 'package:music_player/views/login-page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  bool isMale = false;
  bool isObscurePassword = true;
  bool isObscureConfirmedPassword = true;

  var nameController = TextEditingController();
  var nicknameController = TextEditingController();
  var ageController = TextEditingController();
  var addressController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmedPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Đăng ký tài khoản'),
          centerTitle: true,
          shadowColor: Color(0xFF1DB954),
        ),
        body: RegisterForm(),
      ),
    );
  }

  Widget RegisterForm() {
    return Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Text(
            'Umac 🎧',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1DB954),
            ),
          ),
          SizedBox(height: 40),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              label: Text('Họ và tên'),
              prefixIcon: Icon(Icons.person, color: Color(0xFF1DB954)),
              border: OutlineInputBorder(borderSide: BorderSide()),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Họ và tên không được để trống';
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          TextFormField(
            controller: nicknameController,
            decoration: InputDecoration(
              label: Text('Bí danh'),
              prefixIcon: Icon(Icons.edit, color: Color(0xFF1DB954)),
              border: OutlineInputBorder(borderSide: BorderSide()),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bí danh không được để trống';
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          TextFormField(
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              label: Text('Tuổi'),
              prefixIcon: Icon(Icons.cake_rounded, color: Color(0xFF1DB954)),
              border: OutlineInputBorder(borderSide: BorderSide()),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tuổi không được để trống';
              }
              if (int.tryParse(value)! < 6) {
                return 'Tuổi phải từ 6 tuổi trở lên';
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text('Giới tính nam'),
            value: isMale,
            checkColor: Colors.white,
            onChanged: (value) {
              setState(() {
                isMale = !isMale;
              });
            },
          ),
          SizedBox(height: 24),
          TextFormField(
            controller: addressController,
            decoration: InputDecoration(
              label: Text('Địa chỉ'),
              prefixIcon: Icon(Icons.home, color: Color(0xFF1DB954)),
              border: OutlineInputBorder(borderSide: BorderSide()),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Địa chỉ không được để trống';
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          TextFormField(
            controller: phoneNumberController,
            decoration: InputDecoration(
              label: Text('Số điện thoại'),
              prefixIcon: Icon(Icons.phone, color: Color(0xFF1DB954)),
              border: OutlineInputBorder(borderSide: BorderSide()),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Số điện thoại không được để trống';
              }
              if (!RegExp(r'^0\d{9}$').hasMatch(value)) {
                return 'Số điện thoại không hợp lệ';
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              label: Text('Email'),
              prefixIcon: Icon(Icons.alternate_email, color: Color(0xFF1DB954)),
              border: OutlineInputBorder(borderSide: BorderSide()),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email không được để trống';
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
            obscureText: isObscurePassword,
            decoration: InputDecoration(
              label: Text('Mật khẩu'),
              prefixIcon: Icon(Icons.lock, color: Color(0xFF1DB954)),
              border: OutlineInputBorder(borderSide: BorderSide()),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isObscurePassword = !isObscurePassword;
                  });
                },
                icon: Icon(
                  isObscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mật khẩu không được để trống';
              }
              if (value.length < 4) {
                return 'Mật khẩu phải có ít nhất 4 ký tự';
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          TextFormField(
            controller: confirmedPasswordController,
            obscureText: isObscureConfirmedPassword,
            decoration: InputDecoration(
              label: Text('Xác nhận mật khẩu'),
              prefixIcon: Icon(Icons.lock_person, color: Color(0xFF1DB954)),
              border: OutlineInputBorder(borderSide: BorderSide()),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isObscureConfirmedPassword = !isObscureConfirmedPassword;
                  });
                },
                icon: Icon(
                  isObscureConfirmedPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Xác nhận mật khẩu không được để trống';
              }
              if (value.length < 4) {
                return 'Xác nhận mật khẩu phải có ít nhất 4 ký tự';
              }
              if (value != passwordController.text) {
                return "Mật khẩu xác nhận không khớp";
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
                User user = User(
                  name: nameController.text,
                  nickname: nicknameController.text,
                  age: int.tryParse(ageController.text)!,
                  isMale: isMale,
                  address: addressController.text,
                  phoneNumber: phoneNumberController.text,
                  email: emailController.text,
                  password: passwordController.text,
                );

                AuthService authService = AuthService();
                Token? token = await authService.register(user);

                if (token != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đăng ký thành công')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đăng ký thất bại')),
                  );
                }
              }
            },
            child: Text('Đăng ký'),
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
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text('Đã có tài khoản'),
          ),
        ],
      ),
    );
  }
}
