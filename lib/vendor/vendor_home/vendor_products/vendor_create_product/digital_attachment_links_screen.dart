import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/models/vendor_models/products/holder_models/digital_links_model.dart';
import 'package:event_app/vendor/Components/vendor_text_style.dart';
import 'package:event_app/vendor/components/dropdowns/generic_dropdown.dart';
import 'package:event_app/vendor/components/status_constants/file_size_constants.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class DigitalLinksScreen extends StatefulWidget {
  const DigitalLinksScreen({super.key, this.initialLinks});
  final List<DigitalLinksModel>? initialLinks;

  @override
  _DigitalLinksScreenState createState() => _DigitalLinksScreenState();
}

class _DigitalLinksScreenState extends State<DigitalLinksScreen> {
  final List<DigitalLinksModel> _selectedLinks = [];

  final List<String> units = [
    FileSizeConstants.BYTE,
    FileSizeConstants.KILO_BYTE,
    FileSizeConstants.MEGA_BYTE,
    FileSizeConstants.GIGA_BYTE,
    FileSizeConstants.TERRA_BYTE
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialLinks != null) {
      _selectedLinks.addAll(widget.initialLinks!);
    }
    setState(() {});
  }

  void _returnBack() {
    removeInvalidLinks();
    Navigator.pop(context, _selectedLinks);
  }

  void removeInvalidLinks() {
    _selectedLinks.removeWhere((link) =>
        link.fileName.isEmpty ||
        link.fileLink.isEmpty ||
        link.size.isEmpty ||
        link.unit.isEmpty);
  }

  void addLink() {
    setState(() {
      _selectedLinks.add(
        DigitalLinksModel(
          unit: FileSizeConstants.BYTE,
          fileLinkController: TextEditingController(),
          fileNameController: TextEditingController(),
          sizeController: TextEditingController(),
        ),
      );
    });
  }

  void deleteLink(int index) {
    setState(() {
      _selectedLinks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Digital Links',
            style: vendorName(context),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _returnBack,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: _selectedLinks.length,
            itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      labelText: '',
                      showTitle: false,
                      required: false,
                      readOnly: _selectedLinks[index].isSaved,
                      hintText: 'File Name',
                      controller: _selectedLinks[index].fileNameController,
                      onChanged: (value) {
                        _selectedLinks[index].fileName = value;
                      },
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      labelText: '',
                      showTitle: false,
                      required: false,
                      readOnly: _selectedLinks[index].isSaved,
                      hintText: 'External Link',
                      keyboardType: TextInputType.url,
                      controller: _selectedLinks[index].fileLinkController,
                      validator: Validator.isValidUrl,
                      onChanged: (value) {
                        _selectedLinks[index].fileLink = value;
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: CustomTextFormField(
                            labelText: '',
                            showTitle: false,
                            required: false,
                            readOnly: _selectedLinks[index].isSaved,
                            hintText: 'Size',
                            keyboardType: TextInputType.number,
                            controller: _selectedLinks[index].sizeController,
                            onChanged: (value) {
                              _selectedLinks[index].size = value;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          flex: 1,
                          child: GenericDropdown<String>(
                            textStyle: const TextStyle(
                                color: Colors.grey, fontSize: 15),
                            value: _selectedLinks[index].unit.contains('-')
                                ? 'B'
                                : _selectedLinks[index].unit,
                            menuItemsList: units,
                            readOnly: _selectedLinks[index].isSaved,
                            displayItem: (String priceType) => priceType,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedLinks[index].unit = value ?? 'B';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Text(
                            _selectedLinks[index].isSaved ? 'Saved' : 'Unsaved',
                            style: const TextStyle(color: Colors.orange),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteLink(index),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.lightCoral,
          onPressed: () => addLink(),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      );
}
