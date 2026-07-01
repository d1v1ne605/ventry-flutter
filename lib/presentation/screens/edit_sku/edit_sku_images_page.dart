import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/widgets/app_snack_bar.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/injection.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_image_upload_bloc.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_image_upload_event.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_image_upload_state.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/bloc/edit_sku_images_bloc.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/models/editable_sku_image.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_app_bar.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_image_gallery_tile.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_images_bottom_bar.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_upload_image_tile.dart';

class EditSkuImagesPage extends StatelessWidget {
  const EditSkuImagesPage({super.key, required this.sku});

  final SkuEntity sku;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AddProductImageUploadBloc>()),
        BlocProvider(create: (_) => getIt<EditSkuImagesBloc>()),
      ],
      child: _EditSkuImagesView(sku: sku),
    );
  }
}

class _EditSkuImagesView extends StatefulWidget {
  const _EditSkuImagesView({required this.sku});

  final SkuEntity sku;

  @override
  State<_EditSkuImagesView> createState() => _EditSkuImagesViewState();
}

class _EditSkuImagesViewState extends State<_EditSkuImagesView> {
  final ImagePicker _picker = ImagePicker();

  late List<EditableSkuImage> _existingImages;

  @override
  void initState() {
    super.initState();
    _existingImages = _buildExistingImages(widget.sku);
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
        _existingImages = List<EditableSkuImage>.from(_existingImages)
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
      AppSnackBar.showError(context, AppStrings.editSkuUploadInProgress);
      return;
    }

    context.read<EditSkuImagesBloc>().add(
      SaveEditSkuImagesEvent(
        skuUid: widget.sku.uid,
        version: widget.sku.version,
        imageKeys: _resolveImageKeys(uploadState),
      ),
    );
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
                  style: AppTextStyles.editSkuSectionTitle.copyWith(
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

  List<EditableSkuImage> _buildExistingImages(SkuEntity sku) {
    final items = <EditableSkuImage>[];
    final itemCount = sku.imageKeys.length < sku.imageUrls.length
        ? sku.imageKeys.length
        : sku.imageUrls.length;

    for (var index = 0; index < itemCount; index++) {
      items.add(
        EditableSkuImage(
          imageKey: sku.imageKeys[index],
          previewPath: sku.imageUrls[index],
          isLocalFile: false,
        ),
      );
    }

    return items;
  }

  List<EditableSkuImage> _buildGalleryItems(
    AddProductImageUploadState uploadState,
  ) {
    final uploadedImages = uploadState.images
        .map(
          (image) => EditableSkuImage(
            imageKey: image.objectKey,
            previewPath: image.localPath,
            isLocalFile: true,
          ),
        )
        .toList(growable: false);

    return [..._existingImages, ...uploadedImages];
  }

  List<String> _resolveImageKeys(AddProductImageUploadState uploadState) {
    return _buildGalleryItems(uploadState)
        .map((image) => image.imageKey)
        .where((imageKey) => imageKey.trim().isNotEmpty)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddProductImageUploadBloc, AddProductImageUploadState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage &&
              current.errorMessage != null,
          listener: (context, state) {
            AppSnackBar.showError(context, state.errorMessage!);
          },
        ),
        BlocListener<EditSkuImagesBloc, EditSkuImagesState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == BaseStatus.failure &&
                state.errorMessage != null) {
              AppSnackBar.showError(context, state.errorMessage!);
              return;
            }

            if (state.status == BaseStatus.success &&
                state.updatedSku != null) {
              Navigator.of(context).pop(state.updatedSku);
            }
          },
        ),
      ],
      child: BlocBuilder<AddProductImageUploadBloc, AddProductImageUploadState>(
        builder: (context, uploadState) {
          final galleryItems = _buildGalleryItems(uploadState);
          final additionalImages = galleryItems.length > 1
              ? galleryItems.sublist(1)
              : const <EditableSkuImage>[];

          return Scaffold(
            backgroundColor: AppColors.surface,
            body: Stack(
              children: [
                Column(
                  children: [
                    EditSkuAppBar(
                      title: AppStrings.editSkuEditImagesTitle,
                      onBackTap: () => Navigator.of(context).maybePop(),
                      showSaveAction: false,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          AppSize.size16.w,
                          AppSize.size16.h,
                          AppSize.size16.w,
                          96.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.editSkuEditImagesTitle,
                              style: AppTextStyles.editSkuSectionTitle.copyWith(
                                color: AppColors.textHeading,
                              ),
                            ),
                            SizedBox(height: AppSize.size8.h),
                            Text(
                              AppStrings.editSkuMediaHelper,
                              style: AppTextStyles.editSkuFieldValue.copyWith(
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
                              childAspectRatio: 171 / 152,
                              children: [
                                EditSkuUploadImageTile(
                                  onTap: _showImagePickerBottomSheet,
                                ),
                                if (uploadState.isUploading)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
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
                                          AppStrings.editSkuUploadNew,
                                          style: AppTextStyles.editSkuFieldLabel
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
                              EditSkuImageGalleryTile(
                                previewPath: galleryItems.first.previewPath,
                                isLocalFile: galleryItems.first.isLocalFile,
                                height: 358.h,
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
                                  return EditSkuImageGalleryTile(
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
                  child:
                      BlocSelector<EditSkuImagesBloc, EditSkuImagesState, bool>(
                        selector: (state) => state.isSaving,
                        builder: (context, isSaving) {
                          return EditSkuImagesBottomBar(
                            onCancel: () => Navigator.of(context).maybePop(),
                            onSave: _handleSaveGallery,
                            isSaving: isSaving,
                            isSaveEnabled: !uploadState.isUploading,
                          );
                        },
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
