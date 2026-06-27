import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/custom_text_field.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/attribute_bloc.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/attribute_event.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/attribute_state.dart';
import 'package:ventry_flutter/core/utils/app_formatters.dart';

class PriceAndInventorySection extends StatefulWidget {
  const PriceAndInventorySection({super.key});

  @override
  State<PriceAndInventorySection> createState() =>
      _PriceAndInventorySectionState();
}

class _PriceAndInventorySectionState extends State<PriceAndInventorySection> {
  late final TextEditingController _sellingPriceController;
  late final TextEditingController _costPriceController;
  late final TextEditingController _stockController;

  @override
  void initState() {
    super.initState();
    final state = context.read<AttributeBloc>().state;
    _sellingPriceController = TextEditingController(
      text: state.globalPrice > 0
          ? AppFormatters.formatPrice(state.globalPrice)
          : '',
    );
    _costPriceController = TextEditingController(
      text: state.globalCostPrice > 0
          ? AppFormatters.formatPrice(state.globalCostPrice)
          : '',
    );
    _stockController = TextEditingController(
      text: state.globalStock > 0 ? state.globalStock.toString() : '',
    );
  }

  @override
  void dispose() {
    _sellingPriceController.dispose();
    _costPriceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              color: AppColors.heading,
              size: 20.r,
            ),
            SizedBox(width: AppSize.size8.w),
            Text(
              AppStrings.quickAddStep2Title,
              style: GoogleFonts.manrope(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSize.size16.h),
        CustomTextField(
          label: AppStrings.quickAddStep2CostPriceLabel,
          hintText: AppStrings.costPriceHint,
          controller: _costPriceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [CurrencyTextInputFormatter()],
          onChanged: (val) {
            final costPrice = AppFormatters.parsePrice(val);
            context.read<AttributeBloc>().add(
              UpdateGlobalCostPriceEvent(costPrice),
            );
          },
        ),
        SizedBox(height: AppSize.size16.h),
        CustomTextField(
          label: AppStrings.quickAddStep2SellingPriceLabel,
          hintText: AppStrings.sellingPriceHint,
          controller: _sellingPriceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [CurrencyTextInputFormatter()],
          onChanged: (val) {
            final price = AppFormatters.parsePrice(val);
            context.read<AttributeBloc>().add(UpdateGlobalPriceEvent(price));
          },
        ),
        SizedBox(height: AppSize.size16.h),
        CustomTextField(
          label: AppStrings.quickAddStep2QuantityLabel,
          hintText: AppStrings.stockQuantityHint,
          controller: _stockController,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          onChanged: (val) {
            final stock = int.tryParse(val) ?? 0;
            context.read<AttributeBloc>().add(UpdateGlobalStockEvent(stock));
          },
        ),
        SizedBox(height: AppSize.size16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Is Sellable',
              style: GoogleFonts.manrope(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
              ),
            ),
            BlocBuilder<AttributeBloc, AttributeState>(
              buildWhen: (prev, curr) =>
                  prev.globalIsSellable != curr.globalIsSellable,
              builder: (context, state) {
                return Switch(
                  value: state.globalIsSellable,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    context.read<AttributeBloc>().add(
                      UpdateGlobalIsSellableEvent(val),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
