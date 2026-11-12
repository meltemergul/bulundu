import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/profile/providers/profile_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/breakpoints.dart';
import 'package:bulundu/shared/utils/image_utils.dart';
import 'package:bulundu/shared/utils/platform_info.dart';
import 'package:bulundu/shared/utils/validators.dart';
import 'package:bulundu/shared/widgets/app_button.dart';
import 'package:bulundu/shared/widgets/app_image.dart';
import 'package:bulundu/shared/widgets/app_text_field.dart';

Future<void> showEditProfileModal(BuildContext context) async {
  final isMobile = MediaQuery.sizeOf(context).width < Breakpoints.medium;
  if (isMobile) {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const EditProfileModal(),
    );
  } else {
    await showDialog<void>(
      context: context,
      builder: (ctx) => const Dialog(
        insetPadding: EdgeInsets.all(AppSpacing.lg),
        child: SizedBox(width: 440, child: EditProfileModal()),
      ),
    );
  }
}

class EditProfileModal extends ConsumerStatefulWidget {
  const EditProfileModal({super.key});

  @override
  ConsumerState<EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends ConsumerState<EditProfileModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  String? _currentPhotoUrl;
  String? _newPhotoDataUri;
  bool _removePhoto = false;
  bool _isSaving = false;
  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(currentUserProfileProvider).value;
    final authUser = FirebaseAuth.instance.currentUser;
    final initialName = profile?.displayName.isNotEmpty == true
        ? profile!.displayName
        : (authUser?.displayName ?? '');
    _nameController = TextEditingController(text: initialName);
    _currentPhotoUrl = profile?.photoUrl ?? authUser?.photoURL;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String? get _displayPhotoUrl {
    if (_removePhoto) return null;
    if (_newPhotoDataUri != null) return _newPhotoDataUri;
    return _currentPhotoUrl;
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _isPicking = true);
    try {
      final dataUri = await ImageUtils.pickAndOptimize(
        source: source,
        maxDimension: 600,
        quality: 85,
        maxBytes: 60 * 1024,
      );
      if (dataUri != null && mounted) {
        setState(() {
          _newPhotoDataUri = dataUri;
          _removePhoto = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Fotoğraf seçilemedi: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isPicking = false);
      }
    }
  }

  void _showPhotoOptions() {
    final l10n = context.l10n;
    final colors = context.colors;

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (PlatformInfo.supportsCamera())
                  ListTile(
                    leading: Icon(
                      Icons.camera_alt_outlined,
                      color: colors.primary,
                    ),
                    title: Text(l10n.takePhoto),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                ListTile(
                  leading: Icon(
                    Icons.photo_library_outlined,
                    color: colors.primary,
                  ),
                  title: Text(l10n.chooseFromGallery),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if (_displayPhotoUrl != null && _displayPhotoUrl!.isNotEmpty)
                  ListTile(
                    leading: Icon(Icons.delete_outline, color: colors.error),
                    title: Text(
                      l10n.removePhoto,
                      style: TextStyle(color: colors.error),
                    ),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      setState(() {
                        _removePhoto = true;
                        _newPhotoDataUri = null;
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final l10n = context.l10n;
    final newName = _nameController.text.trim();

    setState(() => _isSaving = true);
    try {
      final repo = ref.read(profileRepositoryProvider);

      await repo.updateProfile(
        uid: user.uid,
        displayName: newName,
        photoUrl: _newPhotoDataUri,
        removePhoto: _removePhoto,
      );

      // Best effort update on Firebase Auth profile
      try {
        if (user.displayName != newName) {
          await user.updateDisplayName(newName);
        }
        if (_removePhoto) {
          await user.updatePhotoURL(null);
        }
      } catch (_) {
        // Auth profile sync is best effort
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.profileUpdatedSuccess),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    final initial = _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim().characters.first.toUpperCase()
        : '?';

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg + bottomInset,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header title
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.editProfileTitle,
                      style:
                          (textStyles.titleLarge ??
                                  const TextStyle(fontSize: 20))
                              .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Interactive Avatar Centerpiece
              Center(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                colors.primary,
                                colors.secondaryContainer,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.primaryFixed,
                            ),
                            child: ClipOval(
                              child: _isPicking
                                  ? const Center(
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    )
                                  : _displayPhotoUrl != null &&
                                        _displayPhotoUrl!.isNotEmpty
                                  ? AppImage(
                                      imageUrl: _displayPhotoUrl!,
                                      fit: BoxFit.cover,
                                      errorWidget: (_, _, _) => Center(
                                        child: Text(
                                          initial,
                                          style:
                                              (textStyles.headlineMedium ??
                                                      const TextStyle(
                                                        fontSize: 24,
                                                      ))
                                                  .copyWith(
                                                    color:
                                                        colors.onPrimaryFixed,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        initial,
                                        style:
                                            (textStyles.headlineMedium ??
                                                    const TextStyle(
                                                      fontSize: 24,
                                                    ))
                                                .copyWith(
                                                  color: colors.onPrimaryFixed,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Material(
                            color: colors.primary,
                            shape: const CircleBorder(),
                            elevation: 3,
                            child: InkWell(
                              onTap: _isSaving || _isPicking
                                  ? null
                                  : _showPhotoOptions,
                              customBorder: const CircleBorder(),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: colors.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextButton.icon(
                      onPressed: _isSaving || _isPicking
                          ? null
                          : _showPhotoOptions,
                      icon: const Icon(Icons.photo_camera_outlined, size: 16),
                      label: Text(l10n.changePhoto),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Display Name input
              AppTextField(
                controller: _nameController,
                label: l10n.displayNameLabel,
                helperText: l10n.displayNameHelper,
                prefixIcon: const Icon(Icons.person_outline),
                validator: (v) {
                  final val = v ?? '';
                  if (!Validators.isValidDisplayName(val)) {
                    return l10n.validationDisplayNameInvalid;
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Actions: Cancel & Save
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: l10n.cancelButton,
                      variant: AppButtonVariant.secondary,
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      label: l10n.saveButton,
                      variant: AppButtonVariant.primary,
                      isLoading: _isSaving,
                      onPressed: _handleSave,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
