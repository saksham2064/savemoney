import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../firebase/firebase_service.dart';
import '../../models/transaction_model.dart';

enum FilterType { all, income, expense, loan }

class StatScreen extends StatefulWidget {
  const StatScreen({super.key});

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  final FirebaseService firebaseService = FirebaseService();

  FilterType _filter = FilterType.all;
  bool _showPieChart = true;

  DateTimeRange? _dateRange;

  List<TransactionModel> allTransactions = [];

  @override
  void initState() {
    super.initState();
    // Initially no date filter - show all
  }

  List<TransactionModel> get filteredTransactions {
    var filtered = allTransactions;

    // Filter by type
    if (_filter != FilterType.all) {
      filtered = filtered.where((t) {
        switch (_filter) {
          case FilterType.income:
            return t.type == 'income';
          case FilterType.expense:
            return t.type == 'expense';
          case FilterType.loan:
            return t.type == 'loan';
          default:
            return true;
        }
      }).toList();
    }

    // Filter by date range
    if (_dateRange != null) {
      filtered = filtered.where((t) {
        return t.date.isAfter(_dateRange!.start.subtract(const Duration(days: 1))) &&
            t.date.isBefore(_dateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    return filtered;
  }

  double getTotalByType(String type) {
    return filteredTransactions
        .where((t) => t.type == type)
        .fold(0, (sum, t) => sum + t.amount);
  }

  Map<String, double> getDataMap() {
    return {
      'Income': getTotalByType('income'),
      'Expense': getTotalByType('expense'),
      'Loan': getTotalByType('loan'),
    };
  }

  Future<void> pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      initialDateRange: _dateRange ?? DateTimeRange(start: now.subtract(const Duration(days: 30)), end: now),
    );

    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<List<TransactionModel>>(
          stream: firebaseService.getTransactionsStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              allTransactions = snapshot.data!;

              final totals = getDataMap();

              double totalAll = totals.values.fold(0, (a, b) => a + b);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statistics',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Filter buttons
                  Wrap(
                    spacing: 12,
                    children: [
                      ChoiceChip(
                        label: const Text('All'),
                        selected: _filter == FilterType.all,
                        onSelected: (_) => setState(() => _filter = FilterType.all),
                      ),
                      ChoiceChip(
                        label: const Text('Income'),
                        selected: _filter == FilterType.income,
                        onSelected: (_) => setState(() => _filter = FilterType.income),
                      ),
                      ChoiceChip(
                        label: const Text('Expense'),
                        selected: _filter == FilterType.expense,
                        onSelected: (_) => setState(() => _filter = FilterType.expense),
                      ),
                      ChoiceChip(
                        label: const Text('Loan'),
                        selected: _filter == FilterType.loan,
                        onSelected: (_) => setState(() => _filter = FilterType.loan),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Date range picker button
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.date_range),
                        label: Text(_dateRange == null
                            ? 'Select Date Range'
                            : '${_dateRange!.start.toLocal().toString().split(' ')[0]} - ${_dateRange!.end.toLocal().toString().split(' ')[0]}'),
                        onPressed: pickDateRange,
                      ),
                      if (_dateRange != null)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _dateRange = null;
                            });
                          },
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Toggle chart type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('Pie Chart'),
                      Switch(
                        value: _showPieChart,
                        onChanged: (val) => setState(() => _showPieChart = val),
                      ),
                      const Text('Bar Chart'),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Chart container
                  Container(
                    width: double.infinity,
                    height: 280,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.grey.withOpacity(0.2),
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: _showPieChart
                        ? PieChartWidget(dataMap: totals)
                        : BarChartWidget(dataMap: totals),
                  ),

                  const SizedBox(height: 24),

                  // Summary below charts
                  Expanded(
                    child: filteredTransactions.isEmpty
                        ? Center(
                            child: Text(
                              'No transactions found for the selected filters.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        : ListView(
                            children: [
                              Text(
                                'Summary',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),

                              ...totals.entries.map((entry) {
                                return Card(
                                  color: entry.key == 'Income'
                                      ? Colors.green.shade100
                                      : entry.key == 'Expense'
                                          ? Colors.red.shade100
                                          : Colors.blue.shade100,
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  child: ListTile(
                                    title: Text(entry.key),
                                    trailing: Text(
                                      '\$${entry.value.toStringAsFixed(2)}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                  ),
                ],
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

// Pie Chart Widget
class PieChartWidget extends StatelessWidget {
  final Map<String, double> dataMap;

  const PieChartWidget({super.key, required this.dataMap});

  @override
  Widget build(BuildContext context) {
    final colors = [Colors.green, Colors.red, Colors.blue];

    final sections = dataMap.entries
        .mapIndexed((index, entry) {
          if (entry.value <= 0) return null; // Skip zero values
          return PieChartSectionData(
            color: colors[index],
            value: entry.value,
            title: '${entry.key}\n\$${entry.value.toStringAsFixed(0)}',
            radius: 90,
            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            titlePositionPercentageOffset: 0.6,
          );
        })
        .whereType<PieChartSectionData>()
        .toList();

    if (sections.isEmpty) {
      return const Center(child: Text('No data to display.'));
    }

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        sectionsSpace: 4,
        borderData: FlBorderData(show: false),
        pieTouchData: PieTouchData(
          enabled: true,
        ),
      ),
    );
  }
}

// Bar Chart Widget
class BarChartWidget extends StatelessWidget {
  final Map<String, double> dataMap;

  const BarChartWidget({super.key, required this.dataMap});

  BarChartGroupData makeGroupData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 30,
          borderRadius: BorderRadius.circular(6),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: dataMap.values.reduce(max),
            color: Colors.grey.shade300,
          ),
        ),
      ],
      showingTooltipIndicators: [0],
    );
  }

  @override
  Widget build(BuildContext context) {
    final keys = dataMap.keys.toList();
    final colors = [Colors.green, Colors.red, Colors.blue];

    return BarChart(
      BarChartData(
        maxY: dataMap.values.reduce(max) * 1.1,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final label = keys[group.x.toInt()];
              final value = rod.toY;
              return BarTooltipItem(
                '$label\n\$${value.toStringAsFixed(2)}',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= keys.length) return const SizedBox.shrink();
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    keys[index],
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: dataMap.values.reduce(max) / 5),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true, drawHorizontalLine: true),
        barGroups: List.generate(
          dataMap.length,
          (index) => makeGroupData(index, dataMap[keys[index]] ?? 0, colors[index]),
        ),
      ),
    );
  }
}

// Helper extension to support mapIndexed
extension IterableExtensions<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E element) f) sync* {
    int index = 0;
    for (final element in this) {
      yield f(index++, element);
    }
  }
}
