import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../vendor/Components/data_tables/custom_data_tables.dart';
import '../constants/app_strings.dart';
import '../helper/extensions/app_localizations_extension.dart';
import '../styles/app_colors.dart';

class AppUtils {
  /// remove unwanted currency codes from price text
  static String cleanPrice(String input) {
    const codes = ['AED', 'USD', 'EUR', 'SAR', 'EGP'];
    var result = input;
    for (final code in codes) {
      result = result.replaceAll(code, '').trim();
    }
    return result;
  }

  static void showToast(String text, {bool isSuccess = false, bool isInfo = false, bool long = true}) {
    Color color = Colors.red;
    if (isInfo) {
      color = Colors.orangeAccent;
    } else if (isSuccess) {
      color = Colors.green;
    }

    Fluttertoast.showToast(
      msg: text,
      backgroundColor: color,
      fontSize: 16,
      toastLength: long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
    );
  }

  //*------Common Loading Indicators Start------*/

  /// Material Loading Indicator
  static Widget materialLoadingIndicator({
    color,
    required BuildContext context,
  }) =>
      Center(
        child: CircularProgressIndicator(
          color: color ?? Theme.of(context).colorScheme.primary,
          strokeWidth: 1.5,
        ),
      );

  /// Cupertino Loading Indicator
  static Widget cupertinoLoadingIndicator({
    color,
    required BuildContext context,
  }) =>
      Center(
        child: CupertinoActivityIndicator(
          color: color ?? Theme.of(context).colorScheme.primary,
        ),
      );

  /// Page loading indicator
  static Widget pageLoadingIndicator({color, required BuildContext context}) => Center(
        child: Platform.isAndroid
            ? SizedBox(
                width: 20,
                height: 20,
                child: AppUtils.materialLoadingIndicator(
                  color: color ?? Theme.of(context).colorScheme.primary,
                  context: context,
                ),
              )
            : AppUtils.cupertinoLoadingIndicator(
                color: color ?? Theme.of(context).colorScheme.primary,
                context: context,
              ),
      );

  /// Page Refresh Indicator
  static Widget pageRefreshIndicator({
    required child,
    required onRefresh,
    required BuildContext context,
  }) =>
      RefreshIndicator(
        color: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onRefresh: onRefresh,
        child: child,
      );

  /// Spin kit three dots bounce
  static Widget spinKitThreeBounce() => const Center(
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
          child: SpinKitThreeBounce(
            color: AppColors.lightCoral,
            size: 23,
          ),
        ),
      );

  /// Model Progress Hud
  static Widget modelProgressHud({
    required BuildContext context,
    bool processing = true,
    child,
  }) {
    final Widget progressIndicator = Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), // Curved border
        // image: DecorationImage(image: AssetImage("assets/app_logo.jpg"))
      ),
      padding: const EdgeInsets.all(10),
      child: Platform.isAndroid
          ? AppUtils.materialLoadingIndicator(
              color: AppColors.lightCoral,
              context: context,
            )
          : AppUtils.cupertinoLoadingIndicator(
              color: AppColors.lightCoral,
              context: context,
            ),
    );
    return ModalProgressHUD(
      color: Colors.blueGrey,
      opacity: 0.3,
      blur: 0.1,
      dismissible: false,
      progressIndicator: progressIndicator,
      inAsyncCall: processing,
      child: child,
    );
  }

  static Widget modelProgressDashboardHud({
    required BuildContext context,
    bool processing = true,
    child,
  }) {
    final Widget progressIndicator = Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16), // Curved border
        // image: DecorationImage(image: AssetImage("assets/app_logo.jpg"))
      ),
      padding: const EdgeInsets.all(10),
      child: Platform.isAndroid
          ? AppUtils.materialLoadingIndicator(
              color: AppColors.lightCoral,
              context: context,
            )
          : AppUtils.cupertinoLoadingIndicator(
              color: AppColors.lightCoral,
              context: context,
            ),
    );
    return ModalProgressHUD(
      color: Colors.blueGrey,
      opacity: 0.3,
      blur: 0.1,
      dismissible: false,
      progressIndicator: progressIndicator,
      inAsyncCall: processing,
      child: child,
    );
  }

  //*------Common Loading Indicators End------*/
  /// Show on something went wrong
  static Widget somethingWentWrong() => Center(
        child: Text(
          AppStrings.errorFetchingData.tr,
        ),
      );

  static Widget noDataAvailable() => Center(
        child: Text(
          AppStrings.noDataAvailable.tr,
          style: const TextStyle(height: 3),
        ),
      );

  /// Data Header styling for Table
  static Widget buildHeaderCell(String value) => Expanded(
        child: Text(
          value,
          style: dataColumnTextStyle(),
          textAlign: TextAlign.center,
        ),
      );

  // Data Cell Styling for Table
  static Widget buildDataCell(Widget data) => Expanded(
        child: data,
      );

  // Method to save pdf with its corresponding name
  static Future<File> saveDocument({
    required String name, // Document is from pdf widget
    required pdfResponse,
  }) async {
    try {
      // Getting the appropriate storage directory depending on platform
      final Directory myStorage = await getStorageDirectory();

      // Define the file extension
      const extension = '.pdf';

      // Construct the save path with the document name and extension
      final String savePath = '${myStorage.path}/invoice-$name$extension';

      // Create a File instance to handle the document
      final File file = File(savePath);

      // Write the PDF byte data into the file
      await file.writeAsBytes(pdfResponse);

      // print("File saved at: $savePath");

      // Return the saved file
      return file;
    } catch (e) {
      rethrow;
    }
  }

  // Helper function to get the storage directory depending on platform
  static Future<Directory> getStorageDirectory() async {
    try {
      if (Platform.isAndroid) {
        return await getApplicationDocumentsDirectory();
      } else if (Platform.isIOS) {
        return await getApplicationDocumentsDirectory(); // For iOS, it's the same or getApplicationCacheDirectory
      } else {
        throw UnsupportedError('Unsupported platform for file storage');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Method to open pdf
  static Future<void> openDocument(File file) async {
    // fetching the path
    final path = file.path;
    // open the pdf
    await OpenFile.open(path);
  }

  /// launch url
  static Future<void> launchUrl(url) async {
    // Convert URL to Uri if it's a string
    Uri uri;
    if (url is String) {
      uri = Uri.parse(url);
    } else if (url is Uri) {
      uri = url;
    } else {
      throw ArgumentError('URL must be either a String or Uri');
    }

    // Continue with the URL launching logic
    if (await canLaunchUrl(uri)) {
      await launchUrlString(uri.toString());
    } else {
      throw Exception('Could not launch $uri');
    }
  }

  /// launch email
  static Future<void> launchEmail(String emailAddress) async {
    try {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: emailAddress,
      );
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrlString(emailLaunchUri.toString());
      } else {
        AppUtils.showToast(AppStrings.error.tr);
      }
    } catch (e) {
      AppUtils.showToast('${AppStrings.error.tr}${e.toString()}');
    }
  }

// make phone call
  static Future<void> makePhoneCall({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrlString(launchUri.toString());
      } else {
        AppUtils.showToast(AppStrings.error.tr);
      }
    } catch (e) {
      AppUtils.showToast('${AppStrings.error.tr}${e.toString()}');
    }
  }

// Static method to format the timestamp
  static String formatTimestamp(String timestamp) {
    // Handle null, empty, or invalid strings
    if (timestamp.isEmpty || timestamp.trim().isEmpty) {
      return '--';
    }

    try {
      // Parse the timestamp string into a DateTime object
      final DateTime dateTime = DateTime.parse(timestamp);

      // Format the DateTime object into a readable string (e.g., "Jan 30, 2025 8:04")
      return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
    } catch (e) {
      // Log the error for debugging
      debugPrint('Error parsing timestamp "$timestamp": $e');
      return '--';
    }
  }

  /// searching for component
  static Widget searching({required BuildContext context}) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: AppUtils.pageLoadingIndicator(context: context),
            ),
            const SizedBox(width: 8),
            Text(AppStrings.loading.tr, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );

  static Widget dragHandle({required context}) => Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.13,
          height: 5,
          margin: const EdgeInsets.only(top: 8.0), // Replace `kSmallPadding`
          decoration: BoxDecoration(
            color: AppColors.lightCoral, // Replace with `AppColors.lightCoral`
            borderRadius: BorderRadius.circular(8.0), // Replace `kSmallCardRadius`
          ),
        ),
      );

  static String? formatTimestampToYMDHMS(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) return null;

    try {
      final DateTime dateTime = DateTime.parse(timestamp).toLocal();
      return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} "
          "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
    } catch (e) {
      return null; // Return null if parsing fails
    }
  }

  static Future<bool> compareFileSize({
    required File file,
    required int maxSizeInKB,
  }) async {
    final int fileSizeInBytes = await file.length(); // Get the file size in bytes
    final int maxSizeInBytes = maxSizeInKB * 1024; // Convert KB to bytes

    // Return true if the file size is within the limit
    return fileSizeInBytes <= maxSizeInBytes;
  }

  // Check if the current locale is RTL
  static bool isRTL(context) => Directionality.of(context) == TextDirection.rtl;
}
