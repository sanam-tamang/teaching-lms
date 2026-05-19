import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/trainer/model/apply_form.dart';
import 'package:lms/features/trainer/repositories/trainer_repositories.dart';

part 'trainer_apply_event.dart';
part 'trainer_apply_state.dart';

class TrainerApplyBloc extends Bloc<TrainerApplyEvent, TrainerApplyState> {
  TrainerApplyBloc() : super(TrainerApplyInitial()) {
    final TrainerRepository _repo = TrainerRepository();
    on<TrainerApplyEvent>((event, emit) async {
      emit(TrainerApplyLoading());
      final result = await _repo.applyForTrainer(event.form);

      result.fold(
        (l) => emit(TrainerApplyFailure()),
        (r) => emit(TrainerApplyLoaded()),
      );
    });
  }
}
