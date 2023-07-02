import SwiftUI
import NavigationStack

struct CategoryDetailScreen: View {
    
    var data: CurrentCategory
    
    @ObservedObject var viewModel: CategoryDetailViewModel = .init()
    
    @EnvironmentObject var sharedData: SharedDataModel
    
    @EnvironmentObject var routerModel: NavigationContainerViewModel
    
    init(data: CurrentCategory) {
        self.data = data
    }
    
    var body: some View {
        
        VStack {
            //back button
            HStack {
                Button {
                    routerModel.pop()
                } label: {
                    Image("arrowLeft")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.primary)
                    
                }
                Text(data.name ?? String())
                    .font(.custom(customFont, size: 17).bold())
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                Spacer()
                Image("profileImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }
            .padding(.horizontal, 10)
            //dishes
            VStack {
                
                HStack {
                    Spacer()
                    //types
                    
                    //for automatic scrolling
                    ScrollViewReader { reader in
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(DishTeg.allCases, id: \.self) { teg in
                                    Text(teg.rawValue)
                                        .font(.custom(customFont, size: 14))
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                        .background(viewModel.selectedTab == teg ? Color("selectedTab") : Color("unselectedTeg"))
                                        .clipShape(Rectangle())
                                        .cornerRadius(10)
                                        .foregroundColor(viewModel.selectedTab == teg ? .white : .primary)
                                        .onTapGesture {
                                            viewModel.selectedTab = teg
                                        }
                                        .onChange(of: viewModel.selectedTab) { newValue in
                                            withAnimation {
                                                reader.scrollTo(viewModel.selectedTab, anchor: .leading)
                                            }
                                        }
                                }
                            }
                        }
                    }
                    Spacer()
                }
                
                //staggered grid
                ScrollView(.vertical, showsIndicators: false) {
                    StaggeredGrid(columns: 3, spacing: 20, list: viewModel.filtredData) { dish in
                        
                        //card view
                        dishCell(dish: dish)
                        
                    }
                }
            }
        }
        
        //disable changes of superview
        .disabled(sharedData.showDetailDish ? true : false)
    }
    
    @ViewBuilder
    func dishCell(dish: Dish) -> some View {
        
        VStack {
            
            ZStack(alignment: .center) {
                
                Rectangle()
                    .fill(Color("unselectedTeg"))
                    .frame(width: 110,height: 110)
                    .cornerRadius(20)
                    .padding()
                
                CacheAsyncImage(url: URL(string: dish.imageURL ?? String())!) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Loader()
                        }
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70,height: 70)
                    case .failure(let error):
                        Text(error.localizedDescription)
                    @unknown default:
                        fatalError()
                    }
                }
            }
            
            Text(dish.name ?? String())
                .font(.custom(customFont, size: 13))
                .lineLimit(2)
        }
        .padding(.horizontal)
        .onTapGesture {
            
            //showing subscribtion detail when tapped
            withAnimation(.easeInOut) {
                sharedData.detailDish = dish
                sharedData.showDetailDish = true
            }
        }
    }
}

