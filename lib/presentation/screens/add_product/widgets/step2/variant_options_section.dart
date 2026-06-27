import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/custom_text_field.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_entity.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/attribute_bloc.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/attribute_event.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/attribute_state.dart';

class VariantOptionsSection extends StatelessWidget {
  const VariantOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      AttributeBloc,
      AttributeState,
      List<VariantOptionGroup>
    >(
      selector: (state) => state.variantGroups,
      builder: (context, variantGroups) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.variantOptionsDefinition,
              style: GoogleFonts.manrope(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),
            ),
            SizedBox(height: AppSize.size16.h),

            ...variantGroups.map((group) {
              return Padding(
                padding: EdgeInsets.only(bottom: AppSize.size16.h),
                child: _OptionGroupItem(group: group),
              );
            }),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<AttributeBloc>().add(AddVariantGroupEvent());
                },
                icon: Icon(Icons.add, size: 20.r, color: AppColors.primary),
                label: Text(
                  AppStrings.addAnotherOption,
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: AppSize.size12.h),
                  side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.size8.r),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OptionGroupItem extends StatefulWidget {
  final VariantOptionGroup group;

  const _OptionGroupItem({required this.group});

  @override
  State<_OptionGroupItem> createState() => _OptionGroupItemState();
}

class _OptionGroupItemState extends State<_OptionGroupItem> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _valueFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.group.name;
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        _onNameSubmitted(_nameController.text);
      }
    });
  }

  @override
  void didUpdateWidget(covariant _OptionGroupItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.group.name != widget.group.name &&
        _nameController.text != widget.group.name) {
      _nameController.text = widget.group.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    _nameFocusNode.dispose();
    _valueFocusNode.dispose();
    super.dispose();
  }

  void _onNameSubmitted(String text) {
    context.read<AttributeBloc>().add(
      UpdateVariantGroupNameEvent(widget.group.id, text),
    );
  }

  void _onValueSubmitted(String text) {
    context.read<AttributeBloc>().add(
      AddVariantOptionValueEvent(widget.group.id, text),
    );
    _valueController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.size12.r),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppSize.size8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocSelector<AttributeBloc, AttributeState, List<AttributeEntity>>(
            selector: (state) => state.localAttributes,
            builder: (context, attributes) {
              return RawAutocomplete<AttributeEntity>(
                textEditingController: _nameController,
                focusNode: _nameFocusNode,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty)
                    return const Iterable<AttributeEntity>.empty();
                  return attributes.where(
                    (attr) => attr.name.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    ),
                  );
                },
                displayStringForOption: (option) => option.name,
                onSelected: (option) {
                  _onNameSubmitted(option.name);
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      return CustomTextField(
                        label: AppStrings.optionNameLabel,
                        hintText: AppStrings.optionNameHint,
                        controller: controller,
                        focusNode: focusNode,
                        onSubmitted: (text) {
                          onFieldSubmitted();
                          _onNameSubmitted(text);
                        },
                        topTrailing: Padding(
                          padding: const EdgeInsets.only(bottom: AppSize.size4),
                          child: GestureDetector(
                            onTap: () {
                              context.read<AttributeBloc>().add(
                                RemoveVariantGroupEvent(widget.group.id),
                              );
                            },
                            child: SvgPicture.asset(
                              AppAssets.icTrash,
                              height: AppSize.size16.h,
                              width: AppSize.size16.w,
                            ),
                          ),
                        ),
                      );
                    },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: 200.h,
                          maxWidth: 300.w,
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final option = options.elementAt(index);
                            return InkWell(
                              onTap: () => onSelected(option),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(option.name),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(height: AppSize.size12.h),

          BlocSelector<AttributeBloc, AttributeState, List<AttributeEntity>>(
            selector: (state) => state.localAttributes,
            builder: (context, attributes) {
              final activeAttribute = attributes
                  .where((a) => a.uid == widget.group.attributeUid)
                  .firstOrNull;

              return RawAutocomplete<String>(
                textEditingController: _valueController,
                focusNode: _valueFocusNode,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (activeAttribute == null || textEditingValue.text.isEmpty)
                    return const Iterable<String>.empty();
                  return activeAttribute.values
                      .map((v) => v.value)
                      .where(
                        (v) => v.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        ),
                      );
                },
                onSelected: (option) {
                  _onValueSubmitted(option);
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      return CustomTextField(
                        label: AppStrings.optionValuesLabel,
                        hintText: AppStrings.optionValuesHint,
                        controller: controller,
                        focusNode: focusNode,
                        enabled: widget.group.attributeUid != null,
                        onSubmitted: (text) {
                          onFieldSubmitted();
                          _onValueSubmitted(text);
                        },
                      );
                    },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: 200.h,
                          maxWidth: 300.w,
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final option = options.elementAt(index);
                            return InkWell(
                              onTap: () => onSelected(option),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(option),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),

          if (widget.group.values.isNotEmpty) ...[
            SizedBox(height: AppSize.size8.h),
            Wrap(
              spacing: AppSize.size8.w,
              runSpacing: AppSize.size8.h,
              children: widget.group.values
                  .map((v) => _buildChip(context, widget.group.id, v))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    String groupId,
    VariantOptionValue value,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.size12.w,
        vertical: AppSize.size6.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value.value,
            style: GoogleFonts.manrope(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: AppSize.size4.w),
          GestureDetector(
            onTap: () {
              context.read<AttributeBloc>().add(
                RemoveVariantOptionValueEvent(groupId, value),
              );
            },
            child: Icon(Icons.close, size: 14.r, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
