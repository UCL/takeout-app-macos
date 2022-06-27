//
//  ContentView.swift
//  TakeoutFilter
//
//  Created by David Guzman on 21/06/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State
    var spreadsheetUrl: String = ""
    
    @State
    var inputFolderUrl: String = ""
    
    @State
    var outputFolderUrl: String = ""
    
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
                            let openFolderUrl = openFolder()
                            readInputFolderUrl(from: openFolderUrl)
                        }) {
                            Text("Select")
                        }
                        
                        Text("\(inputFolderUrl)")
                    }
                    
                }.padding(.bottom)
                
                VStack(alignment: .leading) {
                    
                    Text("Spreadsheet with names and dates of presentation")
                    
                    HStack {
                        Button(action: {
                            let openSpreadsheetUrl = openSpreadsheet()
                            readSpreadsheetUrl(from: openSpreadsheetUrl)
                        }) {
                            Text("Select")
                        }
                        
                        Text("\(spreadsheetUrl)")
                    }
                    
                }.padding(.bottom)
                
                VStack(alignment: .leading) {
                    
                    Text("Output folder")
                    
                    HStack {
                        Button(action: {
                            let openFolderUrl = openFolder()
                            readOutputFolderUrl(from: openFolderUrl)
                        }) {
                            Text("Select")
                        }
                        
                        Text("\(outputFolderUrl)")
                    }
                }
                
            }.padding()
            
            Button(action: runFilter) {
                Text("Run filter")
            }.padding()
            
        }
    }
    
    func openFolder() -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        
        let response = openPanel.runModal()
        return response == .OK ? openPanel.url : nil
    }
    
    func readInputFolderUrl(from url: URL?) {
        guard let url = url else { return }
        inputFolderUrl = url.path
    }
    
    func readOutputFolderUrl(from url: URL?) {
        guard let url = url else { return }
        outputFolderUrl = url.path
    }
    
    func openSpreadsheet() -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [.commaSeparatedText]
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        
        let response = openPanel.runModal()
        return response == .OK ? openPanel.url : nil
    }
    
    func readSpreadsheetUrl(from url: URL?) {
        guard let url = url else { return }
        spreadsheetUrl = url.lastPathComponent
    }
    
    func runFilter() {
        // Implement
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
