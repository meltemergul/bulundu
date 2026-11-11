import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/features/profile/providers/delete_account_controller.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/breakpoints.dart';
import 'package:bulundu/shared/utils/validators.dart';
import 'package:bulundu/shared/widgets/app_button.dart';
import 'package:bulundu/shared/widgets/app_text_field.dart';
import 'package:bulundu/shared/widgets/max_width_body.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(bool needsPassword) async {
    if (needsPassword && !(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final ok = await ref
        .read(deleteAccountControllerProvider.notifier)
        .deleteAccount(
          password: needsPassword ? _passwordController.text : null,
        );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.deleteAccountSuccess)),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final user = ref.watch(authStateChangesProvider).value;
    final needsPassword =
        user?.providerData.any((p) => p.providerId == 'password') ?? false;
    final state = ref.watch(deleteAccountControllerProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.deleteAccountTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: MaxWidthBody(
            maxWidth: Breakpoints.maxFormWidth,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colors.errorContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: colors.onErrorContainer,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            l10n.deleteAccountWarning,
                            style: context.textStyles.bodyLarge?.copyWith(
                              color: colors.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.deleteAccountItemsTitle,
                    style: context.textStyles.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.deleteAccountItemListings,
                    style: context.textStyles.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.deleteAccountItemPhotos,
                    style: context.textStyles.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.deleteAccountItemMessages,
                    style: context.textStyles.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.deleteAccountItemProfile,
                    style: context.textStyles.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (needsPassword) ...[
                    AppTextField(
                      label: l10n.passwordLabel,
                      helperText: l10n.deleteAccountReauthPasswordHelper,
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      enabled: !isLoading,
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword
                            ? l10n.showPasswordTooltip
                            : l10n.hidePasswordTooltip,
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      validator: (v) => Validators.isValidPassword(v ?? '')
                          ? null
                          : l10n.validationPasswordShort,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  AppButton(
                    label: l10n.deleteAccountConfirmButton,
                    variant: AppButtonVariant.danger,
                    isLoading: isLoading,
                    onPressed: () => _submit(needsPassword),
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
