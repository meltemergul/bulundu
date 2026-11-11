import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/auth/presentation/widgets/terms_checkbox.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/features/profile/providers/profile_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/breakpoints.dart';
import 'package:bulundu/shared/utils/validators.dart';
import 'package:bulundu/shared/widgets/app_button.dart';
import 'package:bulundu/shared/widgets/app_text_field.dart';
import 'package:bulundu/shared/widgets/max_width_body.dart';

class AcceptTermsScreen extends ConsumerStatefulWidget {
  const AcceptTermsScreen({super.key});

  @override
  ConsumerState<AcceptTermsScreen> createState() => _AcceptTermsScreenState();
}

class _AcceptTermsScreenState extends ConsumerState<AcceptTermsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  bool _acceptedTerms = false;
  bool _didPrefill = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_acceptedTerms) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final ok = await ref
        .read(authControllerProvider.notifier)
        .acceptTerms(displayName: _displayNameController.text);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final authUser = ref.watch(authStateChangesProvider).value;
    final profile = ref.watch(currentUserProfileProvider).value;
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    if (!_didPrefill) {
      final candidate = profile?.displayName.isNotEmpty == true
          ? profile!.displayName
          : (authUser?.displayName ?? '');
      if (candidate.isNotEmpty) {
        _displayNameController.text = candidate;
        _didPrefill = true;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.acceptTermsTitle),
        actions: [
          TextButton.icon(
            onPressed: isLoading
                ? null
                : () => ref.read(authControllerProvider.notifier).signOut(),
            icon: const Icon(Icons.logout_outlined),
            label: Text(l10n.signOutButton),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: MaxWidthBody(
            maxWidth: Breakpoints.maxFormWidth,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.acceptTermsDescription,
                    style: context.textStyles.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    label: l10n.displayNameLabel,
                    helperText: l10n.displayNameHelper,
                    controller: _displayNameController,
                    autofillHints: const [AutofillHints.name],
                    textInputAction: TextInputAction.done,
                    maxLength: 40,
                    enabled: !isLoading,
                    validator: (v) => Validators.isValidDisplayName(v ?? '')
                        ? null
                        : l10n.validationDisplayNameInvalid,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TermsCheckbox(
                    value: _acceptedTerms,
                    onChanged: (checked) {
                      setState(() => _acceptedTerms = checked);
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: l10n.continueButton,
                    isLoading: isLoading,
                    onPressed: _acceptedTerms ? _submit : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
