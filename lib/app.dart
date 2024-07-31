import 'package:cat_app/cat_service.dart';
import 'package:cat_app/data.dart';
import 'package:cat_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: FutureBuilder(
          future: CatService.getData(),
          builder: (BuildContext context, AsyncSnapshot<Data?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              return Column(
                children: [
                  SizedBox(
                    height: height * 0.63,
                    child: CatGridView(cats: snapshot.data?.cats),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RangeDataLabelExample(
                        tiers: snapshot.data?.tiers,
                        currentTier: snapshot.data?.currentTier,
                        tierPoints: snapshot.data?.tierPoints,
                      ),
                    ),
                  )
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class CatGridView extends StatelessWidget {
  final List<Cat>? cats;
  const CatGridView({super.key, required this.cats});

  @override
  Widget build(BuildContext context) {
    if (cats == null || cats!.isEmpty) {
      return const Text("No cats");
    }
    return MasonryGridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 3,
      crossAxisSpacing: 3,
      itemCount: cats!.length,
      itemBuilder: (context, index) {
        final cat = cats![index];
        return InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(content: Text("This is ${cat.id}"));
              },
            );
          },
          child: Image.network(cat.url!),
        );
      },
    );
  }
}

class RangeDataLabelExample extends StatelessWidget {
  final List<Tier>? tiers;
  final String? currentTier;
  final int? tierPoints;
  const RangeDataLabelExample({
    super.key,
    required this.tiers,
    required this.currentTier,
    required this.tierPoints,
  });

  @override
  Widget build(BuildContext context) {
    if (tiers == null || tiers!.isEmpty) {
      return const Text("No Value");
    }
    double normalizePoints(int tierPoints, int minPoints, int maxPoints) {
      return (tierPoints - minPoints) / (maxPoints - minPoints) * 100;
    }

    int getPointsToNextTier(int? currentPoints) {
      for (int i = 0; i < tiers!.length; i++) {
        if (currentPoints! < tiers![i].maxPoint!) {
          return tiers![i].maxPoint! - currentPoints + 1;
        }
      }
      return 0;
    }

    List<MarkerPointer> markerPoinsts = [];
    List<GaugeRange> gaugeRanges = [];
    final minPoints = tiers!.first.minPoint;
    final maxPoints = tiers!.last.maxPoint;
    var normalizedPoints = normalizePoints(tierPoints!, minPoints!, maxPoints!);
    final int numberOfTiers = tiers!.length;

    for (int i = 0; i < numberOfTiers; i++) {
      final tier = tiers![i];
      final st = normalizePoints(tier.minPoint!, minPoints, maxPoints);
      final end = normalizePoints(tier.maxPoint!, minPoints, maxPoints);

      gaugeRanges.add(
        GaugeRange(
          startValue: st * 1000,
          endValue: end * 1000,
          color: HexColor(tier.bgColor!),
          label: "${tier.tierName}".toUpperCase(),
          sizeUnit: GaugeSizeUnit.factor,
          startWidth: 0.3,
          endWidth: 0.3,
        ),
      );

      markerPoinsts.add(
        MarkerPointer(
          markerType: MarkerType.text,
          color: Colors.red,
          text: "${tier.minPoint} to \n ${tier.maxPoint}",
          textStyle: const GaugeTextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          value: (st * 1000) + 3,
          offsetUnit: GaugeSizeUnit.factor,
          markerOffset: -0.32,
        ),
      );
    }

    return SfRadialGauge(
      enableLoadingAnimation: true,
      //  title: GaugeTitle(text: "Tiers"),
      axes: <RadialAxis>[
        RadialAxis(
          startAngle: 270,
          endAngle: 270,
          maximum: 100,
          ranges: gaugeRanges,
          annotations: [
            GaugeAnnotation(
              // angle: 175,
              positionFactor: 0,
              widget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$currentTier\n ".toUpperCase(),
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "tire level".toUpperCase(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "${getPointsToNextTier(tierPoints)}".replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]},'),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'tier credits\n to next tire'.toUpperCase(),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
          pointers: <GaugePointer>[
            MarkerPointer(
                value: normalizedPoints * 1000,
                elevation: 10,
                markerWidth: 25,
                markerHeight: 25,
                color: const Color(0xFFF67280),
                markerType: MarkerType.invertedTriangle,
                markerOffset: -7),
            ...markerPoinsts
          ],
        ),
        // RadialAxis(
        //   showAxisLine: false,
        //   showLabels: false,
        //   showTicks: false,
        //   startAngle: 270,
        //   endAngle: 270,
        //   maximum: 100,
        //   radiusFactor: 0.85,
        //   canScaleToFit: true,
        //   pointers: markerPoinsts,
        // ),
      ],
    );
  }

  /// Returns the range data label gauge
}
