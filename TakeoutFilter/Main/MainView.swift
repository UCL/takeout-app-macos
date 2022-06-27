//
//  MainView.swift
//  TakeoutFilter
//
//  Created by David Guzman on 21/06/2022.
//

import SwiftUI

struct MainView: View {
    
    @State
    var spreadsheetUrl: URL = FileManager().homeDirectoryForCurrentUser
        .appendingPathComponent("master-list.csv")
    
    @State
    var inputFolderUrl: URL = FileManager().homeDirectoryForCurrentUser
    
    @State
    var outputFolderUrl: String = ""
    
    let logic = MainLogic()
    
    var body: some View {
        VStack {
            Text("Google Takeout Filter")
                .font(.title)
                .padding()
            
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading) {
                    
                    Text("Folder containing Takeout files")
                    
                    HStack {
                        Button(action: {
                            let openFolderUrl = logic.openFolder()
                            readInputFolderUrl(from: openFolderUrl)
                        }) {
                            Text("Select")
                        }
                        
                        Text(inputFolderUrl.path)
                            .frame(minWidth: 400, alignment: .leading)
                    }
                    
                }.padding(.bottom)
                
                VStack(alignment: .leading) {
                    
                    Text("Spreadsheet with names and dates of presentation")
                    
                    HStack {
                        Button(action: {
                            let openSpreadsheetUrl = logic.openCsvFile()
                            readSpreadsheetUrl(from: openSpreadsheetUrl)
                        }) {
                            Text("Select")
                        }
                        
                        Text(spreadsheetUrl.lastPathComponent)
                            .frame(minWidth: 400, alignment: .leading)
                    }
                    
                }.padding(.bottom)
                
                VStack(alignment: .leading) {
                    
                    Text("Output folder")
                    
                    HStack {
                        Button(action: {
                            let openFolderUrl = logic.openFolder()
                            readOutputFolderUrl(from: openFolderUrl)
                        }) {
                            Text("Select")
                        }
                        
                        Text("\(outputFolderUrl)")
                            .frame(minWidth: 400, alignment: .leading)
                    }
                }
                
            }.padding()
            
            Button(action: runFilter) {
                Text("Run filter")
            }.padding()
            
        }
    }
    
    func readInputFolderUrl(from url: URL?) {
        guard let url = url else { return }
        inputFolderUrl = url
    }
    
    func readOutputFolderUrl(from url: URL?) {
        guard let url = url else { return }
        outputFolderUrl = url.path
    }
    
    func readSpreadsheetUrl(from url: URL?) {
        guard let url = url else { return }
        spreadsheetUrl = url
    }
    
    func runFilter() {
        logic.filter(catalogue: spreadsheetUrl, sourceDir: inputFolderUrl)
        // Implement
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
