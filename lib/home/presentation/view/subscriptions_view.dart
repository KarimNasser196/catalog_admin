import 'package:catalog_admin/core/utils/image_assests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubscriptionsView extends StatefulWidget {
  const SubscriptionsView({super.key});
  static const String routeName = '/subscriptionsView';

  @override
  State<SubscriptionsView> createState() => _SubscriptionsViewState();
}

class _SubscriptionsViewState extends State<SubscriptionsView> {
  // Track which content type is selected (only one allowed)
  String selectedType = 'Text Typing'; // Only one can be selected

  // Controllers for price editing
  final Map<String, TextEditingController> priceControllers = {};

  // Sample subscription data with editable prices - More entries for better display
  List<Map<String, dynamic>> subscriptionData = [
    {'country': 'Egypt', 'currency': 'EGP', 'price': 50, 'id': '1'},
    {'country': 'UAE', 'currency': 'AED', 'price': 30, 'id': '3'},
    {'country': 'Kuwait', 'currency': 'KWD', 'price': 15, 'id': '4'},
    {'country': 'Egypt', 'currency': 'EGP', 'price': 60, 'id': '5'},
  ];

  // Available countries and currencies
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
  ];

  @override
  void initState() {
    super.initState();
    // Initialize price controllers
    for (var item in subscriptionData) {
      priceControllers[item['id']] = TextEditingController(
        text: item['price'].toString(),
      );
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    for (var controller in priceControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleTypeSelection(String type) {
    // Only allow selecting one type at a time
    setState(() {
      selectedType = type;
    });
  }

  void _updateCountry(int index, String newCountry) {
    setState(() {
      subscriptionData[index]['country'] = newCountry;
    });
  }

  void _updateCurrency(int index, String newCurrency) {
    setState(() {
      subscriptionData[index]['currency'] = newCurrency;
    });
  }

  void _updatePrice(String id, String newPrice) {
    final index = subscriptionData.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      setState(() {
        subscriptionData[index]['price'] = int.tryParse(newPrice) ?? 0;
      });
    }
  }

  void _addNewCountry() {
    setState(() {
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      subscriptionData.add({
        'country': 'Egypt',
        'currency': 'EGP',
        'price': 50,
        'id': newId,
      });
      priceControllers[newId] = TextEditingController(text: '50');
    });
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
              // Header Card - Orange colored
              Container(
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF6823), // Orange color
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
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
                    Text(
                      'Subscriptions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: Column(
                  children: [
                    // Content Type Selector - Single selection only
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildContentTypeButton(
                                'Text Typing',
                                ImageAssets.txtIcon,
                                'Text Typing',
                              ),
                              _buildContentTypeButton(
                                'Image',
                                ImageAssets.photoIcon,
                                'Image',
                              ),
                              _buildContentTypeButton(
                                'Voice',
                                ImageAssets.voiceIcon,
                                'Voice',
                              ),
                              _buildContentTypeButton(
                                'Video',
                                ImageAssets.videoIcon,
                                'Video',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),

                    // Table Header - Smaller to save space
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
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
                    ),
                    SizedBox(height: 8.h),

                    // Subscription List with Dropdowns and Editable Prices - Optimized for more items
                    Expanded(
                      child: ListView.builder(
                        itemCount: subscriptionData.length,
                        itemBuilder: (context, index) {
                          final subscription = subscriptionData[index];
                          final id = subscription['id'];

                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            margin: EdgeInsets.only(bottom: 6.h, right: 5.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              children: [
                                // Countries Dropdown
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
                                        value: subscription['country'],
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
                                            _updateCountry(index, newValue);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6.w),

                                // Currency Dropdown
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
                                        value: subscription['currency'],
                                        isExpanded: true,
                                        isDense: true,
                                        items: currencies.map((
                                          String currency,
                                        ) {
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
                                            _updateCurrency(index, newValue);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6.w),

                                // Editable Price Field
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(6.r),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 0.8,
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: priceControllers[id],
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
                                          subscription['currency'],
                                          style: TextStyle(
                                            fontSize: 9.sp,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ),
                                      onChanged: (value) =>
                                          _updatePrice(id, value),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Add New Country Button - Purple - Smaller
                    Container(
                      width: MediaQuery.of(context).size.width * 0.47,
                      child: ElevatedButton(
                        onPressed: _addNewCountry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5F5FF9),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Add New Country',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              // Save Changes Button - Orange, positioned at bottom
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () {
                    // Handle save changes - send data to backend
                    print('Saving pricing for content type: $selectedType');
                    for (var item in subscriptionData) {
                      print(
                        '${item['country']} - ${item['currency']}: ${item['price']}',
                      );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Pricing updated successfully for $selectedType!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF6823),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Save Changes for $selectedType',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentTypeButton(String label, String imagePath, String type) {
    final isSelected = selectedType == type;

    return GestureDetector(
      onTap: () => _handleTypeSelection(type),
      child: Container(
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
}
