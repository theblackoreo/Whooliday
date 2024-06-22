import SwiftUI

struct ContainerView: View {
    
    @EnvironmentObject var model: AuthModel
    @State private var isFirstLaunch: Bool
    
    // Custom initializer
    init() {
        // Check if the app has been launched before
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        
        // If it has, set `isFirstLaunch` to false, otherwise true
        if hasLaunchedBefore {
            _isFirstLaunch = State(initialValue: false)
        } else {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            _isFirstLaunch = State(initialValue: true)
        }
    }

    var body: some View {
        Group {
            if isFirstLaunch {
                WelcomeView1(isFirstLaunch: $isFirstLaunch)
            } else {
                if model.userSession != nil {
                    ContentView() // Show the navigation bar with tab views
                } else {
                    SigninView()
                }
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            ExploreView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Explore")
                }
            
            FavoritesView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}

#Preview {
    ContainerView()
    
}
