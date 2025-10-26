import 'package:catalog_admin/core/common/custom_snackbar.dart';
import 'package:catalog_admin/core/services/service_locator.dart';
import 'package:catalog_admin/core/utils/image_assests.dart';
import 'package:catalog_admin/features/subscription/domain/entities/subscription_entity.dart';
import 'package:catalog_admin/features/subscription/presentation/cubit/subscription_cubit.dart';
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
  final List<String> countries = [
    'Egypt',
    'Saudi Arabia',
    'UAE',
    'Kuwait',
    'Jordan',
    'Lebanon',
    'Oman',
    'Qatar',
    'Bahrain',
    'Iraq',
    'Palestine',
    'Morocco',
    'Algeria',
    'Tunisia',
  ];
  final List<String> currencies = [
    'EGP',
    'SAR',
    'AED',
    'KWD',
    'JOD',
    'LBP',
    'OMR',
    'QAR',
    'BHD',
    'IQD',
    'ILS',
    'MAD',
    'DZD',
    'TND',
  ];

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
    } else {
      // Update the controller text if price changed
      if (priceControllers[id]!.text != price.toString()) {
        priceControllers[id]!.text = price.toString();
      }
    }
    return priceControllers[id]!;
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
              Container(
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
                        BlocBuilder<SubscriptionCubit, SubscriptionState>(
                          builder: (context, state) {
                            final cubit = context.read<SubscriptionCubit>();
                            return Text(
                              cubit.selectedContentType,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12.sp,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
              SizedBox(height: 10.h),
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
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
                'Text Typing',
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
              'Countries',
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
        ],
      ),
    );
  }

  Widget _buildSubscriptionsList(BuildContext context) {
    return Expanded(
      child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        builder: (context, state) {
          if (state is SubscriptionLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFEF6823)),
            );
          }

          if (state is SubscriptionError) {
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

          if (state is SubscriptionLoaded) {
            if (state.subscriptions.isEmpty) {
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
                    SizedBox(height: 8.h),
                    Text(
                      'Add a new country to get started',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: state.subscriptions.length,
              itemBuilder: (context, index) {
                final subscription = state.subscriptions[index];
                final controller = _getController(
                  subscription.id,
                  subscription.price,
                );

                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  margin: EdgeInsets.only(bottom: 6.h, right: 5.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
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
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: subscription.country,
                              isExpanded: true,
                              isDense: true,
                              items: countries.map((String country) {
                                return DropdownMenuItem<String>(
                                  value: country,
                                  child: Text(
                                    country,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  context
                                      .read<SubscriptionCubit>()
                                      .updateCountry(index, newValue);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        flex: 2,
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
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: subscription.currency,
                              isExpanded: true,
                              isDense: true,
                              items: currencies.map((String currency) {
                                return DropdownMenuItem<String>(
                                  value: currency,
                                  child: Text(
                                    currency,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  context
                                      .read<SubscriptionCubit>()
                                      .updateCurrency(index, newValue);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
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
                              suffix: Text(
                                subscription.currency,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              final price = int.tryParse(value) ?? 0;
                              context.read<SubscriptionCubit>().updatePrice(
                                subscription.id,
                                price,
                              );
                            },
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
        onPressed: () {
          context.read<SubscriptionCubit>().addNewCountry();
          showCustomSnackBar(context, 'New country added successfully!');
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add New Country',
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

  Widget _buildSaveButton(BuildContext context) {
    return BlocConsumer<SubscriptionCubit, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionSaved) {
          showCustomSnackBar(
            context,
            'Pricing updated successfully for ${context.read<SubscriptionCubit>().selectedContentType}!',
          );
        } else if (state is SubscriptionError) {
          showCustomSnackBar(context, state.message, isError: true);
        }
      },
      builder: (context, state) {
        final cubit = context.read<SubscriptionCubit>();
        final isLoading = state is SubscriptionSaving;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    cubit.saveChanges();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF6823),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 2,
            ),
            child: isLoading
                ? SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Save Changes for ${cubit.selectedContentType}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
