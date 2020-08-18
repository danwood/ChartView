import SwiftUI

public enum ChartLimit : Hashable, CaseIterable {

	case fromData			// use actual max/min value for chart, not rounded up to a nice figure
	case powerOfTen			// round up to nearest power of 10, e.g. 245 rounded up to 1000
	case halfPowerOfTen		// round up as .powerOfTen or half of that, so 245 rounded up to 500
	case firstSignificant	// round up first significant figure, e.g. 2453 rounded up to 3000
	case secondSignificant	// round up second significant figure, e.g. 2453 rounted up to 2500
	case explicit(range: Range<Double>)	// other values as specified

	public static var allCases: [ChartLimit] {
		return [.fromData, .powerOfTen, .halfPowerOfTen, firstSignificant, secondSignificant, explicit(range:-1.0 ..< -1.0)]
	}

}

public struct ChartLimits : Hashable {
	public static func == (lhs: ChartLimits, rhs: ChartLimits) -> Bool {
		return (lhs.yLimit == rhs.yLimit) && (lhs.symmetrical == rhs.symmetrical)
	}

	var yLimit: ChartLimit
	var symmetrical: Bool = false	// True overrides min. If ChartMin is nil, then min is either zero or negative of ChartMax.
}


public class ChartStyle: ObservableObject {

    public let backgroundColor: ColorGradient
    public let foregroundColor: [ColorGradient]
	public let lineWidth: CGFloat
	public let curvedLines : Bool
	public let showBackground : Bool

	public var limits : ChartLimits = ChartLimits(yLimit: .fromData)

	public init(backgroundColor: Color, foregroundColor: [ColorGradient],
				lineWidth: CGFloat = 3.0, curvedLines : Bool = true, showBackground : Bool = true) {
        self.backgroundColor = ColorGradient.init(backgroundColor)
        self.foregroundColor = foregroundColor
		self.lineWidth = lineWidth
		self.curvedLines = curvedLines
		self.showBackground = showBackground
    }
    
    public init(backgroundColor: Color, foregroundColor: ColorGradient,
				lineWidth: CGFloat = 3.0, curvedLines : Bool = true, showBackground : Bool = true) {
        self.backgroundColor = ColorGradient.init(backgroundColor)
        self.foregroundColor = [foregroundColor]
		self.lineWidth = lineWidth
		self.curvedLines = curvedLines
		self.showBackground = showBackground
    }
    
    public init(backgroundColor: ColorGradient, foregroundColor: ColorGradient,
				lineWidth: CGFloat = 3.0, curvedLines : Bool = true, showBackground : Bool = true) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = [foregroundColor]
		self.lineWidth = lineWidth
		self.curvedLines = curvedLines
		self.showBackground = showBackground
    }
    
    public init(backgroundColor: ColorGradient, foregroundColor: [ColorGradient],
				lineWidth: CGFloat = 3.0, curvedLines : Bool = true, showBackground : Bool = true) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
		self.lineWidth = lineWidth
		self.curvedLines = curvedLines
		self.showBackground = showBackground
   }
    
}
