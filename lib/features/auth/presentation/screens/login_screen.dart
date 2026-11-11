import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bulundu/app/router/routes.dart';
import 'package:bulundu/app/theme/app_shadows.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/app_exception.dart';
import 'package:bulundu/shared/utils/validators.dart';
import 'package:bulundu/shared/widgets/app_button.dart';
import 'package:bulundu/shared/widgets/app_logo.dart';
import 'package:bulundu/shared/widgets/app_segmented_tabs.dart';
import 'package:bulundu/shared/widgets/app_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.redirectFrom});

  final String? redirectFrom;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _serverErrorMessage;

  @override
  void dispose() {
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
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final ok = await ref
        .read(authControllerProvider.notifier)
        .signInWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
        );
    if (!mounted) return;
    if (!ok) {
      final err = ref.read(authControllerProvider).error;
      setState(() => _serverErrorMessage = _localizeAuthError(context, err));
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    final resetEmailController = TextEditingController(
      text: _emailController.text.trim(),
    );
    final dialogFormKey = GlobalKey<FormState>();
    final l10n = context.l10n;
    final colors = context.colors;

    final sent = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l10n.forgotPasswordTitle),
        content: Form(
          key: dialogFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.forgotPasswordDescription,
                style: dialogCtx.textStyles.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: l10n.emailLabel,
                controller: resetEmailController,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                prefixIcon: const Icon(Icons.alternate_email),
                validator: (v) => Validators.isValidEmail(v ?? '')
                    ? null
                    : l10n.validationEmailInvalid,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () async {
              if (!(dialogFormKey.currentState?.validate() ?? false)) return;
              final ok = await ref
                  .read(authControllerProvider.notifier)
                  .sendPasswordReset(resetEmailController.text.trim());
              if (!dialogCtx.mounted) return;
              Navigator.of(dialogCtx).pop(ok);
            },
            child: Text(l10n.sendResetLink),
          ),
        ],
      ),
    );

    if (sent == true && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.passwordResetSent)));
    }
  }

  void _goToRegister() {
    final from = widget.redirectFrom;
    final target = from != null && from.isNotEmpty
        ? '${AppRoutes.register}?from=${Uri.encodeComponent(from)}'
        : AppRoutes.register;
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
                      // 1. Logo in circle
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
                        selectedIndex: 0,
                        onChanged: (idx) {
                          if (idx == 1) _goToRegister();
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
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              autofillHints: const [AutofillHints.password],
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

                            // Forgot password link
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: isLoading
                                    ? null
                                    : _showForgotPasswordDialog,
                                child: Text(
                                  l10n.forgotPassword,
                                  style: textStyles.labelMedium?.copyWith(
                                    color: colors.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),

                            // Main submit button
                            AppButton(
                              label: l10n.loginButton,
                              isLoading: isLoading,
                              onPressed: _submit,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Bottom switch text
                      Center(
                        child: TextButton(
                          onPressed: isLoading ? null : _goToRegister,
                          child: Text(
                            l10n.noAccountPrompt,
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
