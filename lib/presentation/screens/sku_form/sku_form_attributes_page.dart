import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/widgets/dashed_border_painter.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_entity.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/usecases/attribute/get_local_attributes_usecase.dart';
import 'package:ventry_flutter/domain/usecases/attribute/sync_attributes_usecase.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';
import 'package:ventry_flutter/injection.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/sku_form_attribute_picker_page.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/models/editable_sku_form_attribute.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_app_bar.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_attribute_card.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_attributes_bottom_bar.dart';

class SkuFormAttributesPage extends StatefulWidget {
  const SkuFormAttributesPage({
    super.key,
    required this.attributes,
    this.isStructureLocked = false,
  });

  final List<SkuAttributeEntity> attributes;
  final bool isStructureLocked;

  @override
  State<SkuFormAttributesPage> createState() => _SkuFormAttributesPageState();
}

class _SkuFormAttributesPageState extends State<SkuFormAttributesPage> {
  static const Duration _attributeScrollDelay = Duration(milliseconds: 300);
  static const Duration _attributeScrollDuration = Duration(milliseconds: 250);

  late List<EditableSkuFormAttribute> _attributes;
  late final Map<String, TextEditingController> _controllers;
  late final Map<String, FocusNode> _focusNodes;
  late final Map<String, GlobalKey> _attributeKeys;
  late final ScrollController _scrollController;
  late final ValueNotifier<bool> _canApplyNotifier;
  late final ValueNotifier<bool> _hasFocusedFieldNotifier;
  final Set<String> _newAttributeIds = <String>{};
  Map<String, List<String>> _attributeSuggestionsByName =
      const <String, List<String>>{};

  @override
  void initState() {
    super.initState();
    _attributes = widget.attributes
        .map(EditableSkuFormAttribute.fromEntity)
        .toList(growable: true);
    _hasFocusedFieldNotifier = ValueNotifier<bool>(false);
    _controllers = {
      for (final attribute in _attributes)
        attribute.id: TextEditingController(text: attribute.value),
    };
    _focusNodes = {
      for (final attribute in _attributes)
        attribute.id: _buildFocusNode(attribute.id),
    };
    _attributeKeys = {
      for (final attribute in _attributes) attribute.id: GlobalKey(),
    };
    _scrollController = ScrollController();
    _canApplyNotifier = ValueNotifier<bool>(_computeCanApply());
    _loadAttributeSuggestions();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    _scrollController.dispose();
    _canApplyNotifier.dispose();
    _hasFocusedFieldNotifier.dispose();
    super.dispose();
  }

  FocusNode _buildFocusNode(String id) {
    final focusNode = FocusNode();
    focusNode.addListener(() {
      _syncFocusedFieldState();
      if (!focusNode.hasFocus) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToAttribute(id);
      });
      Future<void>.delayed(_attributeScrollDelay, () {
        if (!mounted || !focusNode.hasFocus) {
          return;
        }
        _scrollToAttribute(id);
      });
    });
    return focusNode;
  }

  void _syncFocusedFieldState() {
    final hasFocusedField = _focusNodes.values.any((node) => node.hasFocus);
    if (_hasFocusedFieldNotifier.value != hasFocusedField) {
      _hasFocusedFieldNotifier.value = hasFocusedField;
    }
  }

  Future<void> _loadAttributeSuggestions() async {
    final localResult = await getIt<GetLocalAttributesUseCase>()(NoParams());
    if (!mounted) {
      return;
    }

    localResult.fold((_) {}, (attributes) {
      setState(() {
        _attributeSuggestionsByName = _buildSuggestionsByName(attributes);
      });
    });

    final syncResult = await getIt<SyncAttributesUseCase>()(NoParams());
    if (!mounted || syncResult.isLeft()) {
      return;
    }

    final refreshedResult = await getIt<GetLocalAttributesUseCase>()(
      NoParams(),
    );
    if (!mounted) {
      return;
    }

    refreshedResult.fold((_) {}, (attributes) {
      setState(() {
        _attributeSuggestionsByName = _buildSuggestionsByName(attributes);
      });
    });
  }

  Map<String, List<String>> _buildSuggestionsByName(
    List<AttributeEntity> attributes,
  ) {
    final suggestions = <String, List<String>>{};

    for (final attribute in attributes) {
      final normalizedName = _normalizeAttributeName(attribute.name);
      final values = attribute.values
          .map((value) => value.value.trim())
          .where((value) => value.isNotEmpty)
          .toSet()
          .toList(growable: false);

      suggestions[normalizedName] = values;
    }

    return suggestions;
  }

  Future<void> _scrollToAttribute(String id) async {
    final context = _attributeKeys[id]?.currentContext;
    if (context == null) {
      return;
    }

    await Scrollable.ensureVisible(
      context,
      duration: _attributeScrollDuration,
      curve: Curves.easeOutCubic,
      alignment: 0.15,
    );
  }

  void _handleValueChanged(String id, String value) {
    final index = _attributes.indexWhere((attribute) => attribute.id == id);
    if (index == -1) {
      return;
    }

    _attributes[index] = _attributes[index].copyWith(value: value);
    final nextCanApply = _computeCanApply();
    if (_canApplyNotifier.value != nextCanApply) {
      _canApplyNotifier.value = nextCanApply;
    }
  }

  void _handleDelete(String id) {
    if (widget.isStructureLocked) {
      return;
    }

    _controllers.remove(id)?.dispose();
    _focusNodes.remove(id)?.dispose();
    _attributeKeys.remove(id);
    _newAttributeIds.remove(id);
    _syncFocusedFieldState();
    setState(() {
      _attributes = _attributes
          .where((attribute) => attribute.id != id)
          .toList(growable: false);
    });
    _canApplyNotifier.value = _computeCanApply();
  }

  String _normalizeAttributeName(String value) => value.trim().toLowerCase();

  Future<void> _handleAddAttribute() async {
    if (widget.isStructureLocked) {
      return;
    }

    final selectedAttributes = await Navigator.of(context)
        .push<List<AttributeEntity>>(
          MaterialPageRoute(
            builder: (_) => SkuFormAttributePickerPage(
              existingAttributeNames: _attributes
                  .map((attribute) => attribute.name)
                  .toList(growable: false),
            ),
          ),
        );

    if (selectedAttributes == null || !mounted) {
      return;
    }

    final existingAttributeNames = _attributes
        .map((attribute) => _normalizeAttributeName(attribute.name))
        .toSet();
    final newAttributes = selectedAttributes
        .where(
          (attribute) => !existingAttributeNames.contains(
            _normalizeAttributeName(attribute.name),
          ),
        )
        .map(
          (attribute) => EditableSkuFormAttribute(
            id: attribute.uid,
            name: attribute.name,
            value: '',
          ),
        )
        .toList(growable: false);

    if (newAttributes.isEmpty) {
      return;
    }

    for (final attribute in newAttributes) {
      _controllers.putIfAbsent(
        attribute.id,
        () => TextEditingController(text: attribute.value),
      );
      _focusNodes.putIfAbsent(
        attribute.id,
        () => _buildFocusNode(attribute.id),
      );
      _attributeKeys.putIfAbsent(attribute.id, GlobalKey.new);
      _newAttributeIds.add(attribute.id);
      _attributeSuggestionsByName = {
        ..._attributeSuggestionsByName,
        _normalizeAttributeName(attribute.name): selectedAttributes
            .firstWhere((selected) => selected.uid == attribute.id)
            .values
            .map((value) => value.value.trim())
            .where((value) => value.isNotEmpty)
            .toSet()
            .toList(growable: false),
      };
    }

    setState(() {
      _attributes = [..._attributes, ...newAttributes];
    });
    _canApplyNotifier.value = _computeCanApply();

    final firstNewAttributeId = newAttributes.first.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[firstNewAttributeId]?.requestFocus();
      _scrollToAttribute(firstNewAttributeId);
    });
  }

  void _syncAttributesFromControllers() {
    _attributes = _attributes
        .map((attribute) {
          final controller = _controllers[attribute.id];
          if (controller == null) {
            return attribute;
          }

          return attribute.copyWith(value: controller.text);
        })
        .toList(growable: false);
  }

  void _handleApply() {
    _syncAttributesFromControllers();
    Navigator.of(
      context,
    ).pop(_attributes.map((attribute) => attribute.toEntity()).toList());
  }

  bool _computeCanApply() {
    if (widget.isStructureLocked) {
      return _attributes.every(
        (attribute) =>
            attribute.name.trim().isNotEmpty &&
            attribute.value.trim().isNotEmpty,
      );
    }

    return _attributes
        .where((attribute) => _newAttributeIds.contains(attribute.id))
        .every((attribute) => attribute.value.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.skuFormSoftBackground,
      body: Stack(
        children: [
          Column(
            children: [
              SkuFormAppBar(
                title: AppStrings.skuFormEditAttributesTitle,
                onBackTap: () => Navigator.of(context).maybePop(),
                showSaveAction: false,
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(
                    AppSize.size16.w,
                    AppSize.size24.h,
                    AppSize.size16.w,
                    AppSize.size120.h + keyboardInset,
                  ),
                  child: Column(
                    children: [
                      ..._attributes.map(
                        (attribute) => Padding(
                          key: _attributeKeys[attribute.id],
                          padding: EdgeInsets.only(bottom: AppSize.size20.h),
                          child: SkuFormAttributeCard(
                            attribute: attribute,
                            controller: _controllers[attribute.id]!,
                            focusNode: _focusNodes[attribute.id]!,
                            suggestions:
                                _attributeSuggestionsByName[_normalizeAttributeName(
                                  attribute.name,
                                )] ??
                                const <String>[],
                            onChanged: (value) =>
                                _handleValueChanged(attribute.id, value),
                            onDelete: widget.isStructureLocked
                                ? null
                                : () => _handleDelete(attribute.id),
                          ),
                        ),
                      ),
                      if (!widget.isStructureLocked)
                        SizedBox(
                          width: double.infinity,
                          height: AppSize.size57.h,
                          child: CustomPaint(
                            painter: DashedBorderPainter(
                              color: AppColors.inputBorder,
                              radius: AppSize.size12.r,
                            ),
                            child: Material(
                              color: AppColors.surface,
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
                                      AppStrings.skuFormAddNewAttribute,
                                      style: AppTextStyles.skuFormButtonLabel
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
            child: ValueListenableBuilder<bool>(
              valueListenable: _hasFocusedFieldNotifier,
              builder: (context, hasFocusedField, _) {
                if (hasFocusedField) {
                  return const SizedBox.shrink();
                }

                return ValueListenableBuilder<bool>(
                  valueListenable: _canApplyNotifier,
                  builder: (context, canApply, _) {
                    return SkuFormAttributesBottomBar(
                      onCancel: () => Navigator.of(context).maybePop(),
                      onApply: _handleApply,
                      isPrimaryEnabled: canApply,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
