//
//  Home.swift
//  Landmarks
//
//  Created by Kuba Suder on 02.08.2020.
//  Copyright © 2020 Kuba Suder. All rights reserved.
//

import SwiftUI

struct CategoryHome: View {
    @State var showingProfile = false
    @EnvironmentObject var userData: UserData

    var categories: [String: [Landmark]] {
        Dictionary(grouping: landmarkData, by: { $0.category.rawValue })
    }

    var featured: [Landmark] {
        landmarkData.filter({ $0.isFeatured })
    }

    var profileButton: some View {
        Button(action: { self.showingProfile.toggle() }) {
            Image(systemName: "person.crop.circle")
                .imageScale(.large)
                .accessibility(label: Text("User Profile"))
                .padding()
        }
    }

    var body: some View {
        NavigationView {
            List {
                PageView(features.map { FeatureCard(landmark: $0) })
                    .scaledToFill()
                    .listRowInsets(EdgeInsets())

                ForEach(categories.keys.sorted(), id: \.self) { key in
                    CategoryRow(categoryName: key, items: self.categories[key]!)
                }
                .listRowInsets(EdgeInsets())

                NavigationLink(destination: LandmarkList() {
                    LandmarkDetail(landmark: $0)
                }) {
                    Text("See All")
                }
            }
            .navigationBarTitle("Featured")
            .navigationBarItems(trailing: profileButton)
            .sheet(isPresented: $showingProfile) {
                ProfileHost().environmentObject(self.userData)
            }
        }
    }
}

struct CategoryHome_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHome().environmentObject(UserData())
    }
}

struct FeaturedLandmarks: View {
    var landmarks: [Landmark]

    var body: some View {
        landmarks[0].image.resizable()
    }
}
