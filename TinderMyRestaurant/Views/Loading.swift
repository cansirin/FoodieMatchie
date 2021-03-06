import SwiftUI

struct ActivityIndicator: View {

	@State private var isAnimating: Bool = false

	var body: some View {
		VStack{
			GeometryReader { (geometry: GeometryProxy) in
				ForEach(0..<5) { index in
					Group {
						Circle()
							.frame(width: geometry.size.width / 10, height: geometry.size.height / 10)
							.scaleEffect(calcScale(index: index))
							.offset(y: calcYOffset(geometry))
					}.frame(width: geometry.size.width, height: geometry.size.height)
						.rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
						.animation(Animation
												.timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
												.repeatForever(autoreverses: false))
				}
			}
			.aspectRatio(1, contentMode: .fit)
			.foregroundColor(Color(ColorCodes().mauve))
			.onAppear {
				self.isAnimating = true
			}
			Text("Loading").foregroundColor(Color(ColorCodes().mauve))
		}

	}

	func calcScale(index: Int) -> CGFloat {
		return (!isAnimating ? 1 - CGFloat(Float(index)) / 5 : 0.2 + CGFloat(index) / 5)
	}

	func calcYOffset(_ geometry: GeometryProxy) -> CGFloat {
		return geometry.size.width / 10 - geometry.size.height / 2
	}

}

struct ActivityIndicator_Previews: PreviewProvider {
	static var previews: some View {
		ActivityIndicator().frame(width: 200, height: 200).foregroundColor(.orange)
	}
}
