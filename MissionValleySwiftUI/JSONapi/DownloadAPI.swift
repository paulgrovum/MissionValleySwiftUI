//
//  DownloadAPI.swift
//  MissionValleySwiftUI
//
//  Created by Paul Grovum on 8/18/21.
//

import SwiftUI
import Combine


struct MemberModel : Identifiable, Codable {
        var id = UUID()
        let firstname: String
        let lastname: String
    private enum CodingKeys: String, CodingKey {
        case firstname, lastname
    }
    }



class DownloadWithCombine: ObservableObject {
    @Published var members: [MemberModel] = []
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getMembers()
    }
    func getMembers() {
        let URLString = "https://www.minnesotagolfcard.com/MV_handicaps_api.php"
        guard let url = URL(string: URLString) else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data,response) -> Data in
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode <= 300 else {
                        throw URLError(.badServerResponse)
                    }
                    return data
            }
            .decode(type: [MemberModel].self, decoder: JSONDecoder())
            .sink { (completion) in
                print("COMPLETION: \(completion)")
            } receiveValue: { [weak self] (returnedMembers) in
                self?.members = returnedMembers
            }
            .store(in: &cancellables)

    }
}

struct DownloadAPI: View {
    
    @StateObject var vm = DownloadWithCombine()
    
    var body: some View {
        List {
            ForEach(vm.members) { member in
                if (member.firstname != "Name") {
                    VStack {
                        Text("\(member.firstname) \(member.lastname)")
                        Text("HI THERE")
                    }
                }
            }

        }
    }
}

struct DownloadAPI_Previews: PreviewProvider {
    static var previews: some View {
        DownloadAPI()
    }
}
