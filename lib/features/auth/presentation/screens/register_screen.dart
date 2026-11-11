import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bulundu/app/router/routes.dart';
import 'package:bulundu/app/theme/app_shadows.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/auth/presentation/widgets/terms_checkbox.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/app_exception.dart';
import 'package:bulundu/shared/utils/validators.dart';
import 'package:bulundu/shared/widgets/app_button.dart';
import 'package:bulundu/shared/widgets/app_logo.dart';
import 'package:bulundu/shared/widgets/app_segmented_tabs.dart';
import 'package:bulundu/shared/widgets/app_text_field.dart';

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
  String? _serverErrorMessage;

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
    setState(() => _serverErrorMessage = null);
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!_acceptedTerms) {
      setState(() => _termsError = context.l10n.validationTermsRequired);
    } else {
      setState(() => _termsError = null);
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
      setState(() => _serverErrorMessage = _localizeAuthError(context, err));
    }
  }

  void _goToLogin() {
    final from = widget.redirectFrom;
    final target = from != null && from.isNotEmpty
        ? '${AppRoutes.login}?from=${Uri.encodeComponent(from)}'
        : AppRoutes.login;
    context.go(target);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;
    final brightness = Theme.of(context).brightness;
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.lg,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Logo
                      Center(
                        child: Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.surfaceContainerHigh,
                          ),
                          alignment: Alignment.center,
                          child: const AppLogo(
                            size: 64,
                            borderRadius: AppSpacing.radiusLg,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // 2. App Name with dot
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.appName,
                            style: textStyles.headlineLarge?.copyWith(
                              color: colors.onSurface,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),

                      // 3. Slogan
                      Text(
                        l10n.slogan,
                        textAlign: TextAlign.center,
                        style: textStyles.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // 4. Community search badge
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusFull,
                            ),
                          ),
                          child: Text(
                            l10n.communitySearchBadge,
                            style: textStyles.labelMedium?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // 5. Segmented switch
                      AppSegmentedTabs(
                        selectedIndex: 1,
                        onChanged: (idx) {
                          if (idx == 0) _goToLogin();
                        },
                        labels: [l10n.loginTitle, l10n.registerTitle],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // 6. Form Card
                      Container(
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusXl,
                          ),
                          boxShadow: AppShadows.card(brightness),
                        ),
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Server error banner
                            if (_serverErrorMessage != null) ...[
                              Semantics(
                                liveRegion: true,
                                child: Container(
                                  padding: const EdgeInsets.all(AppSpacing.sm),
                                  decoration: BoxDecoration(
                                    color: colors.errorContainer,
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusMd,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: colors.onErrorContainer,
                                        size: 20,
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Expanded(
                                        child: Text(
                                          _serverErrorMessage!,
                                          style: textStyles.bodySmall?.copyWith(
                                            color: colors.onErrorContainer,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                            ],

                            // Display Name
                            AppTextField(
                              label: l10n.displayNameLabel,
                              controller: _displayNameController,
                              autofillHints: const [AutofillHints.name],
                              textInputAction: TextInputAction.next,
                              maxLength: 40,
                              enabled: !isLoading,
                              prefixIcon: const Icon(Icons.badge_outlined),
                              validator: (v) =>
                                  Validators.isValidDisplayName(v ?? '')
                                  ? null
                                  : l10n.validationDisplayNameInvalid,
                            ),
                            const SizedBox(height: AppSpacing.md),

                            // Email
                            AppTextField(
                              label: l10n.emailLabel,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              textInputAction: TextInputAction.next,
                              enabled: !isLoading,
                              prefixIcon: const Icon(Icons.alternate_email),
                              validator: (v) => Validators.isValidEmail(v ?? '')
                                  ? null
                                  : l10n.validationEmailInvalid,
                            ),
                            const SizedBox(height: AppSpacing.md),

                            // Password
                            AppTextField(
                              label: l10n.passwordLabel,
                              helperText: l10n.passwordHelper,
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

                            // Terms Checkbox
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
                            const SizedBox(height: AppSpacing.lg),

                            // Main submit button (disabled if terms not accepted)
                            AppButton(
                              label: l10n.registerButton,
                              isLoading: isLoading,
                              onPressed: _acceptedTerms ? _submit : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Bottom switch text
                      Center(
                        child: TextButton(
                          onPressed: isLoading ? null : _goToLogin,
                          child: Text(
                            l10n.haveAccountPrompt,
                            style: textStyles.bodyMedium?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),

                      // Terms notice
                      Text(
                        l10n.termsNotice,
                        textAlign: TextAlign.center,
                        style: textStyles.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
