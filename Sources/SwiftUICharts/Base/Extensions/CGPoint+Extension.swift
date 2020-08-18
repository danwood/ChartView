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

        var min: Double?
        var max: Double?
        if let minPoint = data.min(), let maxPoint = data.max(), minPoint != maxPoint {
            min = minPoint
            max = maxPoint
        } else {
            return .zero
        }
        if let min = min, let max = max, min != max {
            if min <= 0 {
                stepHeight = (frame.size.height - lineWidth) / CGFloat(max + min)	// negative number means include span between neg and pos
            } else {
                stepHeight = (frame.size.height - lineWidth) / CGFloat(max - min)
            }
        }

        return CGPoint(x: stepWidth, y: stepHeight)
    }
}
