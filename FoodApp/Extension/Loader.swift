import SwiftUI

// MARK: - Constant's

struct Loader: View {
    
    @State var animate = false
    
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(
                    AngularGradient(gradient: .init(colors: [.gray, .white]), center: .center),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 20, height: 20, alignment: .center)
                .rotationEffect(.init(degrees: self.animate ? 360 : 0))
                .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false),
                           value: UUID())
        }
        .frame(width: 100, height: 80)
        .onAppear {
            self.animate.toggle()
        }
    }
}


