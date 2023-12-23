import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Speedometer extends StatelessWidget {
  const Speedometer({
    Key? key,
    required this.gaugeBegin,
    required this.gaugeEnd,
    required this.velocityInMPS,
    required this.velocityInKmPH,
    required this.maxVelocity,
    required this.address,
  }) : super(key: key);

  final double gaugeBegin;
  final double gaugeEnd;
  final double? velocityInMPS;
  final double? velocityInKmPH;
  final double? maxVelocity;
  final String? address;

  @override
  Widget build(BuildContext context) {
    const TextStyle annotationTextStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SfRadialGauge(
            axes: [
              RadialAxis(
                minimum: gaugeBegin,
                maximum: gaugeEnd,
                labelOffset: 30,
                axisLineStyle: const AxisLineStyle(
                  thicknessUnit: GaugeSizeUnit.factor,
                  thickness: 0.03,
                ),
                majorTickStyle: const MajorTickStyle(
                  length: 6,
                  thickness: 4,
                  color: Colors.white,
                ),
                minorTickStyle: const MinorTickStyle(
                  length: 3,
                  thickness: 3,
                  color: Colors.white,
                ),
                axisLabelStyle: const GaugeTextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                ranges: [
                  GaugeRange(
                    startValue: gaugeBegin,
                    endValue: gaugeEnd,
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.03,
                    endWidth: 0.03,
                    gradient: const SweepGradient(
                      colors: [Colors.green, Colors.yellow, Colors.red],
                      stops: [0.0, 0.5, 1],
                    ),
                  ),
                ],
                pointers: [
                  NeedlePointer(
                    value: velocityInKmPH!,
                    needleLength: 0.95,
                    enableAnimation: true,
                    animationType: AnimationType.ease,
                    needleStartWidth: 1.5,
                    needleEndWidth: 6,
                    needleColor: Colors.red,
                    knobStyle: const KnobStyle(knobRadius: 0.09),
                  ),
                ],
                annotations: [
                  GaugeAnnotation(
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          velocityInKmPH!.toStringAsFixed(2),
                          style: annotationTextStyle.copyWith(fontSize: 25),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'км/ч',
                          style: annotationTextStyle,
                        ),
                      ],
                    ),
                    angle: 90,
                    positionFactor: 0.75,
                  )
                ],
              ),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  Text(
                    '$address',
                    style: annotationTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(
                height: 28,
              ),
              Row(
                children: [
                  Text(
                    '${velocityInMPS!.toStringAsFixed(2)} м/с',
                    style: annotationTextStyle.copyWith(fontSize: 26),
                  ),
                  const SizedBox(
                    width: 38,
                  ),
                  Text(
                    'Макс. ${maxVelocity!.toStringAsFixed(2)} км/ч',
                    style: annotationTextStyle.copyWith(fontSize: 26),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
