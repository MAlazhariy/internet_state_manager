import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_state_manager/src/bloc/internet_manager_cubit.dart';
import 'package:internet_state_manager/src/utils/internet_state_manager_controller.dart';
import 'package:flutter/material.dart';

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
    if(!getOptions.autoCheckConnection) {
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
    final backgroundColor = options.errorBackgroundColor ?? Theme.of(context).colorScheme.error;
    final textColor = options.onBackgroundColor ?? Theme.of(context).colorScheme.onError;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: textColor),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            BlocBuilder<InternetManagerCubit, InternetManagerState>(
              builder: (context, state) {
                if (context.read<InternetManagerCubit>().disconnectedToLocalNetwork) {
                  return const SizedBox(height: 50);
                }

                return state.loading
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 13,
                        ),
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 23,
                          height: 23,
                          child: CircularProgressIndicator.adaptive(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(textColor),
                            backgroundColor: Platform.isIOS ? textColor : null,
                          ),
                        ),
                      )
                    : TextButton(
                        onPressed: () async {
                          await _onTryAgain();
                        },
                        child: Text(
                          options.labels.tryAgainText(),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: textColor),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );

    // return Padding(
    //   padding: const EdgeInsets.all(16),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       const Icon(
    //         Icons.cloud_off,
    //         size: 80,
    //         color: kGreyTextColor,
    //       ),
    //       const SizedBox(height: AppSize.s14),
    //       Text(
    //         'no_internet'.tr(),
    //         style: kBoldFontStyle.copyWith(
    //           fontSize: AppSize.s20,
    //         ),
    //         textAlign: TextAlign.center,
    //       ),
    //       Text(
    //         'check_internet'.tr(),
    //         style: kRegularFontStyle,
    //       ),
    //       const SizedBox(height: AppSize.s10),
    //       Consumer<InternetProvider>(
    //         builder: (context, internetProvider, _) {
    //           return internetProvider.loading
    //               ? Container(
    //                   padding: const EdgeInsets.symmetric(
    //                     vertical: 13,
    //                   ),
    //                   alignment: Alignment.center,
    //                   child: SizedBox(
    //                     width: 25,
    //                     height: 25,
    //                     child: CircularProgressIndicator.adaptive(
    //                       strokeWidth: 3,
    //                       valueColor: const AlwaysStoppedAnimation<Color>(kGreyTextColor),
    //                       backgroundColor: Platform.isIOS ? kGreyTextColor : null,
    //                     ),
    //                   ),
    //                 )
    //               : MaterialButton(
    //                   onPressed: _onPressed,
    //                   child: Text('try_again'.tr()),
    //                 );
    //         },
    //       ),
    //       const SizedBox(height: 5),
    //     ],
    //   ),
    // );
  }
}
