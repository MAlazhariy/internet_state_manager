import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_state_manager/src/bloc/internet_manager_cubit.dart';
import 'package:internet_state_manager/src/utils/internet_state_manager_controller.dart';
import 'package:flutter/material.dart';

import 'app_circular_progress.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  final options = InternetStateManagerController.instance.options;

  // check internet connection every minute until connected to the internet
  late final _checkInternetStreamPeriodic = Stream.periodic(
    getOptions.checkConnectionPeriodic,
    (count) async {
      if (!mounted) return;
      context.read<InternetManagerCubit>().checkConnection();
    },
  );
  StreamSubscription? _sub;

  Future<void> _onTryAgain() async {
    _sub?.pause();
    await context.read<InternetManagerCubit>().checkConnection();
    _sub?.resume();
  }

  @override
  void initState() {
    if (!getOptions.autoCheckConnection) {
      _sub = _checkInternetStreamPeriodic.asyncMap((event) async => await event).listen((event) {});
    }
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Icon(
            Icons.cloud_off,
            size: 80,
          ),
          const SizedBox(height: 14),
          Text(
            options.labels.noInternetTitle(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            options.labels.descriptionText(),
          ),
          const SizedBox(height: 10),

          // Retry button
          BlocBuilder<InternetManagerCubit, InternetManagerState>(
            builder: (context, state) {
              if (context.read<InternetManagerCubit>().disconnectedToLocalNetwork) {
                return const SizedBox(height: 50);
              } else if (state.loading) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 13,
                  ),
                  alignment: Alignment.center,
                  child: AppCircularProgress(),
                );
              }

              return MaterialButton(
                onPressed: () async {
                  await _onTryAgain();
                },
                child: Text(
                  options.labels.tryAgainText(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
