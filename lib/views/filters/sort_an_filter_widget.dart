import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/styles/custom_text_styles.dart';

class SortAndFilterWidget extends StatefulWidget {
  const SortAndFilterWidget({
    super.key,
    required this.selectedSortBy,
    required this.onSortChanged,
    required this.onFilterPressed,
    this.showFilterButton = true,
  });

  final String selectedSortBy;
  final Function(String) onSortChanged;
  final VoidCallback onFilterPressed;
  final bool showFilterButton;

  @override
  State<SortAndFilterWidget> createState() => _SortAndFilterWidgetState();
}

class _SortAndFilterWidgetState extends State<SortAndFilterWidget> {
  late String _selectedSortBy;
  late String _langCode;

  final List<Map<String, String>> _sortOptions = [
    {
      'value': 'default_sorting',
      'label_en': 'Default Sorting',
      'label_ar': 'الترتيب الافتراضي',
      'label_hi': 'डिफ़ॉल्ट क्रम',
      'label_ru': 'Сортировка по умолчанию',
      'label_zh': '默认排序',
      'label_ur': 'ڈیفالٹ ترتیب',
    },
    {
      'value': 'date_asc',
      'label_en': 'Oldest',
      'label_ar': 'الأقدم',
      'label_hi': 'सबसे पुराना',
      'label_ru': 'Старые',
      'label_zh': '最旧',
      'label_ur': 'سب سے پرانا',
    },
    {
      'value': 'date_desc',
      'label_en': 'Newest',
      'label_ar': 'الأحدث',
      'label_hi': 'नवीनतम',
      'label_ru': 'Новые',
      'label_zh': '最新',
      'label_ur': 'نیا ترین',
    },
    {
      'value': 'name_asc',
      'label_en': 'Name: A-Z',
      'label_ar': 'الاسم: من أ إلى ي',
      'label_hi': 'नाम: A-Z',
      'label_ru': 'Имя: А-Я',
      'label_zh': '名称: A-Z',
      'label_ur': 'نام: A-Z',
    },
    {
      'value': 'name_desc',
      'label_en': 'Name: Z-A',
      'label_ar': 'الاسم: من ي إلى أ',
      'label_hi': 'नाम: Z-A',
      'label_ru': 'Имя: Я-А',
      'label_zh': '名称: Z-A',
      'label_ur': 'نام: Z-A',
    },
    {
      'value': 'price_asc',
      'label_en': 'Price: Low to High',
      'label_ar': 'السعر: من الأقل إلى الأعلى',
      'label_hi': 'मूल्य: कम से ज्यादा',
      'label_ru': 'Цена: по возрастанию',
      'label_zh': '价格: 从低到高',
      'label_ur': 'قیمت: کم سے زیادہ',
    },
    {
      'value': 'price_desc',
      'label_en': 'Price: High to Low',
      'label_ar': 'السعر: من الأعلى إلى الأقل',
      'label_hi': 'मूल्य: ज्यादा से कम',
      'label_ru': 'Цена: по убыванию',
      'label_zh': '价格: 从高到低',
      'label_ur': 'قیمت: زیادہ سے کم',
    },
    {
      'value': 'rating_asc',
      'label_en': 'Rating: Low to High',
      'label_ar': 'التقييم: من الأقل إلى الأعلى',
      'label_hi': 'रेटिंग: कम से ज्यादा',
      'label_ru': 'Рейтинг: по возрастанию',
      'label_zh': '评分: 从低到高',
      'label_ur': 'ریٹنگ: کم سے زیادہ',
    },
    {
      'value': 'rating_desc',
      'label_en': 'Rating: High to Low',
      'label_ar': 'التقييم: من الأعلى إلى الأقل',
      'label_hi': 'रेटिंग: ज्यादा से कम',
      'label_ru': 'Рейтинг: по убыванию',
      'label_zh': '评分: 从高到低',
      'label_ur': 'ریٹنگ: زیادہ سے کم',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedSortBy = widget.selectedSortBy;
  }

  @override
  Widget build(BuildContext context) {
    _langCode = Localizations.localeOf(context).languageCode;

    String getLabel(Map<String, String> option) {
      return option['label_$_langCode'] ?? option['label_en']!;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (widget.showFilterButton)
          InkWell(
            onTap: widget.onFilterPressed,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.tune, size: 18, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(AppStrings.filters.tr, style: sortingStyle(context)),
                ],
              ),
            ),
          )
        else
          const SizedBox.shrink(),
        DropdownButtonHideUnderline(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: _selectedSortBy,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedSortBy = newValue;
                  });
                  widget.onSortChanged(newValue);
                }
              },
              items: _sortOptions
                  .map((option) => DropdownMenuItem<String>(
                        value: option['value'],
                        child: Text(getLabel(option), style: sortingStyle(context)),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
