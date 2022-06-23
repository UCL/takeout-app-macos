//
//  ContentView.swift
//  TakeoutFilter
//
//  Created by David Guzman on 21/06/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Google Takeout Filter")
                .font(.title)
                .padding()
            
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading) {
                    
                    Text("Folder containing Takeout files")
                    
                    Button(action: openFolder) {
                        Text("Select")
                    }
                    
                }.padding(.bottom)
                
                VStack(alignment: .leading) {
                    
                    Text("Spreadsheet with names and dates of presentation")
                    
                    Button(action: openFolder) {
                        Text("Select")
                    }
                    
                }

            }.padding()
            
        }
    }
    
    func openFolder() {
        // Implement
    }
    
    func openSpreadsheet() {
        // Implement
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
