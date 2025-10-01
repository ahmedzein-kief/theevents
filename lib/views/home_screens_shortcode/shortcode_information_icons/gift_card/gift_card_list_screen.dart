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
  // Add ScrollController for synchronized scrolling
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
    return BaseAppBar(
      textBack: AppStrings.back.tr,
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      firstRightIconPath: AppStrings.firstRightIconPath.tr,
      secondRightIconPath: AppStrings.secondRightIconPath.tr,
      thirdRightIconPath: AppStrings.thirdRightIconPath.tr,
      body: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Consumer<GiftCardListProvider>(
            builder: (context, giftCardProvider, _) {
              if (giftCardProvider.loading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2.0,
                  ),
                );
              }
              if (giftCardProvider.error != null && giftCardProvider.error != 'No record found!') {
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
                        child: const Text('Retry'),
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
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Gift Cards',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
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
                          label: const Text(
                            'Create',
                            style: TextStyle(
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
                    _buildEmptyState()
                  else
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha((0.04 * 255).toInt()),
                              spreadRadius: 0,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 1,
                          ),
                        ),
                        child: SingleChildScrollView(
                          controller: _horizontalScrollController, // Single controller for horizontal scrolling
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width:
                                MediaQuery.of(context).size.width < 800 ? 800 : MediaQuery.of(context).size.width - 48,
                            child: Column(
                              children: [
                                // Table Header
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF9FAFB),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xFFE5E7EB),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      _buildHeaderCell('SKU', minWidth: 80),
                                      _buildHeaderCell('Code', minWidth: 140),
                                      _buildHeaderCell('Name', minWidth: 100),
                                      _buildHeaderCell('Email', minWidth: 180),
                                      _buildHeaderCell('Amount', minWidth: 100),
                                      _buildHeaderCell('Total Used', minWidth: 100, alignCenter: true),
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
                                          color: Colors.white,
                                          border: index < giftCards.length - 1
                                              ? const Border(
                                                  bottom: BorderSide(
                                                    color: Color(0xFFF3F4F6),
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
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF374151),
                                              ),
                                            ),
                                            _buildCell(
                                              giftCard.code ?? '',
                                              minWidth: 140,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF6B7280),
                                                fontFamily: 'monospace',
                                              ),
                                            ),
                                            _buildCell(
                                              giftCard.recipientName ?? '',
                                              minWidth: 100,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF374151),
                                              ),
                                            ),
                                            _buildCell(
                                              giftCard.recipientEmail ?? '',
                                              minWidth: 180,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF6B7280),
                                              ),
                                            ),
                                            _buildCell(
                                              giftCard.price ?? '',
                                              minWidth: 100,
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

  // Helper method to get badge color based on usage
  Color _getUsedBadgeColor(int used) {
    if (used == 0) return const Color(0xFF6B7280);
    if (used == 1) return const Color(0xFFDC2626);
    return const Color(0xFF7C2D12);
  }

  // Empty state widget
  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.card_giftcard_outlined,
                size: 48,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No gift cards found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first gift card to get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
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
              label: const Text(
                'Create Gift Card',
                style: TextStyle(
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

  // Header cell builder
  Widget _buildHeaderCell(String text, {required double minWidth, bool alignCenter = false}) {
    return SizedBox(
      width: minWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF374151),
            fontSize: 13,
            letterSpacing: 0.5,
          ),
          textAlign: alignCenter ? TextAlign.center : TextAlign.left,
        ),
      ),
    );
  }

  // Data cell builder
  Widget _buildCell(
    String text, {
    required double minWidth,
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
              const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
              ),
          textAlign: alignCenter ? TextAlign.center : TextAlign.left,
          overflow: TextOverflow.visible,
          maxLines: null,
        ),
      ),
    );
  }
}
