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

		switch(limits.max) {
			case .explicit(let value):
				max = value
			default:
				max = data.max() ?? 0.0
		}
		if limits.max == .zeroEnding {
			// bump up to 10, 100, 1000 etc.
			let numPlaces = ceil(log10(max))	// round up the log10
			max = __exp10(numPlaces)
			print("00 -> \(max)")
		}
		else if limits.max == .zeroOrFiveEnding {
			// bump up to 5, 10, 50, 100, 500, 1000
			let theLog10 = log10(max)
			let fiveLog10 = log10(5.0)
			let theFloor = floor(theLog10)
			let fractionalLog10 = theLog10 - theFloor
			if fractionalLog10 >= fiveLog10 {
				max = __exp10(theFloor + 1)	// max is 10, 100, 1000 etc.
				print("0/ -> \(max)")
			}
			else {
				max = __exp10(theFloor + fiveLog10)	// max 5, 50, 500, 5000 etc.
				print("5/ -> \(max)")
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

