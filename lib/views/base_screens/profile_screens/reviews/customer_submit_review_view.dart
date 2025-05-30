import 'dart:io';

import 'package:dio/dio.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/models/account_models/reviews/customer_get_product_reviews_model.dart';
import 'package:event_app/provider/customer/account_view_models/reviews/customer_get_product_reviews_view_model.dart';
import 'package:event_app/provider/customer/account_view_models/reviews/customer_submit_review_view_model.dart';
import 'package:event_app/core/utils/custom_toast.dart';
import 'package:event_app/core/widgets/custom_auth_views/app_custom_button.dart';
import 'package:event_app/utils/mixins_and_constants/constants.dart';
import 'package:event_app/utils/mixins_and_constants/media_query_mixin.dart';
import 'package:event_app/vendor/components/services/media_services.dart';
import 'package:event_app/vendor/components/settings_components/choose_file_card.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:event_app/views/base_screens/profile_screens/profile_review_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/widgets/custom_profile_views/custom_back_appbar_view.dart';
import '../../../../utils/validator/validator.dart';
import '../../../../vendor/components/utils/utils.dart' show Utils;

class CustomerSubmitReviewView extends StatefulWidget {
  double? currentRating;
  final ProductsAvailableForReview productsAvailableForReview;

  CustomerSubmitReviewView(
      {super.key,
      this.currentRating,
      required this.productsAvailableForReview});

  @override
  State<CustomerSubmitReviewView> createState() =>
      _CustomerSubmitReviewViewState();
}

class _CustomerSubmitReviewViewState extends State<CustomerSubmitReviewView>
    with MediaQueryMixin {
  final TextEditingController _reviewController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<File?> _photos = [];

  _addPhotos() async {
    try {
      final files = await MediaServices().getMultipleFilesFromPicker(allowedExtensions: MediaServices().allowedImageExtension);

      if (files?.isNotEmpty ?? false) {
        const int maxCount = 6; // Maximum number of files allowed
        const int maxSizeInKB = 2000; // Maximum file size allowed (2MB)

        // Check if the combined total exceeds the max limit
        if (_photos.length + files!.length > maxCount) {
          CustomSnackbar.showError(
              context, "You can only select a maximum of $maxCount files");
          return;
        }

        for (var file in files) {
          if (_photos.contains(file)) {
            continue; // Skip duplicates
          }

          bool validFileSize =
              await Utils.compareFileSize(file: file, maxSizeInKB: maxSizeInKB);

          if (validFileSize) {
            _photos.add(file);
          } else {
            CustomSnackbar.showError(context, "${file.path.split('/').last} size must be less than 2MB");
          }

          // Recheck max count after adding each file
          if (_photos.length >= maxCount) {
            CustomSnackbar.showError(context, "You have reached the maximum limit of $maxCount files");
            break;
          }
        }
        setState(() {});
      }
    } catch (e) {
      print("Failed to Add Photos $e");
    }
  }

  _removePhotos({required int index}) {
    setState(() {
      _photos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addPhotos(),
        backgroundColor: AppColors.lightCoral,
        child: Icon(
          Icons.add_a_photo_rounded,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BackAppBarStyle(
              icon: Icons.arrow_back_ios,
              text: 'My Account',
            ),
            Expanded(child: _reviewForm(context)),
          ],
        ),
      ),
    );
  }

  Widget _reviewForm(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: kPadding, vertical: viewInsets.top),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              kSmallSpace,

              /// Name
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  color: Colors.grey.shade300,
                  child: Text(
                    widget.productsAvailableForReview.cleanName ?? '',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
              kSmallSpace,

              /// Stars
              RatingBar.builder(
                initialRating: widget.currentRating ?? 0.0,
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemSize: 30,
                itemBuilder: (context, _) {
                  /// show static color here
                  return Icon(
                    Icons.star,
                    color: Colors.amber,
                  );
                },
                onRatingUpdate: (rating) async {
                  /// navigate to submit review view
                  widget.currentRating = rating;
                },
              ),
              kSmallSpace,

              /// Review textarea
              CustomTextFormField(
                  labelText: "Review",
                  required: true,
                  maxLines: 4,
                  hintText: "",
                  validator: Validator.fieldCannotBeEmpty,
                  controller: _reviewController),
              kSmallSpace,

              /// upload up to 6 photos with max 2 mb size
              Text(
                "Upload Photos",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              Text(
                "You can upload up to 6 photos, each photo max size is 2MB.",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
              kSmallSpace,

              /// Images
              _images(),
              kExtraLargeSpace,

              /// submit button
              ChangeNotifierProvider(create: (context)=>CustomerSubmitReviewViewModel(),
              child: Consumer<CustomerSubmitReviewViewModel>(
                builder: (context,provider,_){
                 return Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            child: CustomAppButton(
                              borderRadius: 4,
                              buttonText: "Submit Review",
                              buttonColor: AppColors.lightCoral,
                              isLoading: provider.apiResponse.status == ApiStatus.LOADING,
                              onTap: () async {
                                if (_formKey.currentState?.validate() ?? false) {


                                  try {
                                    _createForm();
                                    final result = await provider.customerSubmitReview(form: formData, context: context);
                                    if(result){
                                      Navigator.pop(context,1);
                                      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=>ProfileReviewScreen(initialTabIndex: 1,)));
                                    }
                                  }catch(e){
                                    print('Error while submitting review: ${e}');
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget _images() {
    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      spacing: 10,
      runSpacing: 10,
      children: _photos.map((photo) {
        int index = _photos.indexOf(photo);
        return ChooseFileCard(
          width: screenWidth / 4,
          height: screenWidth / 4,
          onClose: () => _removePhotos(index: index),
          file: _photos[index],
        );
      }).toList(),
    );
  }

  dynamic formData = FormData();

  _createForm() {
    final fields = {
      "product_id": widget.productsAvailableForReview.id,
      "star": widget.currentRating?.toInt(),
      "comment": _reviewController.text,
    };
    final files = <MultipartFile>[];
    for (File? myFile in _photos) {
      if (myFile != null) {
        if (myFile.path.isNotEmpty) {
          files.add(MultipartFile.fromFileSync(
            myFile.path,
            filename: myFile.path.split('/').last,
          ));
        }
      }
    }
    formData = FormData.fromMap({
      ...fields,
      'images[]': files,
    });
  }
}
