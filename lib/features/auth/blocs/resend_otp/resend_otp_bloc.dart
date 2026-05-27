import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/auth/repositories/auth_repositories.dart';

part 'resend_otp_event.dart';
part 'resend_otp_state.dart';

class ResendOtpBloc extends Bloc<ResendOtpEvent, ResendOtpState> {
  final AuthRepository _repo = AuthRepository();
  ResendOtpBloc() : super(ResendOtpInitial()) {
    on<ResendOtpEvent>((event, emit) async {
      emit(ResendOtpLoading());
      final result = await _repo.resendOtp(email: event.email);

      result.fold(
        (l) => emit(ResendOtpFailure(msg: l)),
        (r) => emit(ResendOtpLoaded(msg: r)),
      );
    });
  }
}
