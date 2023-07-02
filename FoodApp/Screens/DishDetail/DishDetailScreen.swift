import SwiftUI

struct DishDetailScreen: View {
    
    var dish: Dish
    
    @EnvironmentObject var sharedData: SharedDataModel
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .fill(.primary)
                .opacity(0.2)
                .onTapGesture {}
            
            ZStack {
                
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    ZStack(alignment: .center) {
                        
                        Rectangle()
                            .fill(Color("unselectedTeg"))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .cornerRadius(10)
                        
                        ZStack {
                            
                            CacheAsyncImage(url: URL(string: dish.imageURL ?? String())!) { phase in
                                switch phase {
                                case .empty:
                                    ZStack {
                                        Loader()
                                    }
                                case .success(let image):
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 180,height: 180)
                                case .failure(let error):
                                    Text(error.localizedDescription)
                                @unknown default:
                                    fatalError()
                                }
                            }
                            
                            VStack {
                                
                                HStack {
                                    
                                    Spacer()

                                    //like button
                                    ZStack {
                                        
                                        Rectangle()
                                            .fill(sharedData.likedDish.contains(dish) ? Color.red : Color.white)
                                            .frame(width: 45,height: 45)
                                            .cornerRadius(10)
                                        Image("like")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20,height: 25)
                                    }
                                    .onTapGesture {
                                        addToLiked()
                                    }
                                    //dismis button
                                    ZStack {
                                        Rectangle()
                                            .fill(Color.white)
                                            .frame(width: 45,height: 45)
                                            .cornerRadius(10)
                                        Image("dismis")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 25, height: 25)
                                    }
                                    .onTapGesture {
                                        sharedData.showDetailDish = false
                                    }
                                }
                                .padding(.trailing, 10)
                                Spacer()
                            }
                            .padding(.top, 10)
                        }
                    }
                    
                    Text(dish.name ?? String())
                        .font(.custom(customFont, size: 16).bold())
                        .foregroundColor(.primary)
                    HStack {
                        Text("\(dish.price ?? Int()) $")
                        Text("\(dish.weight ?? Int())г")
                            .opacity(0.5)
                    }
                    .font(.custom(customFont, size: 16))
                    .foregroundColor(.primary)
                    Text(dish.description ?? String())
                        .font(.custom(customFont, size: 13))
                        .foregroundColor(.primary)
                    
                    //add to basket button
                    Button {
                        addToCart()
                    } label: {
                        Text((sharedData.cartDishes.contains(dish) ? "Товар добавлен" : "Добавить в корзину"))
                            .font(.custom(customFont, size: 16))
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background(
                                (sharedData.cartDishes.contains(dish) ? Color("unselectedTab") : Color("selectedTab"))
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
                            )
                            
                    }

                    
                }
                .padding(20)
            }
            .padding(.horizontal, 15)
            .padding(.top, 160)
            .padding(.bottom, 110)
        }
        .ignoresSafeArea()
    }
    
    func isLiked() -> Bool {
        return sharedData.likedDish.contains { curDish in
            return self.dish.id == curDish.id
        }
    }
    
    func isCarted() -> Bool {
        return sharedData.cartDishes.contains { curDish in
            return self.dish.id == curDish.id
        }
    }
    
    func addToLiked() {
        if let index = sharedData.likedDish.firstIndex(where: { curDish in
            return self.dish.id == curDish.id
        }) {
            //remove from liked
            sharedData.likedDish.remove(at: index)
        } else {
            //add to liked
            sharedData.likedDish.append(dish)
        }
    }
    
    func addToCart() {
        if let index = sharedData.cartDishes.firstIndex(where: { curDish in
            return self.dish.id == curDish.id
        }) {
            //remove from liked
            sharedData.cartDishes.remove(at: index)
        } else {
            //add to liked
            sharedData.cartDishes.append(dish)
        }
    }
}

struct DishDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
