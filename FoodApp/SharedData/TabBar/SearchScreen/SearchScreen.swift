import SwiftUI

struct SearchScreen: View {
    
    //shared data
    @EnvironmentObject var sharedData: SharedDataModel
    
    @ObservedObject var viewModel: SearchViewModel = .init()
    
    //activating text field with the help of focus state
    @FocusState var startTF: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            //search bar
            HStack(spacing: 20) {
                
                //search bar
                HStack(spacing: 15) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    //since we need a separate view for search bar
                    TextField("Search", text: $viewModel.searchText)
                        .focused($startTF)
                        .textCase(.lowercase)
                        .autocorrectionDisabled(true)
                }
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(Capsule().strokeBorder(.indigo, lineWidth: 1.5))
            }
            .padding([.horizontal])
            .padding(.top)
            .padding(.bottom, 10)
            
            //show progress if searching else showing not results found if empty
            if let dishes = viewModel.searchedDishes {
                
                //no result found
                if dishes.isEmpty {
                    VStack(spacing: 10) {
                        Image("notFound")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.top, 60)
                        Text("Dish not found")
                            .font(.custom(customFont, size: 22).bold())
                        Text("Try more generic search term or try looking for alternative dish.")
                            .font(.custom(customFont, size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    .padding()
                }
                
                //filter result
                else {
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(spacing: 0) {
                            
                            //found text
                            Text("Found \(dishes.count) results")
                                .font(.custom(customFont, size: 24).bold())
                                .padding(.vertical)
                            
                            //staggered grid
                            StaggeredGrid(columns: 2, spacing: 5, list: dishes) { dish in
                                
                                //card view
                                dishCardView(dish: dish)
                            }
                        }
                        .padding()
                    }
                }
            } else {
                Loader()
                    .padding(.top, 30)
                    .opacity(viewModel.searchText == "" ? 0 : 1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            Color("BGColor").ignoresSafeArea()
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                startTF = true
                
            }
        }
    }
    
    @ViewBuilder
    func dishCardView(dish: Dish) -> some View {
        VStack(spacing: 10) {
            
            CacheAsyncImage(url: URL(string: dish.imageURL ?? String())!) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Rectangle()
                            .cornerRadius(15)
                            .foregroundColor(Color("selectedTab"))
                            .frame(width: 120, height: 120)
                            .opacity(0.1)
                        Loader()
                    }
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                case .failure(let error):
                    Text(error.localizedDescription)
                @unknown default:
                    fatalError()
                }
            }
            
            Text(dish.name ?? String())
                .font(.custom(customFont, size: 13))
                .fontWeight(.semibold)
                .foregroundColor(Color("selectedTab"))
                .padding(.top)
                .multilineTextAlignment(.center)
            Text("\(dish.price ?? Int()) $")
                .font(.custom(customFont, size: 11))
                .foregroundColor(.gray)
            
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 22)
        .background(Color.white.cornerRadius(25))
        .padding(.top, 50)
        .onTapGesture {
            withAnimation(.easeInOut) {
                sharedData.fromSearchPage = true
                sharedData.detailDish = dish
                sharedData.showDetailDish = true
            }
        }
    }
    
}
