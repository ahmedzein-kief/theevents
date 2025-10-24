import 'package:flutter/material.dart';

import '../../provider/payment_address/customer_address_provider.dart';
import 'address_form_widget.dart';

class AddressFormBottomSheet {
  static void show(
    BuildContext context, {
    CustomerRecords? existingAddress,
    VoidCallback? onAddressSaved,
  }) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: AddressFormWidget(
                  existingAddress: existingAddress,
                  onAddressSaved: () {
                    Navigator.pop(context);
                    onAddressSaved?.call();
                  },
                  onCancel: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
