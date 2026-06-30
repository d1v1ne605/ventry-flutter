import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_app_bar.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_image_gallery_tile.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_images_bottom_bar.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_upload_image_tile.dart';

class EditSkuImagesPage extends StatefulWidget {
  const EditSkuImagesPage({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  State<EditSkuImagesPage> createState() => _EditSkuImagesPageState();
}

class _EditSkuImagesPageState extends State<EditSkuImagesPage> {
  late List<String> _imageUrls;

  @override
  void initState() {
    super.initState();
    _imageUrls = List<String>.from(widget.imageUrls);
  }

  void _handleRemoveImage(int index) {
    if (index < 0 || index >= _imageUrls.length) {
      return;
    }

    setState(() {
      _imageUrls = List<String>.from(_imageUrls)..removeAt(index);
    });
  }

  void _handleSaveGallery() {
    Navigator.of(context).pop(_imageUrls);
  }

  @override
  Widget build(BuildContext context) {
    final additionalImages = _imageUrls.length > 1
        ? _imageUrls.sublist(1)
        : const <String>[];

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
                        children: const [
                          EditSkuUploadImageTile(),
                          SizedBox.shrink(),
                        ],
                      ),
                      if (_imageUrls.isNotEmpty) ...[
                        SizedBox(height: AppSize.size16.h),
                        EditSkuImageGalleryTile(
                          imageUrl: _imageUrls.first,
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
                            return EditSkuImageGalleryTile(
                              imageUrl: additionalImages[index],
                              onRemove: () => _handleRemoveImage(index + 1),
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
            child: EditSkuImagesBottomBar(
              onCancel: () => Navigator.of(context).maybePop(),
              onSave: _handleSaveGallery,
            ),
          ),
        ],
      ),
    );
  }
}
