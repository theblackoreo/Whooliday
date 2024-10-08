import SwiftUI
import RiveRuntime

let imgAnimation = RiveViewModel(fileName: "pag1")


// first welcome page
struct WelcomeView1: View {
    
    @Binding var isFirstLaunch: Bool
    @State private var path = NavigationPath()
    @State private var offset: CGFloat = 0.0
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button("skip") {
                    isFirstLaunch = false
                }
                .foregroundColor(.black)
                .font(.custom("TT Hoves Pro Trial Regular", size: 18, relativeTo: .body))
                .buttonStyle(PlainButtonStyle())
                .frame(width: 330, alignment: .trailing)
                
                imgAnimation.view()
                    .onAppear {
                        imgAnimation.play()
                    }
                    .frame(width: 350, alignment: .center)
                
                Text(NSLocalizedString("Save now.", comment: ""))
                    .font(.custom("TT Hoves Pro Trial Bold", size: 30, relativeTo: .headline))
                    .frame(width: 300, alignment: .center)
                
                Text(NSLocalizedString("Effortlessly.", comment: ""))
                    .font(.custom("TT Hoves Pro Trial DemiBold", size: 30, relativeTo: .headline))
                    .frame(width: 300, alignment: .center)
                    .padding(.bottom, 20)
                
                Text(NSLocalizedString("simple", comment: ""))
                    .font(.custom("TT Hoves Pro Trial Regular", size: 18, relativeTo: .body))
                    .multilineTextAlignment(.center)
                    .frame(width: 350, alignment: .center)
                    .lineSpacing(3)
                    .padding(.bottom, 80)
                
                Spacer()
                
                Button(NSLocalizedString("Next", comment: "")) {
                    path.append("WelcomeView2")
                }
                .foregroundColor(.orange)
                .font(.custom("TT Hoves Pro Trial Regular", size: 18, relativeTo: .body))
                .fontWeight(.bold)
                .padding(.bottom, 30)
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 9, height: 9)
                    Circle()
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(width: 8, height: 8)
                }
                .padding(.top, 30)
                
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation.width
                    }
                    .onEnded { gesture in
                        if gesture.translation.width < -100 {
                            // Swipe left: go to WelcomeView2
                            path.append("WelcomeView2")
                        }
                        offset = 0
                    }
            )
            .navigationDestination(for: String.self) { value in
                if value == "WelcomeView2" {
                    WelcomeView2(isFirstLaunch: $isFirstLaunch)
                }
            }
        }
    }
}

#Preview {
    WelcomeView1(isFirstLaunch: .constant(true))
}
