import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/models/editable_sku_form_attribute.dart';

class SkuFormAttributeCard extends StatelessWidget {
  const SkuFormAttributeCard({
    super.key,
    required this.attribute,
    required this.controller,
    required this.focusNode,
    required this.suggestions,
    required this.onChanged,
    this.onDelete,
  });

  final EditableSkuFormAttribute attribute;
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<String> suggestions;
  final ValueChanged<String> onChanged;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.size16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSize.size12.r),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  attribute.name,
                  style: AppTextStyles.skuFormSectionTitle.copyWith(
                    color: AppColors.textHeading,
                  ),
                ),
              ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  splashRadius: AppSize.size20.r,
                  icon: Icon(
                    Icons.delete_outline,
                    size: AppSize.size20.r,
                    color: AppColors.subtitle,
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSize.size8.h),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: double.infinity),
            child: RawAutocomplete<String>(
              textEditingController: controller,
              focusNode: focusNode,
              displayStringForOption: (option) => option,
              optionsViewOpenDirection: OptionsViewOpenDirection.up,
              optionsBuilder: (textEditingValue) {
                final normalizedQuery = textEditingValue.text
                    .trim()
                    .toLowerCase();
                final normalizedOptions = <String>{};
                final filteredSuggestions = suggestions.where((suggestion) {
                  final trimmedSuggestion = suggestion.trim();
                  if (trimmedSuggestion.isEmpty) {
                    return false;
                  }

                  final normalizedSuggestion = trimmedSuggestion.toLowerCase();
                  if (!normalizedOptions.add(normalizedSuggestion)) {
                    return false;
                  }

                  return normalizedQuery.isEmpty ||
                      normalizedSuggestion.contains(normalizedQuery);
                });

                return filteredSuggestions;
              },
              onSelected: onChanged,
              fieldViewBuilder:
                  (context, textEditingController, textFieldFocusNode, _) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: textFieldFocusNode,
                      onChanged: onChanged,
                      style: AppTextStyles.skuFormFieldValue,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: AppColors.inputFill,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppSize.size12.w,
                          vertical: AppSize.size12.h,
                        ),
                        enabledBorder: _border,
                        focusedBorder: _border,
                      ),
                    );
                  },
              optionsViewBuilder: (context, onSelected, options) {
                if (options.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: AppColors.surface,
                    elevation: AppSize.size4,
                    borderRadius: BorderRadius.circular(AppSize.size12.r),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: AppSize.size200.h,
                        minWidth:
                            MediaQuery.sizeOf(context).width - AppSize.size64.w,
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSize.size8.h,
                        ),
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return InkWell(
                            onTap: () => onSelected(option),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSize.size16.w,
                                vertical: AppSize.size10.h,
                              ),
                              child: Text(
                                option,
                                style: AppTextStyles.skuFormFieldValue,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder get _border => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSize.size8.r),
    borderSide: const BorderSide(color: AppColors.inputBorder),
  );
}
