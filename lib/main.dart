import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/blocs/profile/profile_bloc.dart';
import 'package:lms/core/data/storage/token_service.dart';
import 'package:lms/features/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:lms/features/auth/pages/sign_up.dart';
import 'package:lms/features/auth/verify_otp/verify_otp_bloc.dart';
import 'package:lms/features/home/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignUpBloc()),
        BlocProvider(create: (context) => VerifyOtpBloc()),
        BlocProvider(create: (context) => ProfileBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: TokenService.instance.getAccessToken(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.done &&
                asyncSnapshot.hasData) {
              return asyncSnapshot.data == null ? SignUpPage() : HomePage();
            }
            return Material(child: Center(child: CircularProgressIndicator()));
          },
        ),
      ),
    );
  }
}
