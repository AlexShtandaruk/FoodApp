import SwiftUI
import NavigationStack

struct HomeScreen: View {
    
    @ObservedObject var viewModel: HomeViewModel = .init()
    
    @EnvironmentObject var sharedData: SharedDataModel
    
    @EnvironmentObject var routerModel: NavigationContainerViewModel
    
    var body: some View {
            
            VStack {
                //header with location and photo
                HeaderView()
                
                //scroll view
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 10) {
                        
                        ForEach(viewModel.data ?? []) { category in
                            
                            LazyView(categoryCell(category: category))
                                .onTapGesture {
                                    routerModel.push(screenView: LazyView(
                                        CategoryDetailScreen(data: category)
                                            .environmentObject(sharedData)
                                    )
                                        .toAnyView()
                                        
                                    )
                                }
                        }
                    }
                }
            }
    }
    
    @ViewBuilder
    func categoryCell(category: CurrentCategory) -> some View {
        ZStack {
            CacheAsyncImage(url: URL(string: category.imageURL ?? String())!) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Rectangle()
                            .cornerRadius(15)
                            .foregroundColor(Color("selectedTab"))
                            .opacity(0.1)
                            .frame(maxWidth: .infinity)
                            .frame(height: 160)
                        Loader()
                    }
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)
                        .cornerRadius(10)
                case .failure(let error):
                    Text(error.localizedDescription)
                @unknown default:
                    fatalError()
                }
            }
            
            VStack {
                HStack {
                    Text(category.name ?? String())
                        .font(.custom(customFont, size: 18))
                        .lineLimit(2)
                        .foregroundColor(.primary)
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
        .padding(.horizontal)
    }
    
}

struct MovieList_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - Constant's

extension HomeScreen {
    
    struct Constant {
        
    }
}
