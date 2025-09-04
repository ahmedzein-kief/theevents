import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/models/vendor_models/products/holder_models/faq_model.dart';
import 'package:event_app/models/vendor_models/products/vendor_get_product_general_settings_model.dart';
import 'package:event_app/vendor/components/dropdowns/custom_multiselect_dropdown.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class VendorProductFaqScreen extends StatefulWidget {
  const VendorProductFaqScreen({
    super.key,
    required this.listFaq,
    required this.parentFAQModel,
  });
  final List<Faqs> listFaq;
  final ParentFAQModel? parentFAQModel;

  @override
  _VendorProductFaqScreenState createState() => _VendorProductFaqScreenState();
}

class _VendorProductFaqScreenState extends State<VendorProductFaqScreen> {
  List<FAQModel> productFAQs = [];
  List<TextEditingController> questionControllers = [];
  List<TextEditingController> answerControllers = [];
  List<String> selectedExistingFaqs = [];

  final _faqController = MultiSelectController<Faqs>();
  List<DropdownItem<Faqs>> _faqDropdownItems = [];

  @override
  void initState() {
    selectedExistingFaqs = widget.parentFAQModel?.listExistingFaqs ?? [];
    _initializeProductCategories();
    _initializeFAQ();
    super.initState();
  }

  void _initializeProductCategories() {
    _faqDropdownItems = widget.listFaq.map((productCategory) {
      print('product ID ${productCategory.id}');
      return DropdownItem(
        label: productCategory.value?.toString() ?? '',
        value: productCategory,
        selected: widget.parentFAQModel?.listExistingFaqs
                .contains(productCategory.id?.toString()) ??
            false,
      );
    }).toList();
    _faqController.setItems(_faqDropdownItems);
  }

  void addFaq() {
    setState(() {
      productFAQs.add(FAQModel());
      _initializeControllers(productFAQs.length - 1);
    });
  }

  void _initializeFAQ() {
    productFAQs = widget.parentFAQModel?.listFaq ?? [];
    productFAQs.asMap().forEach((index, action) {
      _initializeControllers(index);
    });
  }

  void _initializeControllers(int index) {
    questionControllers
        .add(TextEditingController(text: productFAQs[index].question));
    answerControllers
        .add(TextEditingController(text: productFAQs[index].answer));
  }

  void deleteFaq(int index) {
    setState(() {
      productFAQs.removeAt(index);
      questionControllers.removeAt(index);
    });
  }

  void _returnBack() {
    Navigator.pop(
      context,
      ParentFAQModel(
        listFaq: productFAQs,
        listExistingFaqs: selectedExistingFaqs,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (!didPop) {
            _returnBack();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Product FAQs', style: vendorName(context)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _returnBack,
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize
                        .min, // Ensures content wraps instead of expanding
                    children: [
                      fieldTitle(
                          text: 'Select from existing FAQs',
                          textStyle:
                              const TextStyle(color: AppColors.lightCoral),),
                      kMinorSpace,
                      CustomMultiselectDropdown(
                        dropdownItems: _faqDropdownItems,
                        dropdownController: _faqController,
                        hintText: 'Select an option',
                        onSelectionChanged: (value) {
                          if (value is List<Faqs>) {
                            selectedExistingFaqs = value
                                .where((e) => e.id != null)
                                .map((e) => e.id!.toString())
                                .toList();
                            print('Selected Faqs: $selectedExistingFaqs');
                          } else {
                            print('Unexpected data type: ${value.runtimeType}');
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      const Align(
                        alignment: Alignment.center, // Center align explicitly
                        child: Text('Or',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16,),),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 80, top: 16,),
                  itemCount: productFAQs.length,
                  itemBuilder: (context, sectionIndex) => Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 16, left: 16, right: 16,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Spacer(),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deleteFaq(sectionIndex),
                              ),
                            ],
                          ),
                          CustomTextFormField(
                            labelText: 'Question',
                            required: false,
                            hintText: '',
                            controller: questionControllers[sectionIndex],
                            onChanged: (value) {
                              productFAQs[sectionIndex].question = value;
                            },
                          ),
                          kSmallSpace,
                          CustomTextFormField(
                            labelText: 'Answer',
                            required: false,
                            hintText: '',
                            controller: answerControllers[sectionIndex],
                            onChanged: (value) {
                              productFAQs[sectionIndex].answer = value;
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.lightCoral,
            onPressed: () => addFaq(),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      );
}
