import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/widgets/app_snack_bar.dart';
import 'package:ventry_flutter/injection.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_image_upload_bloc.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_image_upload_event.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_image_upload_state.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/models/editable_sku_form_image.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_app_bar.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_image_gallery_tile.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_images_bottom_bar.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_upload_image_tile.dart';

class SkuFormImagesPage extends StatelessWidget {
  const SkuFormImagesPage({super.key, required this.images});

  final List<EditableSkuFormImage> images;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AddProductImageUploadBloc>(),
      child: _SkuFormImagesView(images: images),
    );
  }
}

class _SkuFormImagesView extends StatefulWidget {
  const _SkuFormImagesView({required this.images});

  final List<EditableSkuFormImage> images;

  @override
  State<_SkuFormImagesView> createState() => _SkuFormImagesViewState();
}

class _SkuFormImagesViewState extends State<_SkuFormImagesView> {
  final ImagePicker _picker = ImagePicker();

  late List<EditableSkuFormImage> _existingImages;

  @override
  void initState() {
    super.initState();
    _existingImages = List<EditableSkuFormImage>.from(widget.images);
  }

  void _handleRemoveImage(int index) {
    final uploadState = context.read<AddProductImageUploadBloc>().state;
    final existingCount = _existingImages.length;
    final totalCount = existingCount + uploadState.images.length;

    if (index < 0 || index >= totalCount) {
      return;
    }

    if (index < existingCount) {
      setState(() {
        _existingImages = List<EditableSkuFormImage>.from(_existingImages)
          ..removeAt(index);
      });
      return;
    }

    context.read<AddProductImageUploadBloc>().add(
      RemoveAddProductImageEvent(index - existingCount),
    );
  }

  void _handleSaveGallery() {
    final uploadState = context.read<AddProductImageUploadBloc>().state;
    if (uploadState.isUploading) {
      AppSnackBar.showError(context, AppStrings.skuFormUploadInProgress);
      return;
    }

    Navigator.of(context).pop(_buildGalleryItems(uploadState));
  }

  Future<void> _pickImage(ImageSource source) async {
    FocusManager.instance.primaryFocus?.unfocus();

    final image = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1600,
      maxHeight: 1600,
    );

    if (image != null && mounted) {
      context.read<AddProductImageUploadBloc>().add(
        UploadAddProductImagesEvent([image]),
      );
    }
  }

  Future<void> _pickMultipleImages() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final images = await _picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 1600,
      maxHeight: 1600,
    );

    if (images.isNotEmpty && mounted) {
      context.read<AddProductImageUploadBloc>().add(
        UploadAddProductImagesEvent(images),
      );
    }
  }

  void _showImagePickerBottomSheet() {
    FocusManager.instance.primaryFocus?.unfocus();

    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.size16.r),
        ),
      ),
      backgroundColor: AppColors.surface,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.size16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.uploadImage,
                  style: AppTextStyles.skuFormSectionTitle.copyWith(
                    color: AppColors.textHeading,
                  ),
                ),
                SizedBox(height: AppSize.size16.h),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.textBody,
                  ),
                  title: Text(
                    AppStrings.takeAPhoto,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textHeading,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: AppColors.textBody,
                  ),
                  title: Text(
                    AppStrings.chooseFromGallery,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textHeading,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickMultipleImages();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<EditableSkuFormImage> _buildGalleryItems(
    AddProductImageUploadState uploadState,
  ) {
    final uploadedImages = uploadState.images
        .map(
          (image) => EditableSkuFormImage(
            imageKey: image.objectKey,
            previewPath: image.localPath,
            isLocalFile: true,
          ),
        )
        .toList(growable: false);

    return [..._existingImages, ...uploadedImages];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddProductImageUploadBloc, AddProductImageUploadState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        AppSnackBar.showError(context, state.errorMessage!);
      },
      child: BlocBuilder<AddProductImageUploadBloc, AddProductImageUploadState>(
        builder: (context, uploadState) {
          final galleryItems = _buildGalleryItems(uploadState);
          final additionalImages = galleryItems.length > 1
              ? galleryItems.sublist(1)
              : const <EditableSkuFormImage>[];

          return Scaffold(
            backgroundColor: AppColors.surface,
            body: Stack(
              children: [
                Column(
                  children: [
                    SkuFormAppBar(
                      title: AppStrings.skuFormEditImagesTitle,
                      onBackTap: () => Navigator.of(context).maybePop(),
                      showSaveAction: false,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          AppSize.size16.w,
                          AppSize.size16.h,
                          AppSize.size16.w,
                          AppSize.size96.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.skuFormEditImagesTitle,
                              style: AppTextStyles.skuFormSectionTitle.copyWith(
                                color: AppColors.textHeading,
                              ),
                            ),
                            SizedBox(height: AppSize.size8.h),
                            Text(
                              AppStrings.skuFormMediaHelper,
                              style: AppTextStyles.skuFormFieldValue.copyWith(
                                color: AppColors.textBody,
                              ),
                            ),
                            SizedBox(height: AppSize.size20.h),
                            GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: AppSize.size16.w,
                              mainAxisSpacing: AppSize.size16.h,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              childAspectRatio:
                                  AppSize.size171 / AppSize.size152,
                              children: [
                                SkuFormUploadImageTile(
                                  onTap: _showImagePickerBottomSheet,
                                ),
                                if (uploadState.isUploading)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(
                                        AppSize.size12.r,
                                      ),
                                      border: Border.all(
                                        color: AppColors.inputBorder,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: AppSize.size24.w,
                                          height: AppSize.size24.w,
                                          child:
                                              const CircularProgressIndicator(
                                                color: AppColors.primary,
                                                strokeWidth: AppSize.size2,
                                              ),
                                        ),
                                        SizedBox(height: AppSize.size12.h),
                                        Text(
                                          AppStrings.skuFormUploadNew,
                                          style: AppTextStyles.skuFormFieldLabel
                                              .copyWith(
                                                color: AppColors.textBody,
                                              ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  const SizedBox.shrink(),
                              ],
                            ),
                            if (galleryItems.isNotEmpty) ...[
                              SizedBox(height: AppSize.size16.h),
                              SkuFormImageGalleryTile(
                                previewPath: galleryItems.first.previewPath,
                                isLocalFile: galleryItems.first.isLocalFile,
                                height: AppSize.size358.h,
                                isCover: true,
                                onRemove: () => _handleRemoveImage(0),
                              ),
                            ],
                            if (additionalImages.isNotEmpty) ...[
                              SizedBox(height: AppSize.size16.h),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: additionalImages.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: AppSize.size16.w,
                                      mainAxisSpacing: AppSize.size16.h,
                                      childAspectRatio: 1,
                                    ),
                                itemBuilder: (context, index) {
                                  final image = additionalImages[index];
                                  return SkuFormImageGalleryTile(
                                    previewPath: image.previewPath,
                                    isLocalFile: image.isLocalFile,
                                    onRemove: () =>
                                        _handleRemoveImage(index + 1),
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SkuFormImagesBottomBar(
                    onCancel: () => Navigator.of(context).maybePop(),
                    onSave: _handleSaveGallery,
                    isSaving: false,
                    isSaveEnabled: !uploadState.isUploading,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
