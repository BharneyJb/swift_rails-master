import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../config/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../controllers/booking_controller.dart';
import '../../../data/models/seat_model.dart';
import '../../../data/models/coach_model.dart';

// ─── Seat position classification ────────────────────────────────────────────
enum _SeatPosition { windowLeft, aisleLeft, aisleRight, windowRight }

class SeatSelectionView extends GetView<BookingController> {
  const SeatSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Choose Your Seat'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.coachesWithSeats.isEmpty) {
          return _EmptyState(onRetry: controller.fetchSeatsForClass);
        }
        return _SeatSelectionBody(controller: controller);
      }),
    );
  }
}

// ─── Empty state ─────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final VoidCallback onRetry;
  const _EmptyState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_seat_rounded,
              size: 72,
              color: AppColors.textSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text('No seats available',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Try a different travel class',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// ─── Body: coach picker + seat map + bottom bar ───────────────────────────────
class _SeatSelectionBody extends StatefulWidget {
  final BookingController controller;
  const _SeatSelectionBody({required this.controller});

  @override
  State<_SeatSelectionBody> createState() => _SeatSelectionBodyState();
}

class _SeatSelectionBodyState extends State<_SeatSelectionBody> {
  int _selectedCoachIndex = 0;

  @override
  Widget build(BuildContext context) {
    final coaches = widget.controller.coachesWithSeats;

    return Column(
      children: [
        _CoachSelector(
          coaches: coaches,
          selectedIndex: _selectedCoachIndex,
          onSelect: (i) => setState(() => _selectedCoachIndex = i),
        ),
        const SizedBox(height: 4),
        _Legend(),
        const SizedBox(height: 8),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                        begin: const Offset(0.04, 0), end: Offset.zero)
                    .animate(anim),
                child: child,
              ),
            ),
            child: _TrainCoachView(
              key: ValueKey(_selectedCoachIndex),
              coach: coaches[_selectedCoachIndex],
              controller: widget.controller,
            ),
          ),
        ),
        _BottomBar(controller: widget.controller),
      ],
    );
  }
}

// ─── Coach selector cards ─────────────────────────────────────────────────────
class _CoachSelector extends StatelessWidget {
  final List<CoachModel> coaches;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  const _CoachSelector(
      {required this.coaches,
      required this.selectedIndex,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
          child: Text('Select Coach',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: AppColors.textSecondary)),
        ),
        SizedBox(
          height: 88,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: coaches.length,
            itemBuilder: (context, i) {
              final coach = coaches[i];
              final isSelected = i == selectedIndex;
              final available =
                  coach.seats.where((s) => s.status == 'Available').length;
              final total = coach.seats.length;
              final isFull = available == 0;

              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onSelect(i);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  width: 104,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.28)
                            : Colors.black.withValues(alpha: 0.05),
                        blurRadius: isSelected ? 14 : 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.directions_railway_filled_rounded,
                              size: 13,
                              color: isSelected
                                  ? Colors.white60
                                  : AppColors.textSecondary),
                          const SizedBox(width: 3),
                          Text('Coach',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: isSelected
                                      ? Colors.white60
                                      : AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(coach.code,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary)),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isFull
                                  ? (isSelected
                                      ? Colors.redAccent[100]
                                      : AppColors.error)
                                  : (isSelected
                                      ? Colors.greenAccent[200]
                                      : AppColors.success),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text('$available/$total',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white70
                                      : AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── Legend ───────────────────────────────────────────────────────────────────
class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LegendTile(
              color: AppColors.seatAvailable.withValues(alpha: 0.15),
              borderColor: AppColors.seatAvailable,
              label: 'Available'),
          const SizedBox(width: 16),
          const _LegendTile(
              color: AppColors.primary,
              borderColor: AppColors.primary,
              label: 'Selected',
              textColor: Colors.white),
          const SizedBox(width: 16),
          _LegendTile(
              color: const Color(0xFFEEEEEE),
              borderColor: Colors.grey.shade300,
              label: 'Taken'),
          const SizedBox(width: 16),
          Row(
            children: [
              const Icon(Icons.window_rounded,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text('Window',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendTile extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final String label;
  final Color? textColor;
  const _LegendTile(
      {required this.color,
      required this.borderColor,
      required this.label,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor, width: 1.5),
          ),
        ),
        const SizedBox(width: 5),
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}

// ─── Train coach bird's-eye view ──────────────────────────────────────────────
class _TrainCoachView extends StatelessWidget {
  final CoachModel coach;
  final BookingController controller;
  const _TrainCoachView(
      {super.key, required this.coach, required this.controller});

  /// Map seat index within a row to its position type
  _SeatPosition _positionFor(int indexInRow) {
    switch (indexInRow) {
      case 0:
        return _SeatPosition.windowLeft;
      case 1:
        return _SeatPosition.aisleLeft;
      case 2:
        return _SeatPosition.aisleRight;
      case 3:
      default:
        return _SeatPosition.windowRight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final seats = coach.seats;
    final totalRows = (seats.length / 4).ceil();

    // Build nullable rows of 4
    final List<List<SeatModel?>> rows = [];
    for (var i = 0; i < seats.length; i += 4) {
      final end = (i + 4 > seats.length) ? seats.length : i + 4;
      final List<SeatModel?> row = List<SeatModel?>.from(seats.sublist(i, end));
      while (row.length < 4) { row.add(null); }
      rows.add(row);
    }

    // How many window panels to show per side (every ~4 rows)
    const windowEvery = 4;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Left wall + windows ──
            _CoachWall(
              totalRows: totalRows,
              windowEvery: windowEvery,
              side: _WallSide.left,
            ),

            // ── Seat grid ────────────────────────────────────────
            Expanded(
              child: Column(
                children: [
                  // Front cap
                  _CoachEndCap(label: 'FRONT · Coach ${coach.code}', isTop: true),

                  // Column headers
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        // Left pair headers
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _ColHeader(label: 'A', isWindow: true),
                              _ColHeader(label: 'B', isWindow: false),
                            ],
                          ),
                        ),
                        // Aisle gap
                        SizedBox(width: 32),
                        // Right pair headers
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _ColHeader(label: 'C', isWindow: false),
                              _ColHeader(label: 'D', isWindow: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Seat rows
                  ...rows.asMap().entries.map((e) {
                    final rowNum = e.key + 1;
                    final row = e.value;
                    return _SeatRow(
                      rowNumber: rowNum,
                      seats: row,
                      controller: controller,
                      positionOf: _positionFor,
                    );
                  }),

                  // Rear cap
                  const _CoachEndCap(label: 'REAR', isTop: false),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            // ── Right wall + windows ──
            _CoachWall(
              totalRows: totalRows,
              windowEvery: windowEvery,
              side: _WallSide.right,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Coach wall with window cut-outs ─────────────────────────────────────────
enum _WallSide { left, right }

class _CoachWall extends StatelessWidget {
  final int totalRows;
  final int windowEvery;
  final _WallSide side;
  const _CoachWall(
      {required this.totalRows,
      required this.windowEvery,
      required this.side});

  @override
  Widget build(BuildContext context) {
    // Each row is ~46px high; add header + end caps
    const rowH = 46.0;
    const headerH = 62.0; // endcap + col headers
    const footerH = 36.0;

    final totalH = headerH + (totalRows * rowH) + footerH;

    return SizedBox(
      width: 18,
      height: totalH,
      child: CustomPaint(
        painter: _WallPainter(
          totalRows: totalRows,
          windowEvery: windowEvery,
          side: side,
          rowH: rowH,
          headerH: headerH,
        ),
      ),
    );
  }
}

class _WallPainter extends CustomPainter {
  final int totalRows;
  final int windowEvery;
  final _WallSide side;
  final double rowH;
  final double headerH;

  const _WallPainter({
    required this.totalRows,
    required this.windowEvery,
    required this.side,
    required this.rowH,
    required this.headerH,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const wallColor = Color(0xFFCDD3DC);
    const windowFill = Color(0xFFD6EAFF);
    const windowBorder = Color(0xFF90C4F5);

    final wallPaint = Paint()..color = wallColor;
    final windowFillPaint = Paint()..color = windowFill;
    final windowBorderPaint = Paint()
      ..color = windowBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw full wall background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), wallPaint);

    // Draw window cut-outs every `windowEvery` rows
    const windowMargin = 4.0;
    const windowRadius = 3.0;
    final windowW = size.width - windowMargin * 2;

    for (var row = 0; row < totalRows; row++) {
      if ((row % windowEvery) == 1) {
        // Show a window spanning rows `row` to `row+2` (3 rows wide)
        const windowRows = 2.5;
        final top = headerH + row * rowH + 4;
        final windowH = rowH * windowRows - 8;
        final rect = RRect.fromLTRBR(
          windowMargin,
          top,
          windowMargin + windowW,
          top + windowH,
          const Radius.circular(windowRadius),
        );
        canvas.drawRRect(rect, windowFillPaint);
        canvas.drawRRect(rect, windowBorderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_WallPainter old) => false;
}

// ─── Coach end caps (front / rear) ───────────────────────────────────────────
class _CoachEndCap extends StatelessWidget {
  final String label;
  final bool isTop;
  const _CoachEndCap({required this.label, required this.isTop});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isTop
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.border.withValues(alpha: 0.6),
        border: Border(
          bottom: isTop
              ? const BorderSide(color: AppColors.border)
              : BorderSide.none,
          top: !isTop
              ? const BorderSide(color: AppColors.border)
              : BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isTop
                ? Icons.keyboard_double_arrow_up_rounded
                : Icons.keyboard_double_arrow_down_rounded,
            size: 12,
            color: isTop
                ? AppColors.primary.withValues(alpha: 0.7)
                : AppColors.textSecondary,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: isTop
                  ? AppColors.primary.withValues(alpha: 0.8)
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Column header (A / B / C / D) ───────────────────────────────────────────
class _ColHeader extends StatelessWidget {
  final String label;
  final bool isWindow;
  const _ColHeader({required this.label, required this.isWindow});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isWindow)
          const Icon(Icons.window_rounded,
              size: 10, color: AppColors.textSecondary),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// ─── One row of seats ─────────────────────────────────────────────────────────
class _SeatRow extends StatelessWidget {
  final int rowNumber;
  final List<SeatModel?> seats;
  final BookingController controller;
  final _SeatPosition Function(int) positionOf;

  const _SeatRow({
    required this.rowNumber,
    required this.seats,
    required this.controller,
    required this.positionOf,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left pair: A (window) + B (aisle)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SeatWidget(
                  seat: seats.isNotEmpty ? seats[0] : null,
                  controller: controller,
                  position: _SeatPosition.windowLeft,
                  rowNumber: rowNumber,
                ),
                _SeatWidget(
                  seat: seats.length > 1 ? seats[1] : null,
                  controller: controller,
                  position: _SeatPosition.aisleLeft,
                  rowNumber: rowNumber,
                ),
              ],
            ),
          ),

          // Aisle
          SizedBox(
            width: 32,
            child: Center(
              child: Text(
                '$rowNumber',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Right pair: C (aisle) + D (window)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SeatWidget(
                  seat: seats.length > 2 ? seats[2] : null,
                  controller: controller,
                  position: _SeatPosition.aisleRight,
                  rowNumber: rowNumber,
                ),
                _SeatWidget(
                  seat: seats.length > 3 ? seats[3] : null,
                  controller: controller,
                  position: _SeatPosition.windowRight,
                  rowNumber: rowNumber,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Individual seat widget ───────────────────────────────────────────────────
class _SeatWidget extends StatelessWidget {
  final SeatModel? seat;
  final BookingController controller;
  final _SeatPosition position;
  final int rowNumber;

  const _SeatWidget({
    required this.seat,
    required this.controller,
    required this.position,
    required this.rowNumber,
  });

  bool get _isWindow =>
      position == _SeatPosition.windowLeft ||
      position == _SeatPosition.windowRight;

  @override
  Widget build(BuildContext context) {
    if (seat == null) return const SizedBox(width: 38, height: 38);

    return Obx(() {
      final isSelected = controller.selectedSeat.value?.id == seat!.id;
      final isAvailable = seat!.status == 'Available';

      // Colors
      final Color bgColor = !isAvailable
          ? const Color(0xFFE0E0E0)
          : isSelected
              ? AppColors.primary
              : AppColors.seatAvailable.withValues(alpha: 0.15);

      final Color borderColor = !isAvailable
          ? Colors.grey.shade300
          : isSelected
              ? AppColors.primary
              : AppColors.seatAvailable;

      final Color textColor = !isAvailable
          ? AppColors.textTertiary
          : isSelected
              ? Colors.white
              : AppColors.seatAvailable;

      return GestureDetector(
        onTap: isAvailable
            ? () {
                HapticFeedback.lightImpact();
                controller.selectSeat(seat!);
              }
            : null,
        child: AnimatedScale(
          scale: isSelected ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutBack,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Seat body
              Container(
                width: 38,
                height: 34,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: borderColor, width: 1.5),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          )
                        ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Headrest bump
                    Container(
                      width: 26,
                      height: 7,
                      decoration: BoxDecoration(
                        color: !isAvailable
                            ? Colors.grey.shade300
                            : isSelected
                                ? AppColors.primaryLight
                                : AppColors.seatAvailable
                                    .withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Seat number label
                    Text(
                      seat!.code.length > 4
                          ? seat!.code.substring(seat!.code.length - 2)
                          : seat!.code,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Window indicator dot on the outer edge
              if (_isWindow && isAvailable && !isSelected)
                Positioned(
                  top: -3,
                  left: position == _SeatPosition.windowLeft ? -3 : null,
                  right: position == _SeatPosition.windowRight ? -3 : null,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFF90C4F5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}

// ─── Bottom bar ───────────────────────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  final BookingController controller;
  const _BottomBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Obx(() {
                  final seat = controller.selectedSeat.value;
                  final coach = seat != null
                      ? controller.coachesWithSeats
                          .firstWhereOrNull((c) => c.id == seat.coachId)
                      : null;

                  if (seat == null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('No seat selected',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: AppColors.textSecondary)),
                        Text('Tap any green seat to select',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.textTertiary)),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(seat.code,
                                style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13)),
                          ),
                          if (coach != null) ...[
                            const SizedBox(width: 8),
                            Text('Coach ${coach.code}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: AppColors.textSecondary)),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '₦${controller.totalPrice.toStringAsFixed(0)}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  );
                }),
              ),
              Obx(() => ElevatedButton(
                    onPressed: controller.selectedSeat.value == null
                        ? null
                        : () => Get.toNamed(AppRoutes.PASSENGER_DETAILS),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Continue'),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
