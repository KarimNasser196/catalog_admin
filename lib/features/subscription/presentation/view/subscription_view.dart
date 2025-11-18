// ==================== SUBSCRIPTION VIEW - FULLY FIXED ====================
// lib/subscription/presentation/view/subscriptions_view.dart

import 'package:catalog_admin/core/common/custom_snackbar.dart';
import 'package:catalog_admin/core/services/service_locator.dart';
import 'package:catalog_admin/core/utils/image_assests.dart';
import 'package:catalog_admin/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:country_picker/country_picker.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubscriptionsView extends StatelessWidget {
  const SubscriptionsView({super.key});
  static const String routeName = '/subscriptionsView';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<SubscriptionCubit>()..loadSubscriptions(ContentType.textTyping),
      child: const _SubscriptionsViewBody(),
    );
  }
}

class _SubscriptionsViewBody extends StatefulWidget {
  const _SubscriptionsViewBody();

  @override
  State<_SubscriptionsViewBody> createState() => _SubscriptionsViewBodyState();
}

class _SubscriptionsViewBodyState extends State<_SubscriptionsViewBody> {
  final Map<String, TextEditingController> priceControllers = {};
  String? currentlySavingId;

  @override
  void dispose() {
    for (var controller in priceControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _getController(String id, int price) {
    if (!priceControllers.containsKey(id)) {
      priceControllers[id] = TextEditingController(text: price.toString());
      // ✅ إضافة listener للـ controller
      priceControllers[id]!.addListener(() {
        final newPrice = int.tryParse(priceControllers[id]!.text) ?? 0;
        context.read<SubscriptionCubit>().updatePrice(id, newPrice);
      });
    } else {
      // ✅ تحديث النص فقط إذا كان مختلفاً (لتجنب المشاكل)
      final currentText = priceControllers[id]!.text;
      final expectedText = price.toString();
      if (currentText != expectedText &&
          !priceControllers[id]!.selection.isValid) {
        priceControllers[id]!.text = expectedText;
      }
    }
    return priceControllers[id]!;
  }

  void _showCountryPicker(BuildContext context, int index) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 14.sp, color: Colors.black87),
        bottomSheetHeight: 500.h,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFFEF6823).withValues(alpha: 0.2),
            ),
          ),
        ),
      ),
      onSelect: (Country country) {
        context.read<SubscriptionCubit>().updateCountry(
          index,
          country.name,
          country.phoneCode,
        );
      },
    );
  }

  void _showCurrencyPicker(BuildContext context, int index) {
    showCurrencyPicker(
      context: context,
      theme: CurrencyPickerThemeData(
        flagSize: 25,
        titleTextStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        subtitleTextStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
        bottomSheetHeight: 500.h,
      ),
      onSelect: (Currency currency) {
        context.read<SubscriptionCubit>().updateCurrency(index, currency.code);
      },
    );
  }

  void _showAddCountryDialog(BuildContext parentContext) {
    String? selectedCountryName;
    String? selectedCountryCode;
    String? selectedCurrency;

    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        // ✅ استخدام parentContext بدلاً من dialogContext للـ cubit
        final cubit = parentContext.read<SubscriptionCubit>();

        return StatefulBuilder(
          builder: (statefulContext, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              title: Text(
                'Add New Country',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFEF6823),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Country Picker Button
                  InkWell(
                    onTap: () {
                      showCountryPicker(
                        context: statefulContext,
                        showPhoneCode: true,
                        onSelect: (Country country) {
                          setState(() {
                            selectedCountryName = country.name;
                            selectedCountryCode = country.phoneCode;
                          });
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedCountryName ?? 'Select Country',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: selectedCountryName != null
                                  ? Colors.black87
                                  : Colors.grey,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),

                  // Currency Picker Button
                  InkWell(
                    onTap: () {
                      showCurrencyPicker(
                        context: statefulContext,
                        onSelect: (Currency currency) {
                          setState(() {
                            selectedCurrency = currency.code;
                          });
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedCurrency ?? 'Select Currency',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: selectedCurrency != null
                                  ? Colors.black87
                                  : Colors.grey,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedCountryName != null &&
                        selectedCountryCode != null &&
                        selectedCurrency != null) {
                      // ✅ استخدام cubit المحفوظ
                      cubit.addNewCountry(
                        selectedCountryName!,
                        selectedCurrency!,
                        selectedCountryCode!,
                      );
                      Navigator.pop(dialogContext);
                      showCustomSnackBar(
                        parentContext,
                        'Country added successfully!',
                      );
                    } else {
                      showCustomSnackBar(
                        dialogContext,
                        'Please select country and currency',
                        isError: true,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5F5FF9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'Add',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Column(
            children: [
              _buildHeaderCard(),
              SizedBox(height: 10.h),
              Expanded(
                child: Column(
                  children: [
                    _buildContentTypeSelector(context),
                    SizedBox(height: 15.h),
                    _buildTableHeader(),
                    SizedBox(height: 8.h),
                    _buildSubscriptionsList(context),
                    SizedBox(height: 12.h),
                    _buildAddCountryButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, state) {
        final cubit = context.read<SubscriptionCubit>();
        return Container(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: const Color(0xFFEF6823),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Row(
            children: [
              Container(
                width: 50.w,
                height: 50.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.subscriptions,
                  color: const Color(0xFFEF6823),
                  size: 25.sp,
                ),
              ),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subscriptions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    cubit.selectedContentType,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentTypeSelector(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.orange),
      ),
      child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        builder: (context, state) {
          final cubit = context.read<SubscriptionCubit>();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildContentTypeButton(
                context,
                'Text',
                ImageAssets.txtIcon,
                ContentType.textTyping,
                cubit.selectedContentType,
              ),
              _buildContentTypeButton(
                context,
                'Image',
                ImageAssets.photoIcon,
                ContentType.image,
                cubit.selectedContentType,
              ),
              _buildContentTypeButton(
                context,
                'Voice',
                ImageAssets.voiceIcon,
                ContentType.voice,
                cubit.selectedContentType,
              ),
              _buildContentTypeButton(
                context,
                'Video',
                ImageAssets.videoIcon,
                ContentType.video,
                cubit.selectedContentType,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContentTypeButton(
    BuildContext context,
    String label,
    String imagePath,
    String type,
    String selectedType,
  ) {
    final isSelected = selectedType == type;

    return GestureDetector(
      onTap: () {
        context.read<SubscriptionCubit>().selectContentType(type);
      },
      child: SizedBox(
        width: 65.w,
        height: 70.h,
        child: Column(
          children: [
            Container(
              width: 45.w,
              height: 45.h,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFEF6823)
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEF6823), width: 1),
              ),
              child: Center(
                child: Image.asset(
                  imagePath,
                  width: 22.w,
                  height: 22.h,
                  color: isSelected ? Colors.white : const Color(0xFFEF6823),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              label,
              style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Country',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Currency',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Price',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          SizedBox(
            width: 70.w,
            child: Text(
              'Action',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionsList(BuildContext context) {
    return Expanded(
      child: BlocConsumer<SubscriptionCubit, SubscriptionState>(
        listener: (context, state) {
          if (state is SubscriptionSaved) {
            showCustomSnackBar(context, 'Price updated successfully!');
            setState(() {
              currentlySavingId = null;
            });
          } else if (state is SubscriptionError) {
            showCustomSnackBar(context, state.message, isError: true);
            setState(() {
              currentlySavingId = null;
            });
          }
        },
        builder: (context, state) {
          if (state is SubscriptionLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFEF6823)),
            );
          }

          if (state is SubscriptionError && currentlySavingId == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60.sp,
                    color: Colors.red.shade300,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    state.message,
                    style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is SubscriptionLoaded || state is SubscriptionSaving) {
            final subscriptions = state is SubscriptionLoaded
                ? state.subscriptions
                : context.read<SubscriptionCubit>().subscriptions;

            if (subscriptions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.subscriptions_outlined,
                      size: 80.sp,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      'No Subscriptions Yet',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: subscriptions.length,
              itemBuilder: (context, index) {
                final subscription = subscriptions[index];
                final controller = _getController(
                  subscription.id,
                  subscription.price,
                );
                final isSaving = currentlySavingId == subscription.id;

                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  margin: EdgeInsets.only(bottom: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: (0.05)),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Country Picker
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () => _showCountryPicker(context, index),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 11.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    subscription.country,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.grey.shade700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 18.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),

                      // Currency Picker
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () => _showCurrencyPicker(context, index),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 11.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  subscription.currency,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 18.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),

                      // Price Input
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 0.8,
                            ),
                          ),
                          child: TextFormField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade700,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),

                      // ✅ Update Button
                      SizedBox(
                        width: 70.w,
                        child: ElevatedButton(
                          onPressed: isSaving
                              ? null
                              : () {
                                  setState(() {
                                    currentlySavingId = subscription.id;
                                  });
                                  context
                                      .read<SubscriptionCubit>()
                                      .updateSingleCountry(subscription.id);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5F5FF9),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 8.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            minimumSize: Size.zero,
                          ),
                          child: isSaving
                              ? SizedBox(
                                  width: 12.w,
                                  height: 12.h,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Update',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildAddCountryButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.47,
      child: ElevatedButton.icon(
        onPressed: () => _showAddCountryDialog(context),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Country',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5F5FF9),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
