//
//  SetRowView.swift
//  ManaGuide
//
//  Created by Vito Royeca on 4/1/22.
//

import SwiftUI
import ManaKit
import SDWebImageSwiftUI

struct SetRowView: View {
    private let set: MGSet
    
    init(set: MGSet) {
        self.set = set
    }
    
    var body: some View {
        VStack(alignment: .leading) {
//            if let url = set.logoURL {
//                WebImage(url: url)
//                    .resizable()
//                    .indicator(.activity)
//                    .transition(.fade(duration: 0.5))
//                    .aspectRatio(contentMode: .fit)
//                    .frame(height: 40)
//                    .clipped()
//            }
//            Spacer()
            HStack {
                Text(set.keyrune2Unicode())
                    .scaledToFit()
                    .font(Font.custom("Keyrune", size: 30))
                Text(set.name ?? "")
                    .font(.headline)
            }
            Spacer()
            HStack {
                Text("Code: \(set.code)")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                
                Spacer()
                
                Text("\(set.cardCount) card\(set.cardCount > 1 ? "s" : "")")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.trailing)
            }
            Spacer()
            Text("Release Date: \(set.releaseDate ?? "")")
                .font(.subheadline)
                .foregroundColor(Color.gray)
            Spacer()
        }
    }
}

struct SetRowView_Previews: PreviewProvider {
    static var previews: some View {
        Text("set not found")
    }
}