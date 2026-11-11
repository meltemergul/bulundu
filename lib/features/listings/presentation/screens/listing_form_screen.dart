import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:bulundu/app/router/routes.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/features/listings/models/listing_category.dart';
import 'package:bulundu/features/listings/models/listing_draft.dart';
import 'package:bulundu/features/listings/presentation/widgets/category_chip_bar.dart';
import 'package:bulundu/features/listings/presentation/widgets/image_picker_field.dart';
import 'package:bulundu/features/listings/providers/listing_form_controller.dart';
import 'package:bulundu/features/listings/providers/listing_providers.dart';
import 'package:bulundu/features/map/providers/location_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/breakpoints.dart';
import 'package:bulundu/shared/utils/date_format.dart';
import 'package:bulundu/shared/utils/validators.dart';
import 'package:bulundu/shared/widgets/app_button.dart';
import 'package:bulundu/shared/widgets/app_text_field.dart';
import 'package:bulundu/shared/widgets/max_width_body.dart';

class ListingFormScreen extends ConsumerStatefulWidget {
  const ListingFormScreen({super.key, this.listingId});

  final String? listingId;

  @override
  ConsumerState<ListingFormScreen> createState() => _ListingFormScreenState();
}

class _ListingFormScreenState extends ConsumerState<ListingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationNameController = TextEditingController();

  ListingType _type = ListingType.lost;
  ListingCategory _category = ListingCategory.wallet;
  DateTime _eventDate = DateTime.now();
  LatLng? _selectedPoint;
  final List<String> _existingImageUrls = [];
  final List<PickedImageItem> _newImages = [];
  bool _didPrefill = false;
  String? _locationError;

  bool get _isEditing => widget.listingId != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedPoint == null && mounted) {
        final loc = ref.read(userLocationProvider).value;
        setState(() {
          _selectedPoint = loc ?? const LatLng(41.0082, 28.9784);
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationNameController.dispose();
    super.dispose();
  }

  void _prefillIfNeeded(Listing listing) {
    if (_didPrefill) return;
    _didPrefill = true;
    _type = listing.type;
    _category = listing.category;
    _titleController.text = listing.title;
    _descriptionController.text = listing.description;
    _locationNameController.text = listing.locationName;
    _eventDate = listing.eventDate;
    _selectedPoint = listing.exactPoint;
    _existingImageUrls
      ..clear()
      ..addAll(listing.imageUrls);
  }

  Future<void> _pickLocation() async {
    final result = await context.push<LatLng>(
      AppRoutes.listingPickLocation,
      extra: _selectedPoint ?? const LatLng(41.0082, 28.9784),
    );
    if (!mounted || result == null) return;
    setState(() {
      _selectedPoint = result;
      _locationError = null;
      if (_locationNameController.text.trim().isEmpty) {
        _locationNameController.text =
            '${result.latitude.toStringAsFixed(4)}, ${result.longitude.toStringAsFixed(4)}';
      }
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _eventDate.isAfter(now) ? now : _eventDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
    );
    if (!mounted || picked == null) return;
    setState(() => _eventDate = picked);
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    _selectedPoint ??=
        ref.read(userLocationProvider).value ?? const LatLng(41.0082, 28.9784);

    if (_locationNameController.text.trim().isEmpty) {
      setState(() {
        _locationError = context.l10n.validationLocationRequired;
      });
      return;
    }
    setState(() => _locationError = null);
    if (!isValid) return;

    final draft = ListingDraft(
      type: _type,
      title: _titleController.text,
      category: _category,
      description: _descriptionController.text,
      lat: _selectedPoint!.latitude,
      lng: _selectedPoint!.longitude,
      locationName: _locationNameController.text,
      eventDate: _eventDate,
      existingImageUrls: List.unmodifiable(_existingImageUrls),
      newImages: List.unmodifiable(_newImages.map((e) => e.file)),
      newImageBytes: List.unmodifiable(_newImages.map((e) => e.bytes)),
    );

    final controller = ref.read(listingFormControllerProvider.notifier);
    if (_isEditing) {
      final ok = await controller.updateListing(
        listingId: widget.listingId!,
        draft: draft,
      );
      if (!mounted) return;
      if (ok) {
        context.pop();
      } else {
        final err = ref.read(listingFormControllerProvider).error;
        final errorMsg = err != null
            ? err.toString()
            : context.l10n.errorGeneric;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMsg)));
      }
    } else {
      final createdId = await controller.createListing(draft);
      if (!mounted) return;
      if (createdId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.listingLiveMessage)),
        );
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(AppRoutes.explore);
        }
        context.push(AppRoutes.listingDetail(createdId));
      } else {
        final err = ref.read(listingFormControllerProvider).error;
        final errorMsg = err != null
            ? err.toString()
            : context.l10n.errorGeneric;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMsg)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formState = ref.watch(listingFormControllerProvider);
    final isLoading = formState.isLoading;

    if (_isEditing) {
      final existingListing = ref
          .watch(listingDetailProvider(widget.listingId!))
          .value;
      if (existingListing != null) {
        _prefillIfNeeded(existingListing);
      }
    }

    final locale = Localizations.localeOf(context).toString();
    final dateStr = AppDateFormat.formatShortDate(_eventDate, locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? l10n.listingFormEditTitle : l10n.listingFormNewTitle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.explore);
            }
          },
        ),
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
                  Text(
                    l10n.listingTypeLabel,
                    style: context.textStyles.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SegmentedButton<ListingType>(
                    segments: [
                      ButtonSegment(
                        value: ListingType.lost,
                        label: Text(l10n.listingTypeLost),
                        icon: const Icon(Icons.search),
                      ),
                      ButtonSegment(
                        value: ListingType.found,
                        label: Text(l10n.listingTypeFoundVerb),
                        icon: const Icon(Icons.inventory_2_outlined),
                      ),
                    ],
                    selected: {_type},
                    onSelectionChanged: (s) => setState(() => _type = s.first),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: l10n.listingTitleLabel,
                    helperText: l10n.listingTitleHelper,
                    controller: _titleController,
                    maxLength: 80,
                    textInputAction: TextInputAction.next,
                    enabled: !isLoading,
                    validator: (v) => Validators.isValidListingTitle(v ?? '')
                        ? null
                        : l10n.validationTitleInvalid,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.listingCategoryLabel,
                    style: context.textStyles.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: ListingCategory.values.map((cat) {
                      return ChoiceChip(
                        selected: _category == cat,
                        avatar: _category == cat
                            ? null
                            : Icon(cat.icon, size: AppSpacing.md),
                        label: Text(cat.localizedLabel(context)),
                        onSelected: (_) => setState(() => _category = cat),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: l10n.listingDescriptionLabel,
                    helperText: l10n.listingDescriptionHelper,
                    controller: _descriptionController,
                    maxLines: 4,
                    maxLength: 500,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ImagePickerField(
                    existingImageUrls: _existingImageUrls,
                    newImages: _newImages,
                    onAddImage: (file) {
                      setState(() => _newImages.add(file));
                    },
                    onRemoveExisting: (index) {
                      setState(() => _existingImageUrls.removeAt(index));
                    },
                    onRemoveNew: (index) {
                      setState(() => _newImages.removeAt(index));
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.listingLocationLabel,
                    style: context.textStyles.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton.icon(
                    onPressed: isLoading ? null : _pickLocation,
                    icon: const Icon(Icons.map_outlined),
                    label: Text(
                      _selectedPoint == null
                          ? l10n.pickLocationButton
                          : '${_selectedPoint!.latitude.toStringAsFixed(4)}, ${_selectedPoint!.longitude.toStringAsFixed(4)}',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    label: l10n.listingLocationNameLabel,
                    helperText: l10n.listingLocationNameHelper,
                    controller: _locationNameController,
                    errorText: _locationError,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.listingEventDateLabel,
                    style: context.textStyles.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton.icon(
                    onPressed: isLoading ? null : _pickDate,
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text('$dateStr (${l10n.selectDateButton})'),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: l10n.saveButton,
                    isLoading: isLoading,
                    onPressed: _submit,
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
