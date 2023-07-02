import SwiftUI

struct CartScreen: View {
    
    @EnvironmentObject var sharedData: SharedDataModel
    
    @State private var tryingToPay = false
    
    //delete option
    @State var showDelete: Bool = false
    
    var body: some View {
        
        VStack {
            
            HeaderView()
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    
                    //checking if liked products are empty
                    if sharedData.cartDishes.isEmpty {
                        Group {
                            Image("emptyCart")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .padding()
                                .padding(.top, 35)
                            
                            Text("No any dish added")
                                .font(.custom(customFont, size: 20))
                                .fontWeight(.semibold)
                            
                            Text("Hit the add button on each dish for save it in cart.")
                                .font(.custom(customFont, size: 13))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .padding(.top, 10)
                        }
                    } else {
                        
                        //displaying products
                        VStack(spacing: 15) {
                            
                            //for designing
                            ForEach($sharedData.cartDishes) { $dish in
                                
                                CartView(dish: $dish)
                                    .environmentObject(sharedData)
                            }
                        }
                        .padding(.top, 25)
                        .padding(.horizontal)
                    }
                }
            }
            
            //login button
            Button {
                tryingToPay.toggle()
            } label: {
                Text(tryingToPay ? "Попытка не пытка" : "Оплатить \(sharedData.getTotalPrice()) $")
                    .font(.custom(customFont, size: 16))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(tryingToPay ? Color("unselectedTab") : Color("selectedTab"))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.07),radius: 5, x: 5, y: 5)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
            .opacity(sharedData.cartDishes.isEmpty ? 0 : 1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("background").ignoresSafeArea())
    }
}

struct CartView: View {
    
    //making product as binding so as to update in real time
    @Binding var dish: Dish
    
    @EnvironmentObject var sharedData: SharedDataModel
    
    var body: some View {
        
        //content
        HStack(spacing: 15) {
            
            //image
            ZStack {
                
                Rectangle()
                    .cornerRadius(5)
                    .foregroundColor(Color("unselectedTeg"))
                    .frame(width: 70, height: 70)
                
                CacheAsyncImage(url: URL(string: dish.imageURL ?? String())!) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Loader()
                                .frame(width: 70, height: 70)
                        }
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 55, height: 55)
                    case .failure(let error):
                        Text(error.localizedDescription)
                    @unknown default:
                        fatalError()
                    }
                }
            }
            
            //text
            VStack(alignment: .leading, spacing: 8) {
                Text(dish.name ?? String())
                    .font(.custom(customFont, size: 14))
                HStack {
                    Text("\(dish.price ?? Int()) $")
                    Text("\(dish.weight ?? Int())г")
                        .opacity(0.5)
                }
                .font(.custom(customFont, size: 14))
            }
            
            Spacer()
            
            //counting
            ZStack {
                
                Rectangle()
                    .fill(Color("backCount"))
                    .cornerRadius(10)
                    .frame(width: 120, height: 40)
                
                HStack(spacing: 10) {
                    
                    //minus
                    Button {
                        DispatchQueue.main.async {
                            (dish.quantity == 1) ? deleteProduct(dish: dish) : (dish.quantity -= 1)
                        }
                    } label: {
                        Image(systemName: "minus")
                            .font(.title3)
                            .padding(10)
                    }
                    
                    //quantity
                    Text("\(dish.quantity)")
                        .font(.custom(customFont, size: 14))
                    
                    //plus
                    Button {
                        DispatchQueue.main.async {
                            dish.quantity += 1
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .padding(10)
                    }
                }
                .foregroundColor(.primary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.cornerRadius(10))
    }
    
    //delete current dish
    func deleteProduct(dish: Dish) {
        if let index = sharedData.cartDishes.firstIndex(where: { currentDish in
            return dish.id == currentDish.id
        }) {
            //removing
            let _ = withAnimation {
                sharedData.cartDishes.remove(at: index)
            }
        }
    }
}
