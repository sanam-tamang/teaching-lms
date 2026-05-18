import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/extension/context_extension.dart';
import 'package:lms/core/widgets/custom_text_field.dart';
import 'package:lms/core/widgets/primary_btn.dart';
import 'package:lms/features/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:lms/features/auth/models/sign_up.dart';
import 'package:lms/features/auth/pages/verify_otp.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isObscure = true;

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Sign up",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 24),

                CustomTextField(
                  controller: _nameController,
                  label: "Name",
                  hintText: "Enter your name",
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length <= 3) {
                      return "Name cannot be less than 3";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),

                CustomTextField(
                  controller: _emailController,
                  label: "Email",
                  hintText: "Enter your email",
                  validator: (value) {
                    if (!EmailValidator.validate(value!)) {
                      return "Enter your valid email";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),

                CustomTextField(
                  controller: _passwordController,
                  label: "Password",
                  hintText: "Enter your password",
                  isObscure: _isObscure,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length <= 5) {
                      return "Password cannot be less than 5";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 24),
                BlocListener<SignUpBloc, SignUpState>(
                  listener: (context, state) {
                    if (state is SignUpLoading) {
                      context.showLoadingDialog();
                    } else if (state is SignUpLoaded) {
                      context.showSnackbar(state.msg);
                      context.pop();

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              VerifyOtp(email: _emailController.text),
                        ),
                      );
                    } else if (state is SignUpFailure) {
                      context.showSnackbar(state.msg);

                      context.pop();
                    }
                  },
                  child: PrimaryBtn(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == false) return;
                      final signup = SignUpFormModel(
                        name: _nameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      context.read<SignUpBloc>().add(SignUpEvent(signup));
                    },
                    child: Text("Hello"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
