import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/blocs/profile/profile_bloc.dart';
import 'package:lms/core/data/storage/token_service.dart';
import 'package:lms/core/routes/route.dart';
import 'package:lms/core/routes/route_name.dart';
import 'package:lms/features/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:lms/features/auth/pages/sign_up.dart';
import 'package:lms/features/auth/verify_otp/verify_otp_bloc.dart';
import 'package:lms/features/home/pages/home.dart';
import 'package:lms/features/trainer/blocs/apply/trainer_apply_bloc.dart';

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
        BlocProvider(create: (context) => TrainerApplyBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: RouteName.home,
        onGenerateRoute: AppRoute.onGenerateRoute,
        // onGenerateRoute: (settings) {},
        // routes: {"/": (context) => HomePage()},
      ),
    );
  }
}
