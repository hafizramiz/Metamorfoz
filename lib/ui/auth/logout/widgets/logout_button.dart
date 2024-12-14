// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metamorfoz/ui/home/widgets/home_screen.dart';

import '../../../core/localization/applocalization.dart';
import '../../../core/themes/colors.dart';
import '../view_models/logout_viewmodel.dart';


/// View nedir?
/// View bazen tum ekran olabilir. Kendine ait bir scaffoldu olan altinda da
/// widget'lari olan. [HomeScreen] gibi
/// Bazen de sadece tek bir UI elementi olabilir. [LogoutButton] gibi.
/// Komple uygulamanin diger alanlarinda kullanilmak uzere kendi icinde fonksiyonlari olan
/// bir widget olabilir. [LogoutButton] gibi. Bu da bir view'dir.
/// [LogoutButton] view'nin ayrica bir view model'i [LogoutViewModel] vardir.



class LogoutButton extends StatefulWidget {
  const LogoutButton({
    super.key,
    required this.viewModel,
  });

  final LogoutViewModel viewModel;

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.logout.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant LogoutButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.logout.removeListener(_onResult);
    widget.viewModel.logout.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.logout.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      width: 40.0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey1),
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.transparent,
        ),
        child: InkResponse(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            widget.viewModel.logout.execute();
          },
          child: Center(
            child: Icon(
              size: 24.0,
              Icons.logout,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  void _onResult() {
    // We do not need to navigate to `/login` on logout,
    // it is done automatically by GoRouter.

    if (widget.viewModel.logout.error) {
      widget.viewModel.logout.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalization.of(context).errorWhileLogout),
          action: SnackBarAction(
            label: AppLocalization.of(context).tryAgain,
            onPressed: widget.viewModel.logout.execute,
          ),
        ),
      );
    }
  }
}
