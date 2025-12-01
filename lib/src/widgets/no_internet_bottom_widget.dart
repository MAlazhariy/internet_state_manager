import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_state_manager/src/bloc/internet_manager_cubit.dart';
import 'package:internet_state_manager/src/utils/internet_state_manager_controller.dart';
import 'package:flutter/material.dart';

import 'app_circular_progress.dart';

class NoInternetBottomWidget extends StatefulWidget {
  const NoInternetBottomWidget({super.key});

  @override
  State<NoInternetBottomWidget> createState() => _NoInternetBottomWidgetState();
}

class _NoInternetBottomWidgetState extends State<NoInternetBottomWidget> {
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
      _sub = _checkInternetStreamPeriodic
          .asyncMap((event) async => await event)
          .listen((event) {});
    }
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  late final backgroundColor =
      options.errorBackgroundColor ?? Theme.of(context).colorScheme.error;
  late final textColor =
      options.onBackgroundColor ?? Theme.of(context).colorScheme.onError;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 8 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          Icon(
            Icons.cloud_off,
            color: textColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  options.labels.noInternetTitle(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  options.labels.descriptionText(),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: textColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          BlocBuilder<InternetManagerCubit, InternetManagerState>(
            builder: (context, state) {
              if (context
                  .read<InternetManagerCubit>()
                  .disconnectedToLocalNetwork) {
                return const SizedBox(height: 50);
              }

              return state.loading
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                      alignment: Alignment.center,
                      child: AppCircularProgress(
                        size: 23,
                        strokeWidth: 3,
                        color: textColor,
                      ),
                    )
                  : TextButton(
                      onPressed: () async {
                        await _onTryAgain();
                      },
                      child: Text(
                        options.labels.tryAgainText(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: textColor),
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
