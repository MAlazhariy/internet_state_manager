import 'dart:async';
import 'dart:io';

import 'package:connection_wrapper/src/models/disconnection_oprions_model.dart';
import 'package:connection_wrapper/src/providers/internet_provider_provider.dart';
import 'package:connection_wrapper/src/utils/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({
    super.key,
    this.customOptions,
  });

  final DisconnectionOptions? customOptions;

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  // check internet connection every minute until connected to the internet
  late final _checkInternetStreamPeriodic = Stream.periodic(widget.customOptions?.checkInternetPeriodic ?? const Duration(minutes: 1), (count) async {
    debugPrint('$count');
    return await Provider.of<InternetProvider>(context, listen: false).checkConnection();
  });
  late StreamSubscription _sub;

  Future<void> _onPressed() async {
    _sub.pause();
    await Provider.of<InternetProvider>(context, listen: false).checkConnection();
    _sub.resume();
  }

  @override
  void initState() {
    super.initState();
    _sub = _checkInternetStreamPeriodic.asyncMap((event) async => await event).listen((event) {});
  }

  @override
  void dispose() {
    super.dispose();
    _sub.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.customOptions?.backgroundColor ?? Constants.disconnectionOptions.backgroundColor ?? Theme.of(context).colorScheme.error;
    final textColor = widget.customOptions?.textColor ?? Constants.disconnectionOptions.textColor ?? Theme.of(context).colorScheme.onError;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 3,
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
              child: Text(
                  'no_internet'.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Consumer<InternetProvider>(
              builder: (context, internetProvider, _) {
                if(internetProvider.connectionStatus == ConnectivityResult.none){
                  return const SizedBox(height: 50);
                }
                return internetProvider.loading
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
                          await _onPressed();
                        },
                        child: Text(
                            'try_again'.tr(),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: textColor,
                          ),
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
