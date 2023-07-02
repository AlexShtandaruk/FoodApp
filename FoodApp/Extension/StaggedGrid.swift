import SwiftUI

//custom view builder

//T -> is to hold the Identifiable collection of data

struct StaggeredGrid<Content: View, T: Identifiable>: View where T: Hashable {
    
    //it will return each object from collection to build view
    var content: (T) -> Content
    var list: [T]
    
    //columns
    var columns: Int
    
    //properties
    var showIndicators: Bool
    var spacing: CGFloat
    
    init(columns: Int, showIndicators: Bool = false, spacing: CGFloat = 10, list: [T], content: @escaping (T) -> Content) {
        self.columns = columns
        self.showIndicators = showIndicators
        self.spacing = spacing
        self.list = list
        self.content = content
    }
    
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 0) {
            ForEach(setUpList(), id: \.self) { columnsData in
                
                //for optimized using lazyStack
                LazyVStack(spacing: spacing) {
                    
                    ForEach(columnsData, id: \.self) { object in
                        content(object)
                        
                    }
                }
                .padding(.top, 0)
            }
        }
        //only vertical padding
        //horizontal padding will be users optional
        .padding(.vertical)
    }
    
    
    //staggered grid func
    
    func setUpList() -> [[T]] {
        
        //creating empty sub arrays of columns count
        var gridArray: [[T]] = Array(repeating: [], count: columns)
        
        //spliting array for Vstack oriented view
        var currentIndex: Int = 0
        
        for object in list {
            gridArray[currentIndex].append(object)
            
            //increasing index count
            //and resetting if overbounds the columns count
            if currentIndex == (columns - 1) {
                currentIndex = 0
            } else {
                currentIndex += 1
            }
            
        }
        return gridArray
    }
}
