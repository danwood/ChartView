import SwiftUI

public class ChartStyle: ObservableObject {

    public let backgroundColor: ColorGradient
    public let foregroundColor: [ColorGradient]
	public let lineWidth: CGFloat
	public let curvedLines : Bool
	public let showBackground : Bool

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
