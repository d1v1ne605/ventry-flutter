import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/widgets/dashed_border_painter.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/models/editable_sku_attribute.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_app_bar.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_attribute_card.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_attributes_bottom_bar.dart';

class EditSkuAttributesPage extends StatefulWidget {
  const EditSkuAttributesPage({super.key, required this.attributes});

  final List<SkuAttributeEntity> attributes;

  @override
  State<EditSkuAttributesPage> createState() => _EditSkuAttributesPageState();
}

class _EditSkuAttributesPageState extends State<EditSkuAttributesPage> {
  late List<EditableSkuAttribute> _attributes;
  late final Map<String, TextEditingController> _controllers;
  int _newAttributeCount = 0;

  @override
  void initState() {
    super.initState();
    _attributes = widget.attributes
        .map(EditableSkuAttribute.fromEntity)
        .toList(growable: true);
    _controllers = {
      for (final attribute in _attributes)
        attribute.id: TextEditingController(text: attribute.value),
    };
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleValueChanged(String id, String value) {
    setState(() {
      _attributes = _attributes
          .map(
            (attribute) => attribute.id == id
                ? attribute.copyWith(value: value)
                : attribute,
          )
          .toList(growable: false);
    });
  }

  void _handleDelete(String id) {
    _controllers.remove(id)?.dispose();
    setState(() {
      _attributes = _attributes
          .where((attribute) => attribute.id != id)
          .toList(growable: false);
    });
  }

  void _handleAddAttribute() {
    _newAttributeCount += 1;
    final label = AppStrings.editSkuNewAttributeLabel(_newAttributeCount);
    final id = 'draft_attribute_$_newAttributeCount';

    _controllers[id] = TextEditingController();
    setState(() {
      _attributes = [
        ..._attributes,
        EditableSkuAttribute(id: id, name: label, value: ''),
      ];
    });
  }

  void _handleApply() {
    Navigator.of(
      context,
    ).pop(_attributes.map((attribute) => attribute.toEntity()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.editSkuSoftBackground,
      body: Stack(
        children: [
          Column(
            children: [
              EditSkuAppBar(
                title: AppStrings.editSkuEditAttributesTitle,
                onBackTap: () => Navigator.of(context).maybePop(),
                showSaveAction: false,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    AppSize.size16.w,
                    AppSize.size24.h,
                    AppSize.size16.w,
                    120.h,
                  ),
                  child: Column(
                    children: [
                      ..._attributes.map(
                        (attribute) => Padding(
                          padding: EdgeInsets.only(bottom: AppSize.size20.h),
                          child: EditSkuAttributeCard(
                            attribute: attribute,
                            controller: _controllers[attribute.id]!,
                            onChanged: (value) =>
                                _handleValueChanged(attribute.id, value),
                            onDelete: () => _handleDelete(attribute.id),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 57.h,
                        child: CustomPaint(
                          painter: DashedBorderPainter(
                            color: AppColors.inputBorder,
                            radius: AppSize.size12.r,
                          ),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              AppSize.size12.r,
                            ),
                            child: InkWell(
                              onTap: _handleAddAttribute,
                              borderRadius: BorderRadius.circular(
                                AppSize.size12.r,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: AppSize.size20.r,
                                    color: AppColors.textBody,
                                  ),
                                  SizedBox(width: AppSize.size8.w),
                                  Text(
                                    AppStrings.editSkuAddNewAttribute,
                                    style: AppTextStyles.editSkuButtonLabel
                                        .copyWith(color: AppColors.textBody),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: EditSkuAttributesBottomBar(
              onCancel: () => Navigator.of(context).maybePop(),
              onApply: _handleApply,
            ),
          ),
        ],
      ),
    );
  }
}
