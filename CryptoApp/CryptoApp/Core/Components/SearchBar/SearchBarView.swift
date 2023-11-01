//
//  SearchBarView.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 31.10.2023.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ?  Color.theme.secondaryText : Color.theme.tint)
            
            TextField("Search by name or symbol...", text: $searchText)
                .foregroundColor(Color.theme.tint)
                .autocorrectionDisabled(true)
                .keyboardType(.alphabet)
                .overlay(alignment: .trailing) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(
                            Color.theme.tint.opacity(
                                searchText.isEmpty ? 0.0 : 1
                            )
                        )
                        .padding()
                        .offset(x: 10)
                        .onTapGesture {
                            searchText = ""
                            UIApplication.shared.endEditing()
                        }
                }
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
        )
        .shadow(color: Color.theme.tint.opacity(0.3), radius: 10)
        .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
            
            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
        
    }
}
