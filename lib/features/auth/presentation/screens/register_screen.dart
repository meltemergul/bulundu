import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bulundu/app/router/routes.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/auth/presentation/widgets/social_sign_in_buttons.dart';
import 'package:bulundu/features/auth/presentation/widgets/terms_checkbox.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/app_exception.dart';
import 'package:bulundu/shared/utils/breakpoints.dart';
import 'package:bulundu/shared/utils/validators.dart';
import 'package:bulundu/shared/widgets/app_button.dart';
import 'package:bulundu/shared/widgets/app_text_field.dart';
import 'package:bulundu/shared/widgets/max_width_body.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key, this.redirectFrom});

  final String? redirectFrom;

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _acceptedTerms = false;
  String? _termsError;

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _localizeAuthError(BuildContext context, Object? error) {
    final l10n = context.l10n;
    if (error is AppException) {
      return switch (error.code) {
        'auth_invalid_credentials' => l10n.authErrorInvalidCredentials,
        'auth_email_in_use' => l10n.authErrorEmailInUse,
        'auth_weak_password' => l10n.authErrorWeakPassword,
        'auth_network' => l10n.authErrorNetwork,
        'auth_cancelled' => l10n.authErrorCancelled,
        _ => l10n.errorGeneric,
      };
    }
    return l10n.errorGeneric;
  }

  Future<void> _submit() async {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!_acceptedTerms) {
      setState(() {
        _termsError = context.l10n.validationTermsRequired;
      });
    } else {
      setState(() {
        _termsError = null;
      });
    }
    if (!isFormValid || !_acceptedTerms) return;

    final ok = await ref
        .read(authControllerProvider.notifier)
        .registerWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
          displayName: _displayNameController.text,
        );
    if (!mounted) return;
    if (!ok) {
      final err = ref.read(authControllerProvider).error;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_localizeAuthError(context, err))));
    }
  }

  Future<void> _handleSocial(Future<bool> Function() action) async {
    final ok = await action();
    if (!mounted) return;
    if (!ok) {
      final err = ref.read(authControllerProvider).error;
      if (err is AppException && err.code == 'auth_cancelled') return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_localizeAuthError(context, err))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.registerTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: MaxWidthBody(
            maxWidth: Breakpoints.maxFormWidth,
            child: Form(
              key: _formKey,
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.xs),
                    Center(
                      child: Container(
                        width: AppSpacing.xxl + AppSpacing.sm,
                        height: AppSpacing.xxl + AppSpacing.sm,
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusLg,
                          ),
                        ),
                        child: Icon(
                          Icons.person_add_alt_1_outlined,
                          size: AppSpacing.xl,
                          color: colors.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.appTagline,
                      style: context.textStyles.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppTextField(
                              label: l10n.displayNameLabel,
                              helperText: l10n.displayNameHelper,
                              controller: _displayNameController,
                              autofillHints: const [AutofillHints.name],
                              textInputAction: TextInputAction.next,
                              maxLength: 40,
                              enabled: !isLoading,
                              prefixIcon: const Icon(Icons.person_outline),
                              validator: (v) =>
                                  Validators.isValidDisplayName(v ?? '')
                                  ? null
                                  : l10n.validationDisplayNameInvalid,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            AppTextField(
                              label: l10n.emailLabel,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              textInputAction: TextInputAction.next,
                              enabled: !isLoading,
                              prefixIcon: const Icon(Icons.mail_outline),
                              validator: (v) => Validators.isValidEmail(v ?? '')
                                  ? null
                                  : l10n.validationEmailInvalid,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            AppTextField(
                              label: l10n.passwordLabel,
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              autofillHints: const [AutofillHints.newPassword],
                              textInputAction: TextInputAction.done,
                              enabled: !isLoading,
                              onSubmitted: (_) => _submit(),
                              prefixIcon: const Icon(Icons.lock_outline),
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
                                  setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  );
                                },
                              ),
                              validator: (v) =>
                                  Validators.isValidPassword(v ?? '')
                                  ? null
                                  : l10n.validationPasswordShort,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TermsCheckbox(
                              value: _acceptedTerms,
                              errorText: _termsError,
                              onChanged: (checked) {
                                setState(() {
                                  _acceptedTerms = checked;
                                  if (checked) _termsError = null;
                                });
                              },
                            ),
                            const SizedBox(height: AppSpacing.md),
                            AppButton(
                              label: l10n.registerButton,
                              isLoading: isLoading,
                              onPressed: _submit,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                  ),
                                  child: Text(
                                    l10n.orDivider,
                                    style: context.textStyles.bodyMedium
                                        ?.copyWith(
                                          color: colors.onSurfaceVariant,
                                        ),
                                  ),
                                ),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            SocialSignInButtons(
                              isLoading: isLoading,
                              onApplePressed: () => _handleSocial(
                                ref
                                    .read(authControllerProvider.notifier)
                                    .signInWithApple,
                              ),
                              onGooglePressed: () => _handleSocial(
                                ref
                                    .read(authControllerProvider.notifier)
                                    .signInWithGoogle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              final from = widget.redirectFrom;
                              final target = from != null && from.isNotEmpty
                                  ? '${AppRoutes.login}?from=${Uri.encodeComponent(from)}'
                                  : AppRoutes.login;
                              context.go(target);
                            },
                      child: Text(l10n.haveAccountPrompt),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
