import 'package:event_app/models/dashboard/information_icons_models/gift_card_models/checkout_payment_model.dart';
import 'package:event_app/provider/information_icons_provider/gift_card_provider.dart';
import 'package:event_app/core/styles/custom_text_styles.dart';
import 'package:event_app/views/payment_screens/payment_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/custom_input_decoration.dart';
import '../../../../utils/validator/validator.dart';
import 'gift_card_bottom.dart';
import 'payments_methods.dart';

class GiftCardForm extends StatefulWidget {
  const GiftCardForm({super.key});

  @override
  State<GiftCardForm> createState() => _GiftCardFormState();
}

class _GiftCardFormState extends State<GiftCardForm> {
// Create a TextEditingController directly in the state class

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _receiptNameController = TextEditingController();
  final TextEditingController _cardEmailController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  List<int> prices = [100, 200, 500, 1000];

  bool _isNavigateToPaymentScreen = false;

  void controllerValidation() {
    if (_formKey.currentState?.validate() ?? false) {
    } else {
    }
  }

  final TextEditingController _customTextController = TextEditingController();
  bool _navigatedToPaymentScreen = false;

  @override
  void initState() {
    super.initState();
    // Listen for changes in the TextField
    _customTextController.addListener(_handleCustomTextInput);
  }

  @override
  void dispose() {
    _customTextController.removeListener(() {});
    _customTextController.dispose();
    super.dispose();
  }

  String selectedPrice = "";
  Map<String, String> paymentMethod = {};
  List<bool> _selected = [false, false, false, false];

  Future<CheckoutPaymentModel?> createGiftCard() async {
    final provider = Provider.of<CreateGiftCardProvider>(context, listen: false);
    final response = await provider.createGiftCard(
      _customTextController.text,
      _receiptNameController.text,
      _cardEmailController.text,
      _notesController.text,
      paymentMethod,
    );
    return response;
  }

  void _onSelect(int index) {
    setState(() {
      // Deselect all and select the current index
      for (int i = 0; i < _selected.length; i++) {
        _selected[i] = i == index;
      }

      // Update the text controller without disrupting user input
      selectedPrice = prices[index].toString();
      if (_customTextController.text != selectedPrice) {
        _customTextController.text = selectedPrice; // Set the selected value in the controller
        // Move cursor to the end of the text field
        _customTextController.selection = TextSelection.fromPosition(
          TextPosition(offset: selectedPrice.length),
        );
      }
    });
  }

  void _handleCustomTextInput() {
    String inputText = _customTextController.text;

    // Check if the input matches any of the predefined values
    bool isMatchFound = false;

    for (int i = 0; i < _selected.length; i++) {
      String value = prices[i].toString();
      if (value == inputText) {
        isMatchFound = true;
        _onSelect(i); // Call _onSelect to select the matched value
        break; // Exit the loop once a match is found
      }
    }

    // Deselect all if no match is found and input is not empty
    if (!isMatchFound && inputText.isNotEmpty) {
      setState(() {
        _selected.fillRange(0, _selected.length, false); // Deselect all
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select Gift Card Amount", style: giftSelectAmountText(context)),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                SingleChildScrollView(
                  // Wrap Row in SingleChildScrollView
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ...List.generate(
                        4,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              _onSelect(index);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black), color: _selected[index] ? Colors.black : Colors.white, borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                '${prices[index]} AED',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: _selected[index] ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textAlign: TextAlign.center,
                          controller: _customTextController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Select or add amount";
                            }
                            if (value.isNotEmpty) {
                              try {
                                double parsedValue = double.parse(value); // Parses both int & double
                                if (parsedValue > 10000) {
                                  return "Amount must be less than 10000 AED";
                                }
                              } catch (e) {
                                return "Invalid amount entered"; // Handles invalid numbers or large values
                              }
                              return null; // No error
                            }

                            return null;
                          },
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            height: .6,
                            fontSize: 12,
                          ),
                          cursorHeight: 10,
                          decoration: CustomInputDecoration.getDecoration(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Enter Receipt Name *', softWrap: true, style: giftSelectAmountText(context)),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: _receiptNameController,
                                validator: Validator.nameGiftCard,
                                cursorHeight: 10,
                                decoration: CustomInputDecoration.getDecoration(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Enter Receipt Email *', softWrap: true, style: giftSelectAmountText(context)),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: _cardEmailController,
                                validator: Validator.emailGiftCard,
                                style: const TextStyle(height: 0.2),
                                cursorHeight: 10,
                                decoration: CustomInputDecoration.getDecoration(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Additional Notes', softWrap: true, style: giftSelectAmountText(context)),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: TextFormField(
                                controller: _notesController,
                                maxLines: 4,
                                style: const TextStyle(height: 1.5),
                                // Adjust height if needed
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 8, top: 8),
                                  // Adjust padding to align text
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 1, // Border width when focused
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  filled: true,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      PaymentMethods(onSelectionChanged: (selectedMethod) {

                        paymentMethod = selectedMethod;
                      }),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Consumer<CreateGiftCardProvider>(
                          builder: (context, createGiftCardProvider, _) {
                            if (createGiftCardProvider.loading) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 0.4,
                              ));
                            }
                            return InkWell(
                              onTap: () async {
                                if (_formKey.currentState?.validate() ?? false) {
                                  final response = await createGiftCard();

                                  final data = response?.data;

                                  // Check if the checkoutUrl is available and we haven't navigated yet
                                  if (data?.checkoutUrl.isNotEmpty == true) {
                                    _navigatedToPaymentScreen = true; // Set the flag to true
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaymentViewScreen(checkoutUrl: data!.checkoutUrl),
                                      ),
                                    );
                                  }
                                } else {
                                }
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Pay Now",
                                  style: payNowText(context),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                GiftCardBottom()
              ],
            ),
          )
        ],
      ),
    );
  }
}
