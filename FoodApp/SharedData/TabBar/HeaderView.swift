import SwiftUI

struct HeaderView: View {
    
    var body: some View {
        //title
        HStack {
            HStack {
                Image("location")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 25, height: 25)
                    .offset(y: -10)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Saint-Petersburg")
                        .font(.custom(customFont, size: 17).bold())
                    Text("12 august, 2023")
                        .font(.custom(customFont, size: 15))
                        .opacity(0.5)
                }
            }
            Spacer()
            Image("profileImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 45, height: 45)
                .clipShape(Circle())
        }
        .padding(.horizontal)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
