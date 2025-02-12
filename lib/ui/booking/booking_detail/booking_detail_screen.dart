import 'package:flutter/material.dart';

import 'booking_detail_viewmodel.dart';

class BookingDetailScreen extends StatelessWidget {
  final BookingDetailViewModel viewModel;

  const BookingDetailScreen({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: ListenableBuilder(
        listenable: viewModel, // Listen to the new view model
        builder: (context, _) {
          if (viewModel.booking == null) {
            return Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Booking ID: ${viewModel.booking?.id}'),
                Text('Booking Name: ${viewModel.booking?.activity}'),
                // Add more details as needed
              ],
            ),
          );
        },
      ),
    );
  }
}
