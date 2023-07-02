import SwiftUI
import NavigationStack

// to use custom font on all pages
let customFont = "Montserrat-Regular"

struct MainTabBar: View {
    
    init() {
        UITabBar.appearance().isHidden = true
        UINavigationBar.appearance().isHidden = true
    }
    
    //current tab
    @State var currentTab: Tab = .home
    
    @StateObject var sharedData: SharedDataModel = .init()
    
    var homeRouter: NavigationContainerViewModel = .init()
    var searchRouter: NavigationContainerViewModel = .init()
    var cartRouter: NavigationContainerViewModel = .init()
    var profileRouter: NavigationContainerViewModel = .init()

    
    var body: some View {
        
        VStack(spacing: 10) {
            
            //tab view
                
                TabView(selection: $currentTab) {
                    
                    NavigationContainerView(transition: .none, viewModel: homeRouter) {
                        HomeScreen()
                            .environmentObject(sharedData)
                    }
                    .tag(Tab.home)
                    
                    NavigationContainerView(transition: .none, viewModel: searchRouter) {
                        SearchScreen()
                            .environmentObject(sharedData)
                    }
                        .tag(Tab.search)
                    
                    NavigationContainerView(transition: .none, viewModel: cartRouter) {
                        CartScreen()
                            .environmentObject(sharedData)
                    }
                        .tag(Tab.cart)
                    
                    NavigationContainerView(transition: .none, viewModel: profileRouter) {
                        ProfileScreen()
                            .environmentObject(sharedData)
                    }
                        .tag(Tab.account)
                }
            
            //custom tab bar
            VStack(spacing: 4) {
                
                Rectangle()
                    .fill(Color("separator"))
                    .frame(height: 0.5)
                    .offset(y: -8)
                HStack(spacing: 0) {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        Button(action: {
                            
                            //updating tab
                            currentTab = tab
                        }) {
                            VStack {
                                Image(tab.image)
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 27, height: 27)
                                Text(tab.title)
                                    .font(.custom(customFont, size: 10))
                            }
                            //appling little shadow at background
                            .background(
                                Color("selectedTab")
                                    .opacity(0.1)
                                    .cornerRadius(5)
                                //bluring
                                    .blur(radius: 5)
                                //making little big
                                    .padding(-7)
                                    .opacity(currentTab == tab ? 1 : 0)
                            )
                            
                            .frame(maxWidth: .infinity)
                            .foregroundColor(currentTab == tab ? Color("selectedTab") : Color("unselectedTab"))
                        }
                    }
                }
            }
        }
        .background(Color("background").ignoresSafeArea())
        
        //overlay detail dish
        .overlay(
            ZStack {
                
                //detail page
                if let dishDetail = sharedData.detailDish, sharedData.showDetailDish {
                    DishDetailScreen(dish: dishDetail)
                        .environmentObject(sharedData)
                    
                    //adding transition
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                }
            }
        )
    }
}

struct MainTabBar_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBar()
    }
}

// tab cases, #2 make case iterable
enum Tab: CaseIterable {
    //raw value must be image name in asset
    case home
    case search
    case cart
    case account
    
    var title: String {
        switch self {
        case .home:
            return "Главная"
        case .search:
            return "Поиск"
        case .cart:
            return "Корзина"
        case .account:
            return "Аккаунт"
        }
    }
    
    var image: String {
        switch self {
        case .home:
            return "main"
        case .search:
            return "search"
        case .cart:
            return "cart"
        case .account:
            return "account"
        }
    }
}

