import SwiftUI

extension CGPoint {
	
	/// Calculate X and Y delta for each data point, based on data min/max and enclosing frame.
	/// - Parameters:
	///   - frame: Rectangle of enclosing frame
	///   - lineWidth: subtracted from frame height so thick lines don't get clipped. Drawing needs to also take lineWidth into account.
	///   - data: array of `Double`
	///   - yRange: Min & max data values
	/// - Returns: X and Y delta as a `CGPoint`
	static func getStep(frame: CGRect, lineWidth: CGFloat, data: [Double], yRange: Range<Double> ) -> CGPoint {

        var stepWidth: CGFloat = 0.0
        if data.count < 2 {
            stepWidth = 0.0
        }
        stepWidth = frame.size.width / CGFloat(data.count - 1)

        // stepHeight
        var stepHeight: CGFloat = 0.0



		print("RANGE: \(yRange.lowerBound) - \(yRange.upperBound)")


		if yRange.lowerBound != yRange.upperBound {
			if yRange.lowerBound <= 0 {
				stepHeight = (frame.size.height - lineWidth) / CGFloat(yRange.upperBound + abs(yRange.lowerBound))	// negative number means include span between neg and pos
				print("negative minimum. stepHeight = \(stepHeight)")
			} else {
				stepHeight = (frame.size.height - lineWidth) / CGFloat(yRange.upperBound - yRange.lowerBound)
				print("positive minimum. stepHeight = \(stepHeight)")
        }
        return CGPoint(x: stepWidth, y: stepHeight)
    }
		else {

			// This isn't really right, what if you have a really flat graph
			return .zero
		}
	}
}

