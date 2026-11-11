import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/widgets/error_view.dart';
import 'package:bulundu/shared/widgets/loading_view.dart';
import 'package:bulundu/shared/widgets/max_width_body.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final code = Localizations.localeOf(context).languageCode;
    final assetPath = code == 'en'
        ? 'assets/legal/privacy_en.txt'
        : 'assets/legal/privacy_tr.txt';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyTitle)),
      body: FutureBuilder<String>(
        future: rootBundle.loadString(assetPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return ErrorView(message: l10n.errorGeneric);
          }
          return SelectionArea(
            child: SingleChildScrollView(
              child: MaxWidthBody(
                child: Text(
                  snapshot.data!,
                  style: context.textStyles.bodyLarge,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
