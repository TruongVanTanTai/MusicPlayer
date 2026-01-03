import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/models/token.dart';
import 'package:music_player/models/user.dart';
import 'package:music_player/services/auth.dart';

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
    return SafeArea(child: Scaffold(body: RegisterForm()));
  }

  Widget RegisterForm() {
    return Form(
      key: formKey,
      child: ListView(
        children: [
          Text('Umac'),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(label: Text('Họ và tên')),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Họ và tên không được để trống';
              }
              return null;
            },
          ),
          TextFormField(
            controller: nicknameController,
            decoration: InputDecoration(label: Text('Bí danh')),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bí danh không được để trống';
              }
              return null;
            },
          ),
          TextFormField(
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(label: Text('Tuổi')),
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
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text('Giới tính nam'),
            value: isMale,
            onChanged: (value) {
              setState(() {
                isMale = !isMale;
              });
            },
          ),
          TextFormField(
            controller: addressController,
            decoration: InputDecoration(label: Text('Địa chỉ')),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Địa chỉ không được để trống';
              }
              return null;
            },
          ),
          TextFormField(
            controller: phoneNumberController,
            decoration: InputDecoration(label: Text('Số điện thoại')),
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
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(label: Text('Email')),
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
          TextFormField(
            controller: passwordController,
            obscureText: isObscurePassword,
            decoration: InputDecoration(
              label: Text('Mật khẩu'),
              suffix: IconButton(
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
          TextFormField(
            controller: confirmedPasswordController,
            obscureText: isObscureConfirmedPassword,
            decoration: InputDecoration(
              label: Text('Xác nhận mật khẩu'),
              suffix: IconButton(
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
          ElevatedButton(
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

                Auth auth = Auth();
                Token? token = await auth.register(user);

                if (token != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đăng ký thành công')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đăng ký thất bại')),
                  );
                }
              }
            },
            child: Text('Đăng ký'),
          ),
          ElevatedButton(onPressed: () {}, child: Text('Đã có tài khoản')),
        ],
      ),
    );
  }
}
