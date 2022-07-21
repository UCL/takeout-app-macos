//
//  MainView.swift
//  TakeoutFilter
//
//  Created by David Guzman on 21/06/2022.
//

import SwiftUI

struct MainView: View {
    
    @State
    var spreadsheetUrl: URL?
    
    @State
    var inputFolderUrl: URL?
    
    @State
    var outputFolderUrl: URL?
    
    @State
    private var displayMessage = false
    
    @State
    private var filterPayback: FilterPayback?
    
    @State
    private var filteringProgress: Double = 0.0
    
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
                        
                        Text(readPathFromUrl(from: inputFolderUrl))
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
                        
                        Text(readPathFromUrl(from: spreadsheetUrl))
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
                        
                        Text(readPathFromUrl(from: outputFolderUrl))
                            .frame(minWidth: 400, alignment: .leading)
                    }
                }
                
            }.padding()
            
            Button(action: runFilter) {
                Text("Run filter")
            }
            
            VStack {
                ProgressView("Filtering... ", value: filteringProgress, total: 100)
            }.padding()
            
            .alert("Notification", isPresented: $displayMessage, presenting: filterPayback, actions: {payback in
                    Text("")}, message:{payback in Text(payback.message)})
            

        }
    }
    
    func readInputFolderUrl(from url: URL?) {
        guard let url = url else { return }
        inputFolderUrl = url
    }
    
    func readOutputFolderUrl(from url: URL?) {
        guard let url = url else { return }
        outputFolderUrl = url
    }
    
    func readSpreadsheetUrl(from url: URL?) {
        guard let url = url else { return }
        spreadsheetUrl = url
    }
    
    func readPathFromUrl(from url: URL?) -> String {
        guard let url = url else {
            return ""
        }
        return url.path
    }
    
    func progressCallback(_ progress: Double) {
        filteringProgress = progress
    }
    
    func runFilter() {
        filterPayback = logic.filter(catalogue: spreadsheetUrl, sourceDir: inputFolderUrl, outputDir: outputFolderUrl, progress: progressCallback)
        displayMessage = true
        // Implement
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
