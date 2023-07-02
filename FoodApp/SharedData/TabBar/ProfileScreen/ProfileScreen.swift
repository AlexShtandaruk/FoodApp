import SwiftUI
import NavigationStack

struct ProfileScreen: View {
    
    @EnvironmentObject var sharedData: SharedDataModel
    
    @EnvironmentObject var routerModel: NavigationContainerViewModel
    
    var body: some View {
        
        VStack {
            
            Text("My profile")
                .font(.custom(customFont, size: 28).bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    
                    VStack(alignment: .center, spacing: 10) {
                        
                        ZStack(alignment: .bottom) {
                            
                            Rectangle()
                                .fill(Color("selectedTab"))
                                .opacity(0.5)
                                .frame(maxWidth: .infinity, maxHeight: 170)
                                .cornerRadius(30)
                            
                            VStack(spacing: 7) {
                                
                                Image("profileImage")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                
                                Text("Alex Shtandaruk")
                                    .font(.custom(customFont, size: 16))
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 15)
                                
                                HStack(alignment: .top, spacing: 10) {
                                    Image(systemName: "location.north.circle.fill")
                                        .foregroundColor(.white)
                                        .rotationEffect(.init(degrees: 180))
                                    
                                    Text("Adress: 43 Lenin square,\nMoscow, RU")
                                        .font(.custom(customFont, size: 15))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.bottom, 20)
                                //.multilineTextAlignment(.center)
                            }
                        }
                    }
                    .padding(.horizontal, 50)
                    .padding(.bottom)
                    
                    HStack {
                        
                        Text("Liked dishes")
                            .font(.custom(customFont, size: 17))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.black)
                    .padding()
                    .background(
                        Color("separator")
                            .cornerRadius(12)
                    )
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .onTapGesture {
                        routerModel.push(screenView: LazyView(LikeScreen()
                            .environmentObject(sharedData)
                        )
                            .toAnyView()
                        )
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("background").ignoresSafeArea())
    }
}
