import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/blocs/profile/profile_bloc.dart';
import 'package:lms/features/trainer/pages/apply_trainer.dart';
import 'package:lms/features/trainer/pages/trainer_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ProfileBloc>().add(ProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoaded) {
                    bool hasTrainerProfile = state.profile.hasTrainerProfile;
                    return FilledButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => hasTrainerProfile
                                ? TrainerPage()
                                : ApplyTrainer(),
                          ),
                        );
                      },
                      child: Text(
                        hasTrainerProfile
                            ? "Navigate to Trainer"
                            : "Become a trainer",
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              return Text(state.profile.name);
            } else {
              return CircleAvatar(radius: 30);
            }
          },
        ),
      ),
      body: Text("Home"),
    );
  }
}
