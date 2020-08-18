import SwiftUI

public enum ChartLimit : Hashable, CaseIterable {

	case fromData
	case zeroEnding
	case zeroOrFiveEnding
	case explicit(max: Double)

	public static var allCases: [ChartLimit] {
		return [.fromData, .zeroEnding, .zeroOrFiveEnding, explicit(max: -1)]
	}

}

public struct ChartLimits : Hashable {
	public static func == (lhs: ChartLimits, rhs: ChartLimits) -> Bool {
		return (lhs.max == rhs.max) && (lhs.min == rhs.min) && (lhs.symmetrical == rhs.symmetrical)
	}

	var max: ChartLimit
	var min: ChartLimit? = nil		// if nil, then symmetrical (taking into account negative numbers)
	var symmetrical: Bool = false	// if ChartMin is nil, then min is either zero or negative of ChartMax.
}


public class ChartStyle: ObservableObject {

    public let backgroundColor: ColorGradient
    public let foregroundColor: [ColorGradient]
	public let lineWidth: CGFloat
	public let curvedLines : Bool
	public let showBackground : Bool

	public var limits : ChartLimits = ChartLimits(max: .fromData)

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
