import 'package:dio/dio.dart';
import 'package:event_app/models/vendor_models/products/holder_models/upload_images_model.dart';
import 'package:event_app/vendor/components/status_constants/product_type_constants.dart';

import '../holder_models/digital_links_model.dart';

class ProductPostDataModel {
  ProductPostDataModel({
    this.name = '',
    this.slug = '',
    this.slugId = '0',
    this.isSlugEditable = '1',
    this.description = '',
    this.content = '',
    this.productType = '',
    this.sku = '',
    this.autoGenerateSku = '0',
    this.price = '',
    this.salePrice = '',
    this.startDate = '',
    this.endDate = '',
    this.costPerItem = '',
    this.barcode = '',
    this.withStorehouseManagement = '',
    this.quantity = '',
    this.allowCheckoutWhenOutOfStock = '',
    this.stockStatus = '',
    this.weight = '',
    this.length = '',
    this.wide = '',
    this.height = '',
    this.addedAttributes,
    this.options = const [],
    this.relatedProducts = '',
    this.packageProducts = '',
    this.crossSaleProducts = const {},
    this.seoMeta = const {},
    this.categories = const [],
    this.brandId = '',
    this.productCollections = const [],
    this.productLabels = const [],
    this.taxes = const [],
    this.tag = const [],
    this.faqSchemaConfig = const [],
    this.selectedExistingFaqs,
    this.images = const [],

    /// this is required in digital product
    this.productFilesExternal,
    this.productFilesInput,
    this.generateLicenseCode = '0',
  });
  String? name;
  String? slug;
  String? slugId;
  String? isSlugEditable;
  String? description;
  String? content;
  String? productType;
  String? sku;
  String? autoGenerateSku;
  String? price;
  String? salePrice;
  String? startDate;
  String? endDate;
  String? costPerItem;
  String? barcode;
  String? withStorehouseManagement;
  String? quantity;
  String? allowCheckoutWhenOutOfStock;
  String? stockStatus;
  String? weight;
  String? length;
  String? wide;
  String? height;
  Map<String, String>? addedAttributes;
  List<Map<String, dynamic>?> options;
  String relatedProducts;
  String packageProducts;
  Map<String, dynamic>? crossSaleProducts;
  Map<String, dynamic>? seoMeta;
  List<int> categories;
  String? brandId;
  List<int> productCollections;
  List<int> productLabels;
  List<int> taxes;
  List<Map<String, String>> tag;
  List<dynamic> faqSchemaConfig;
  List<String>? selectedExistingFaqs;
  List<String>? images;

  String generateLicenseCode;
  List<DigitalLinksModel>? productFilesExternal;
  List<UploadImagesModel>? productFilesInput;
  List<dynamic>? productFiles;
}

class ProductFileExternalPostData {
  ProductFileExternalPostData({
    this.url = '',
    this.fileType = '',
  });
  String url;
  String fileType;
}

class ProductOptionValuePostData {
  ProductOptionValuePostData({
    this.id = '',
    this.affectPrice = '',
    this.affectType = '',
    this.order = '',
    this.optionValue = '',
  });
  String id;
  String affectPrice;
  String affectType;
  String order;
  String optionValue;

  @override
  String toString() =>
      'ProductOptionValuePostData { id: $id, affectPrice: $affectPrice, affectType: $affectType, order: $order, optionValue: $optionValue }';
}

extension ProductPostDataModelExtension on ProductPostDataModel {
  /// physical product, digital product and packages create from data
  FormData toFormData() {
    final fields = {
      'name': name ?? '',
      'slug': slug ?? '',
      'slug_id': slugId ?? '0',
      'is_slug_editable': isSlugEditable ?? '1',
      'description': description ?? '',
      'content': content ?? '',
      'product_type': productType ?? '',
      'sku': sku ?? '',
      'price': price ?? '',
      'sale_price': salePrice ?? '',
      'start_date': startDate ?? '',
      'end_date': endDate ?? '',
      'sale_type':
          (startDate?.isNotEmpty == true && endDate?.isNotEmpty == true)
              ? '1'
              : '0',
      'cost_per_item': costPerItem ?? '',
      'barcode': barcode ?? '',
      'with_storehouse_management': withStorehouseManagement ?? '',
      'quantity': quantity ?? '',
      'allow_checkout_when_out_of_stock': allowCheckoutWhenOutOfStock ?? '',
      'stock_status': stockStatus ?? '',

      // if (productType == ProductTypeConstants.PHYSICAL) ...{
      'weight': weight ?? '',
      'length': length ?? '',
      'wide': wide ?? '',
      'height': height ?? '',
      // },

      'related_products': relatedProducts ?? '',
      if (productType == ProductTypeConstants.PACKAGE)
        'package_products': packageProducts ?? '',
      'brand_id': (brandId?.trim().isNotEmpty == true &&
              brandId?.toString() != 'null' &&
              brandId != null)
          ? brandId
          : '0',
      'is_added_attributes': addedAttributes?.isNotEmpty == true ? '1' : '0',
      'has_product_options': options.isNotEmpty ? '1' : '0',
      'categories[]': categories.isNotEmpty ? categories : [],
      'product_collections[]':
          productCollections.isNotEmpty ? productCollections : [],
      'product_labels[]': productLabels.isNotEmpty ? productLabels : [],
      'taxes[]': taxes.isNotEmpty ? taxes : [],
      'tag': tag.isNotEmpty ? tag : [],
      'faq_schema_config': faqSchemaConfig.isNotEmpty ? faqSchemaConfig : [],
      'selected_existing_faqs[]': selectedExistingFaqs ?? [],
      'images[]': images ?? [],
      'options': options,
      'seo_meta': seoMeta ?? {},
      'attribute_sets': addedAttributes ?? {},
      'cross_sale_products': crossSaleProducts ?? {},

      if (productType == ProductTypeConstants.DIGITAL) ...{
        'product_files[]': productFiles ?? [],
        'generate_license_code': generateLicenseCode,
        'product_files_external':
            productFilesExternal?.map((e) => e.toJson()).toList() ?? [],
      },
    };

    /// digital product files
    final files = <MultipartFile>[];
    for (final UploadImagesModel myFile in productFilesInput ?? []) {
      if (myFile.file.path.isNotEmpty) {
        files.add(myFile.toMultipartFile());
      }
    }

    final formData = FormData.fromMap({
      ...fields,
      if (productType == ProductTypeConstants.DIGITAL)
        'product_files_input[]': files,
    });

    return formData;
  }

  /// product variations from data
  FormData toVariationFormData() {
    final fields = {
      'sku': sku ?? '',
      'auto_generate_sku': sku?.isEmpty == true ? autoGenerateSku ?? '0' : '0',
      'price': price ?? '',
      'sale_price': salePrice ?? '',
      'start_date': startDate ?? '',
      'end_date': endDate ?? '',
      'sale_type':
          (startDate?.isNotEmpty == true && endDate?.isNotEmpty == true)
              ? '1'
              : '0',
      'cost_per_item': costPerItem ?? '',
      'barcode': barcode ?? '',
      'with_storehouse_management': withStorehouseManagement ?? '',
      'quantity': quantity ?? '',
      'allow_checkout_when_out_of_stock': allowCheckoutWhenOutOfStock ?? '',
      'stock_status': stockStatus ?? '',
      'attribute_sets': addedAttributes ?? {},
      'images[]': images ?? [],

      // if (productType == ProductTypeConstants.PHYSICAL) ...{
      'weight': weight ?? '',
      'length': length ?? '',
      'wide': wide ?? '',
      'height': height ?? '',
      // },

      if (productType == ProductTypeConstants.DIGITAL) ...{
        'product_files[]': productFiles ?? [],
        'generate_license_code': generateLicenseCode,
        'product_files_external':
            productFilesExternal?.map((e) => e.toJson()).toList() ?? [],
      },
    };

    final files = <MultipartFile>[];
    for (final UploadImagesModel myFile in productFilesInput ?? []) {
      if (myFile.file.path.isNotEmpty) {
        files.add(myFile.toMultipartFile());
      }
    }

    final formData = FormData.fromMap({
      ...fields,
      if (productType == ProductTypeConstants.DIGITAL)
        'product_files_input[]': files,
    });

    return formData;
  }
}
