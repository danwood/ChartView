import SwiftUI

extension CGPoint {
	static func getStep(frame: CGRect, lineWidth: CGFloat, data: [Double], limits: ChartLimits ) -> CGPoint {

		// Linewidth is subtracted from frame height so thick lines don't get clipped. Drawing needs to also take lineWidth into account.

		var stepWidth: CGFloat = 0.0
		if data.count < 2 {
			stepWidth = 0.0
		}
		stepWidth = frame.size.width / CGFloat(data.count - 1)

		// stepHeight
		var stepHeight: CGFloat = 0.0

		var min: Double = 0.0
		var max: Double = 0.0

		if case .explicit(let value) = limits.max {
			max = value
		}
		else {
			max = data.max() ?? 0.0	// get the data's max, but then we'll probably adjust below
			switch(limits.max) {
				case .powerOfTen:
					// bump up to 10, 100, 1000 etc.
					let numPlaces = ceil(log10(max))	// round up the log10
					max = __exp10(numPlaces)
					print("powerOfTen \(max)")
				case .halfPowerOfTen:
					// bump up to 5, 10, 50, 100, 500, 1000
					let theLog10 = log10(max)
					let fiveLog10 = log10(5.0)
					let theFloor = floor(theLog10)
					let fractionalLog10 = theLog10 - theFloor
					if fractionalLog10 >= fiveLog10 {
						max = __exp10(theFloor + 1)	// max is 10, 100, 1000 etc.
						print("halfPowerOfTen startingWithTen \(max)")
					}
					else {
						max = __exp10(theFloor + fiveLog10)	// max 5, 50, 500, 5000 etc.
						print("halfPowerOfTen startingWithFive \(max)")
					}
				case .firstSignificant:

					print("firstSignificant starting max = \(max)")
																	// 98  ; 1000 ; 5678
					var numPlaces = 1 + floor(log10(max))			// 2   ; 4    ; 4
					print("numPlaces = \(numPlaces)")
					let normalized = max / __exp10(numPlaces - 1) 	// 9.8 ; 1.000; 5.678
					print("normalized = \(normalized)")
					let normalizedRoundedUp = ceil(normalized)		// 10.0; 1.0; 6.0
					print("normalizedRoundedUp = \(normalizedRoundedUp)")
					// Problem: 9.x gets rounded up to 10, which we won't want, so reduce multiplier by factor of 10
					if normalizedRoundedUp > 9 { numPlaces -= 1 }	// 10  ; 1000 ; 1000
					print("numPlaces = \(numPlaces)")
					let multiplier = __exp10(numPlaces)				// 100 ; 1000 ; 1000
					print("multiplier = \(multiplier)")
					max = normalizedRoundedUp * multiplier			// 100 ; 1000 ; 6000
					print("firstSignificant max = \(max)")

				case .secondSignificant:

					print("secondSignificant starting max = \(max)")
																	// 98  ; 1000 ; 5678
					var numPlaces = 1 + floor(log10(max))			// 2   ; 4    ; 4
					print("numPlaces = \(numPlaces)")
					let normalized = max / __exp10(numPlaces - 2) 	// 98 ; 10.00; 56.78
					print("normalized = \(normalized)")
					let normalizedRoundedUp = ceil(normalized)		// 98 ; 10   ; 57
					print("normalizedRoundedUp = \(normalizedRoundedUp)")
					// Problem: 9.x gets rounded up to 10, which we won't want, so reduce multiplier by factor of 10
					if normalizedRoundedUp > 9 { numPlaces -= 1 }
					print("numPlaces = \(numPlaces)")
					let multiplier = __exp10(numPlaces-1)			// 1   ; 100  ; 100
					print("multiplier = \(multiplier)")
					max = normalizedRoundedUp * multiplier			// 980 ; 1000 ; 5700
					print("secondSignificant max = \(max)")

					break;

				case .fromData:
					break;

				case .explicit(_):
					break;
					// already handled
			}
		}

		min = data.min() ?? 0.0

		if min != max {
			if min <= 0 {
				stepHeight = (frame.size.height - lineWidth) / CGFloat(max + min)	// negative number means include span between neg and pos
			} else {
				stepHeight = (frame.size.height - lineWidth) / CGFloat(max - min)
			}
			return CGPoint(x: stepWidth, y: stepHeight)
		}
		else {
			return .zero
		}
	}
}

