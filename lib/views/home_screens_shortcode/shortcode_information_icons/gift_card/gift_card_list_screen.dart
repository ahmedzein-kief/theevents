import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/gift_card/gift_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/information_icons_provider/gift_card_list_provider.dart';

class GiftCardListScreen extends StatefulWidget {
  const GiftCardListScreen({super.key});

  @override
  State<GiftCardListScreen> createState() => _GiftCardListScreenState();
}

class _GiftCardListScreenState extends State<GiftCardListScreen> {
  late ScrollController _horizontalScrollController;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchGiftCardList();
    });
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  Future<void> fetchGiftCardList() async {
    final provider = Provider.of<GiftCardListProvider>(context, listen: false);
    provider.fetchGiftCardList(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BaseAppBar(
      textBack: AppStrings.back.tr,
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      firstRightIconPath: AppStrings.firstRightIconPath.tr,
      secondRightIconPath: AppStrings.secondRightIconPath.tr,
      thirdRightIconPath: AppStrings.thirdRightIconPath.tr,
      body: Scaffold(
        backgroundColor: isDark ? Colors.grey.shade900 : const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Consumer<GiftCardListProvider>(
            builder: (context, giftCardProvider, _) {
              if (giftCardProvider.loading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: isDark ? Colors.white : Colors.black,
                    strokeWidth: 2.0,
                  ),
                );
              }
              if (giftCardProvider.error != null && giftCardProvider.error != AppStrings.noRecordFound.tr) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        giftCardProvider.error!,
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => fetchGiftCardList(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.peachyPink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          AppStrings.retry.tr,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final giftCards = giftCardProvider.giftCards;

              return Column(
                children: [
                  // Header with title and create button
                  Container(
                    padding: const EdgeInsetsDirectional.fromSTEB(24, 20, 12, 20),
                    color: isDark ? Colors.grey.shade800 : Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.giftCards.tr,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF1F2937),
                            letterSpacing: -0.5,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GiftCardScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add, color: Colors.white, size: 18),
                          label: Text(
                            AppStrings.create.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.peachyPink,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (giftCards.isEmpty)
                    _buildEmptyState(isDark)
                  else
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey.shade800 : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withAlpha((0.3 * 255).toInt())
                                  : Colors.black.withAlpha((0.04 * 255).toInt()),
                              spreadRadius: 0,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: isDark ? Colors.grey.shade700 : const Color(0xFFE5E7EB),
                            width: 1,
                          ),
                        ),
                        child: SingleChildScrollView(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width:
                                MediaQuery.of(context).size.width < 800 ? 800 : MediaQuery.of(context).size.width - 48,
                            child: Column(
                              children: [
                                // Table Header
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.grey.shade900 : const Color(0xFFF9FAFB),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: isDark ? Colors.grey.shade700 : const Color(0xFFE5E7EB),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      _buildHeaderCell(AppStrings.sku.tr, minWidth: 80, isDark: isDark),
                                      _buildHeaderCell(AppStrings.code.tr, minWidth: 140, isDark: isDark),
                                      _buildHeaderCell(AppStrings.name.tr, minWidth: 100, isDark: isDark),
                                      _buildHeaderCell(AppStrings.email.tr, minWidth: 180, isDark: isDark),
                                      _buildHeaderCell(AppStrings.amount.tr, minWidth: 100, isDark: isDark),
                                      _buildHeaderCell(AppStrings.totalUsed.tr,
                                          minWidth: 100, alignCenter: true, isDark: isDark),
                                    ],
                                  ),
                                ),

                                // Table Body
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: giftCards.length,
                                    itemBuilder: (context, index) {
                                      final giftCard = giftCards[index];

                                      return Container(
                                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                        decoration: BoxDecoration(
                                          color: isDark ? Colors.grey.shade800 : Colors.white,
                                          border: index < giftCards.length - 1
                                              ? Border(
                                                  bottom: BorderSide(
                                                    color: isDark ? Colors.grey.shade700 : const Color(0xFFF3F4F6),
                                                    width: 1,
                                                  ),
                                                )
                                              : null,
                                        ),
                                        child: Row(
                                          children: [
                                            _buildCell(
                                              giftCard.sku ?? '',
                                              minWidth: 80,
                                              isDark: isDark,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: isDark ? Colors.white : const Color(0xFF374151),
                                              ),
                                            ),
                                            _buildCell(
                                              giftCard.code ?? '',
                                              minWidth: 140,
                                              isDark: isDark,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: isDark ? Colors.grey.shade400 : const Color(0xFF6B7280),
                                                fontFamily: 'monospace',
                                              ),
                                            ),
                                            _buildCell(
                                              giftCard.recipientName ?? '',
                                              minWidth: 100,
                                              isDark: isDark,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: isDark ? Colors.white : const Color(0xFF374151),
                                              ),
                                            ),
                                            _buildCell(
                                              giftCard.recipientEmail ?? '',
                                              minWidth: 180,
                                              isDark: isDark,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: isDark ? Colors.grey.shade400 : const Color(0xFF6B7280),
                                              ),
                                            ),
                                            _buildCell(
                                              giftCard.price ?? '',
                                              minWidth: 100,
                                              isDark: isDark,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF059669),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: _getUsedBadgeColor(giftCard.totalUsed ?? 0),
                                                    borderRadius: BorderRadius.circular(16),
                                                  ),
                                                  child: Text(
                                                    '${giftCard.totalUsed ?? 0}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Color _getUsedBadgeColor(int used) {
    if (used == 0) return const Color(0xFF6B7280);
    if (used == 1) return const Color(0xFFDC2626);
    return const Color(0xFF7C2D12);
  }

  Widget _buildEmptyState(bool isDark) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.card_giftcard_outlined,
                size: 48,
                color: isDark ? Colors.grey.shade400 : Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.noGiftCardsFound.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey.shade300 : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.createFirstGiftCard.tr,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey.shade400 : Colors.grey[500],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GiftCardScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white, size: 18),
              label: Text(
                AppStrings.createGiftCard.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.peachyPink,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, {required double minWidth, bool alignCenter = false, required bool isDark}) {
    return SizedBox(
      width: minWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF374151),
            fontSize: 13,
            letterSpacing: 0.5,
          ),
          textAlign: alignCenter ? TextAlign.center : TextAlign.left,
        ),
      ),
    );
  }

  Widget _buildCell(
    String text, {
    required double minWidth,
    required bool isDark,
    TextStyle? style,
    bool alignCenter = false,
  }) {
    return SizedBox(
      width: minWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          text,
          style: style ??
              TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : const Color(0xFF374151),
              ),
          textAlign: alignCenter ? TextAlign.center : TextAlign.left,
          overflow: TextOverflow.visible,
          maxLines: null,
        ),
      ),
    );
  }
}
