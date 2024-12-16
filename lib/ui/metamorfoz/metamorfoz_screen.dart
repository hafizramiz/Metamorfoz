import 'package:flutter/material.dart';

import '../core/localization/applocalization.dart';
import '../core/ui/error_indicator.dart';
import '../home/view_models/home_viewmodel.dart';

class MetamorfozScreen extends StatefulWidget {
  const MetamorfozScreen({
    super.key,
    required this.viewModel,
  });

  /// final parametere olarak tanimlanir.
  final HomeViewModel viewModel;

  @override
  State<MetamorfozScreen> createState() => _MetamorfozScreenState();
}

/// Artik View model icindeki state'e erisebiliriz.

class _MetamorfozScreenState extends State<MetamorfozScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.deleteBooking.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant MetamorfozScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.deleteBooking.removeListener(_onResult);
    widget.viewModel.deleteBooking.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.deleteBooking.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Metamorfoz Screen"),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   // Workaround for https://github.com/flutter/flutter/issues/115358#issuecomment-2117157419
      //   heroTag: null,
      //   key: const ValueKey(bookingButtonKey),
      //   onPressed: () => context.go(Routes.search),
      //   label: Text(AppLocalization.of(context).bookNewTrip),
      //   icon: const Icon(Icons.add_location_outlined),
      // ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: ListenableBuilder(
          listenable: widget.viewModel.load,
          builder: (context, child) {
            print("ListenableBuilder called");

            if (widget.viewModel.load.running) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (widget.viewModel.load.error) {
              return ErrorIndicator(
                title: AppLocalization.of(context).errorWhileLoadingHome,
                label: AppLocalization.of(context).tryAgain,
                onPressed: widget.viewModel.load.execute,
              );
            }

            /// Burda diger ikisini gecerse else case'de child widget dondurulur.
            return child!;
          },
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              return Dismissible(
                key: Key("data"),
                direction: DismissDirection.endToStart,
                child: Text("data"),
                onDismissed: (direction) {
                  widget.viewModel.deleteBooking.execute(1);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _onResult() {
    if (widget.viewModel.deleteBooking.completed) {
      widget.viewModel.deleteBooking.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalization.of(context).bookingDeleted),
        ),
      );
    }

    if (widget.viewModel.deleteBooking.error) {
      widget.viewModel.deleteBooking.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalization.of(context).errorWhileDeletingBooking),
        ),
      );
    }
  }
}
