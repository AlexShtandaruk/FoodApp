import SwiftUI
import NavigationStack

struct LikeScreen: View {
    
    @EnvironmentObject var sharedData: SharedDataModel
    
    @EnvironmentObject var routerModel: NavigationContainerViewModel
    
    //delete option
    @State var showDelete: Bool = false
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack {
                
                //button's
                HStack {
                    
                    //back
                    Button {
                        routerModel.pop()
                    } label: {
                        Image("arrowLeft")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.primary)
                    }
                    
                    Text("Favourite")
                        .font(.custom(customFont, size: 28)
                            .bold())
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            showDelete.toggle()
                        }
                    } label: {
                        Image(systemName: "trash.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    .opacity(sharedData.likedDish.isEmpty ? 0 : 1)
                }
                
                //checking if liked products are empty
                if sharedData.likedDish.isEmpty {
                    Group {
                        Image("emptyFavourite")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .padding()
                            .padding(.top, 35)
                        
                        Text("No favourites yet")
                            .font(.custom(customFont, size: 25))
                            .fontWeight(.semibold)
                        
                        Text("Hit the like button on each dish to save favourite ones.")
                            .font(.custom(customFont, size: 18))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.top, 10)
                    }
                    
                } else {
                    
                    //displaying products
                    VStack(spacing: 15) {
                        
                        //for designing
                        ForEach(sharedData.likedDish) { dish in
                            
                            HStack(spacing: 0) {
                                if showDelete {
                                    Button {
                                        deleteProduct(dish: dish)
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.red)
                                    }
                                    .padding(.trailing)
                                    
                                }
                                cardView(dish: dish)
                            }
                        }
                    }
                    .padding(.top, 25)
                    .padding(.horizontal)
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BGColor").ignoresSafeArea())
    }
    
    @ViewBuilder
    func cardView(dish: Dish) -> some View {
        
        //content
        HStack(spacing: 15) {
            
            //image
            CacheAsyncImage(url: URL(string: dish.imageURL ?? String())!) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Rectangle()
                            .cornerRadius(15)
                            .foregroundColor(Color("selectedTab"))
                            .opacity(0.1)
                            .frame(maxWidth: .infinity)
                            .frame(width: 90, height: 90)
                        Loader()
                    }
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(width: 90, height: 90)
                case .failure(let error):
                    Text(error.localizedDescription)
                @unknown default:
                    fatalError()
                }
            }
            
            //text
            VStack(alignment: .leading, spacing: 8) {
                Text(dish.name ?? String())
                    .font(.custom(customFont, size: 18).bold())
                    .lineLimit(1)
                
                Text("\(dish.price ?? Int()) $")
                    .font(.custom(customFont, size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(.indigo)
                
                Text("Weight: \(dish.weight ?? Int())gr.")
                    .font(.custom(customFont, size: 13))
                    .opacity(0.5)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.cornerRadius(10))
    }
    
    func deleteProduct(dish: Dish) {
        if let index = sharedData.likedDish.firstIndex(where: { currentDish in
            return dish.id == currentDish.id
        }) {
            //removing
            let _ = withAnimation {
                sharedData.likedDish.remove(at: index)
            }
        }
    }
}
