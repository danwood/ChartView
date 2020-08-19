import SwiftUI

public struct Line: View {
    @EnvironmentObject var chartValue: ChartValue
    @State var frame: CGRect = .zero
    @ObservedObject var chartData: ChartData

    var style: ChartStyle

    @State var showIndicator: Bool = false
    @State var touchLocation: CGPoint = .zero
    @State private var showFull: Bool = false

	// Calculate yRange we're using based on data and style preference
	var yRange: Range<Double> {

		var minimumValue: Double = 0.0
		var maximumValue: Double = 0.0

		if case .explicit(let range) = style.limits.yLimit {
			minimumValue = range.lowerBound
			maximumValue = range.upperBound
		}
		else {
			maximumValue = chartData.data.max() ?? 0.0	// get the data's max, but then we'll probably adjust below

			if style.limits.symmetrical {
				// If we want symmetrical above and below Y axis, we have to take absolute value of negative values into account
				let minMagnitude = abs(chartData.data.min() ?? 0.0)
				maximumValue = max(maximumValue, minMagnitude)
			}

			// Now adjust maximum from data to round up to a nice value

			switch(style.limits.yLimit) {
				case .powerOfTen:
					// bump up to 10, 100, 1000 etc.
					let numPlaces = ceil(log10(maximumValue))	// round up the log10
					maximumValue = __exp10(numPlaces)
					print("powerOfTen \(maximumValue)")
				case .halfPowerOfTen:
					// bump up to 5, 10, 50, 100, 500, 1000
					let theLog10 = log10(maximumValue)
					let fiveLog10 = log10(5.0)
					let theFloor = floor(theLog10)
					let fractionalLog10 = theLog10 - theFloor
					if fractionalLog10 >= fiveLog10 {
						maximumValue = __exp10(theFloor + 1)	// max is 10, 100, 1000 etc.
						print("halfPowerOfTen startingWithTen \(maximumValue)")
					}
					else {
						maximumValue = __exp10(theFloor + fiveLog10)	// max 5, 50, 500, 5000 etc.
						print("halfPowerOfTen startingWithFive \(maximumValue)")
					}
				case .firstSignificant:

					print("firstSignificant starting max = \(maximumValue)")
					// 98  ; 1000 ; 5678
					var numPlaces = 1 + floor(log10(maximumValue))			// 2   ; 4    ; 4
					print("numPlaces = \(numPlaces)")
					let normalized = maximumValue / __exp10(numPlaces - 1) 	// 9.8 ; 1.000; 5.678
					print("normalized = \(normalized)")
					let normalizedRoundedUp = ceil(normalized)		// 10.0; 1.0; 6.0
					print("normalizedRoundedUp = \(normalizedRoundedUp)")
					// Problem: 9.x gets rounded up to 10, which we won't want, so reduce multiplier by factor of 10
					if normalizedRoundedUp > 9 { numPlaces -= 1 }	// 10  ; 1000 ; 1000
					print("numPlaces = \(numPlaces)")
					let multiplier = __exp10(numPlaces)				// 100 ; 1000 ; 1000
					print("multiplier = \(multiplier)")
					maximumValue = normalizedRoundedUp * multiplier			// 100 ; 1000 ; 6000
					print("firstSignificant max = \(maximumValue)")

				case .secondSignificant:

					print("secondSignificant starting max = \(maximumValue)")
					// 98  ; 1000 ; 5678
					var numPlaces = 1 + floor(log10(maximumValue))			// 2   ; 4    ; 4
					print("numPlaces = \(numPlaces)")
					let normalized = maximumValue / __exp10(numPlaces - 2) 	// 98 ; 10.00; 56.78
					print("normalized = \(normalized)")
					let normalizedRoundedUp = ceil(normalized)		// 98 ; 10   ; 57
					print("normalizedRoundedUp = \(normalizedRoundedUp)")
					// Problem: 9.x gets rounded up to 10, which we won't want, so reduce multiplier by factor of 10
					if normalizedRoundedUp > 9 { numPlaces -= 1 }
					print("numPlaces = \(numPlaces)")
					let multiplier = __exp10(numPlaces-1)			// 1   ; 100  ; 100
					print("multiplier = \(multiplier)")
					maximumValue = normalizedRoundedUp * multiplier			// 980 ; 1000 ; 5700
					print("secondSignificant max = \(maximumValue)")

					break;

				case .fromData:
					break;

				case .explicit(_):
					break;
				// already handled
			}
		}

		if style.limits.symmetrical {
			minimumValue = -maximumValue	// same below the axis as above
		}
		else {
			// Not symmetrical - now we get a chance to look at any minimum specified

			minimumValue = chartData.data.min() ?? 0.0


			// TODO


		}

		print("RANGE: \(minimumValue) - \(maximumValue)")
		return minimumValue ..< maximumValue
	}

	var step: CGPoint {
		return CGPoint.getStep(frame: frame, lineWidth: style.lineWidth, data: chartData.data, yRange:yRange)
    }

    var path: Path {
        let points = chartData.data

		if style.curvedLines {
            return Path.quadCurvedPathWithPoints(points: points,
                                                 step: step,
												 yOffset: style.lineWidth/2)
        }

		return Path.linePathWithPoints(points: points, step: step,
									   yOffset: style.lineWidth/2)
    }
    
    var closedPath: Path {
        let points = chartData.data

		if style.curvedLines {
            return Path.quadClosedCurvedPathWithPoints(points: points,
                                            step: step,
											yOffset: style.lineWidth/2)
        }

		return Path.closedLinePathWithPoints(points: points, step: step,
											 yOffset: style.lineWidth/2)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
				if self.showFull && self.style.showBackground {
                    self.getBackgroundPathView()
                }
                self.getLinePathView()
                if self.showIndicator {
                    IndicatorPoint()
                        .position(self.getClosestPointOnPath(touchLocation: self.touchLocation))
                        .rotationEffect(.degrees(180), anchor: .center)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                }
            }
            .onAppear {
                self.frame = geometry.frame(in: .local)
            }
            .gesture(DragGesture()
                .onChanged({ value in
                    self.touchLocation = value.location
                    self.showIndicator = true
                    self.getClosestDataPoint(point: self.getClosestPointOnPath(touchLocation: value.location))
                    self.chartValue.interactionInProgress = true
                })
                .onEnded({ value in
                    self.touchLocation = .zero
                    self.showIndicator = false
                    self.chartValue.interactionInProgress = false
                })
            )
        }
    }
}

// MARK: - Private functions

extension Line {
    private func getClosestPointOnPath(touchLocation: CGPoint) -> CGPoint {
        let closest = self.path.point(to: touchLocation.x)
        return closest
    }

    private func getClosestDataPoint(point: CGPoint) {
        let index = Int(round((point.x)/step.x))
        if (index >= 0 && index < self.chartData.data.count){
            self.chartValue.currentValue = self.chartData.data[index]
        }
    }

    private func getBackgroundPathView() -> some View {
        self.closedPath
            .fill(LinearGradient(gradient: Gradient(colors: [
                                                        style.foregroundColor.first?.startColor ?? .white,
                                                        style.foregroundColor.first?.endColor ?? .white,
                                                        .clear]),
                                 startPoint: .bottom,
                                 endPoint: .top))
            .rotationEffect(.degrees(180), anchor: .center)
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            .opacity(0.2)
            .transition(.opacity)
            .animation(.easeIn(duration: 1.6))
    }

    private func getLinePathView() -> some View {
        self.path
            .trim(from: 0, to: self.showFull ? 1:0)
            .stroke(LinearGradient(gradient: style.foregroundColor.first?.gradient ?? ColorGradient.orangeBright.gradient,
                                   startPoint: .leading,
                                   endPoint: .trailing),
					style: StrokeStyle(lineWidth: style.lineWidth, lineJoin: .round))
            .rotationEffect(.degrees(180), anchor: .center)
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            .animation(Animation.easeOut(duration: 1.2))
            .onAppear {
                self.showFull = true
            }
            .onDisappear {
                self.showFull = false
            }
            .drawingGroup()
    }
}

struct Line_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Line(chartData:  ChartData([8, 23, 32, 7, 23, 43]), style: blackLineStyle)
            Line(chartData:  ChartData([8, 23, 32, 7, 23, 43]), style: redLineStyle)
        }
    }
}

private let blackLineStyle = ChartStyle(backgroundColor: ColorGradient(.white), foregroundColor: ColorGradient(.black))
private let redLineStyle = ChartStyle(backgroundColor: .whiteBlack, foregroundColor: ColorGradient(.red))
