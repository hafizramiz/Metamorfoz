// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Dimens kullanimini burda gorebiliriz

/// Bu sinifi inceleersek
/// padding: EdgeInsets.only(
//           left: Dimens.of(context).paddingScreenHorizontal,
//           right: Dimens.of(context).paddingScreenHorizontal,
//           top: Dimens.of(context).paddingScreenVertical,
//           bottom: Dimens.paddingVertical,
//         ),

//Dinamik Değerler (Dimens.of(context)):
// left: Dimens.of(context).paddingScreenHorizontal
// right: Dimens.of(context).paddingScreenHorizontal
// top: Dimens.of(context).paddingScreenVertical
// Bu değerler, Dimens.of(context) ile ekran boyutuna göre seçilen Dimens örneğinden (_DimensMobile veya _DimensDesktop) alınıyor.
// Neden dinamik?:
// paddingScreenHorizontal ve paddingScreenVertical, cihaz türüne (mobil veya masaüstü) göre farklı değerler alır:
// Mobil: paddingScreenHorizontal = 20.0, paddingScreenVertical = 24.0
// Masaüstü: paddingScreenHorizontal = 100.0, paddingScreenVertical = 64.0
// Bu, responsive tasarım sağlar. Örneğin, masaüstü cihazlarda daha geniş padding kullanılırken, mobil cihazlarda daha dar padding tercih ediliyor.
// Dimens.of(context) fabrika metodu, ekran genişliğine göre (MediaQuery.sizeOf(context).width > 600) uygun sınıfı seçer.

//Dinamik Değerler (Dimens.of(context)):
// left: Dimens.of(context).paddingScreenHorizontal
// right: Dimens.of(context).paddingScreenHorizontal
// top: Dimens.of(context).paddingScreenVertical
// Bu değerler, Dimens.of(context) ile ekran boyutuna göre seçilen Dimens örneğinden (_DimensMobile veya _DimensDesktop) alınıyor.
// Neden dinamik?:
// paddingScreenHorizontal ve paddingScreenVertical, cihaz türüne (mobil veya masaüstü) göre farklı değerler alır:
// Mobil: paddingScreenHorizontal = 20.0, paddingScreenVertical = 24.0
// Masaüstü: paddingScreenHorizontal = 100.0, paddingScreenVertical = 64.0
// Bu, responsive tasarım sağlar. Örneğin, masaüstü cihazlarda daha geniş padding kullanılırken, mobil cihazlarda daha dar padding tercih ediliyor.
// Dimens.of(context) fabrika metodu, ekran genişliğine göre (MediaQuery.sizeOf(context).width > 600) uygun sınıfı seçer.


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../core/localization/applocalization.dart';
import '../../core/themes/dimens.dart';
import '../../core/ui/back_button.dart';
import '../../core/ui/home_button.dart';

class ActivitiesHeader extends StatelessWidget {
  const ActivitiesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: Dimens.of(context).paddingScreenHorizontal,
          right: Dimens.of(context).paddingScreenHorizontal,
          top: Dimens.of(context).paddingScreenVertical,
          bottom: Dimens.paddingVertical,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomBackButton(
              onTap: () {
                // Navigate to ResultsScreen and edit search
                context.go(Routes.results);
              },
            ),
            Text(
              AppLocalization.of(context).activities,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const HomeButton(),
          ],
        ),
      ),
    );
  }
}
