import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/styles/app_colors.dart';
import '../../Components/data_tables/custom_data_tables.dart';

class Utils {
  //*------Common Loading Indicators Start------*/

  /// Material Loading Indicator
  static Widget materialLoadingIndicator({color = Colors.white}) =>
      Center(child: CircularProgressIndicator(color: color, strokeWidth: 1.5));

  /// Cupertino Loading Indicator
  static Widget cupertinoLoadingIndicator({color = AppColors.lightCoral}) =>
      Center(child: CupertinoActivityIndicator(color: color));

  /// Page loading indicator
  static Widget pageLoadingIndicator(
          {color = AppColors.lightCoral, required context}) =>
      Center(
          child: Platform.isAndroid
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: Utils.materialLoadingIndicator(color: color))
              : Utils.cupertinoLoadingIndicator(color: color));

  /// Page Refresh Indicator
  static Widget pageRefreshIndicator({required child, required onRefresh}) =>
      RefreshIndicator(
          color: Colors.white,
          backgroundColor: AppColors.lightCoral,
          onRefresh: onRefresh,
          child: child);

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
  static Widget modelProgressHud({bool processing = true, child}) {
    final Widget progressIndicator = Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // Curved border
        // image: DecorationImage(image: AssetImage("assets/app_logo.jpg"))
      ),
      padding: const EdgeInsets.all(10),
      child: Platform.isAndroid
          ? Utils.materialLoadingIndicator(color: AppColors.lightCoral)
          : Utils.cupertinoLoadingIndicator(color: AppColors.lightCoral),
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

  static Widget modelProgressDashboardHud({bool processing = true, child}) {
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
          ? Utils.materialLoadingIndicator(color: AppColors.lightCoral)
          : Utils.cupertinoLoadingIndicator(color: AppColors.lightCoral),
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
  static Widget somethingWentWrong() => const Center(
        child: Text(
          'Something went wrong...',
        ),
      );

  static Widget noDataAvailable() => const Center(
        child: Text(
          'No data to display.',
          style: TextStyle(height: 3),
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
        return await getApplicationDocumentsDirectory(); // For iOS, it’s the same or getApplicationCacheDirectory
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
    // Check if the URL is a Uri object and convert it to a string
    if (url is Uri) {
      url = url.toString();
    }

    // Continue with the URL launching logic
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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
        await launchUrl(emailLaunchUri);
      }
    } catch (e) {}
  }

  // make phone call
  static Future<void> makePhoneCall(
      {required String phoneNumber, required BuildContext context}) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    try {
      await launchUrl(launchUri);
    } catch (e) {}
  }

  // Static method to format the timestamp
  static String formatTimestamp(String timestamp) {
    // Parse the timestamp string into a DateTime object
    final DateTime dateTime = DateTime.parse(timestamp);

    // Format the DateTime object into a readable string (e.g., "Jan 30, 2025 8:04")
    return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
  }

  /// searching for component
  static Widget searching({required BuildContext context}) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
                width: 16,
                height: 16,
                child: Utils.pageLoadingIndicator(context: context)),
            const SizedBox(width: 8),
            const Text('Searching...', style: TextStyle(color: Colors.grey)),
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
            borderRadius:
                BorderRadius.circular(8.0), // Replace `kSmallCardRadius`
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
    final int fileSizeInBytes =
        await file.length(); // Get the file size in bytes
    final int maxSizeInBytes = maxSizeInKB * 1024; // Convert KB to bytes

    // Return true if the file size is within the limit
    return fileSizeInBytes <= maxSizeInBytes;
  }
}
