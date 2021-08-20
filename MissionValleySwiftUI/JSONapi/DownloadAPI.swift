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
        let three: Int
        let four: Int
        let five: Int
        let six: Int
        let index: Float
        let threefour:  Int
        let fourfive: Int
        private enum CodingKeys: String, CodingKey {
            case three = "3",
                 four = "4",
                 five = "5",
                 six = "6",
                 index = "HDCP_index",
                 threefour = "3-4",
                 fourfive = "4-5",
                 firstname,
                 lastname
        }
    }



class DownloadWithCombine: ObservableObject {
    @Published var members: [MemberModel] = []
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getMembers()
    }
    func getMembers() {
        let URLString = "https://www.thesouthbaygroup.com/MV_handicaps_api.php"
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
                    HStack(alignment: .top) {
                            Text("\(member.firstname) \(member.lastname)")
                                .frame(height: 8, alignment: .leading)
                                .foregroundColor(Color.red)
                            Spacer()
                            Text("\(String(format: "%.1f",member.index))")
                                .frame(height: 8, alignment: .leading)
                            Text("\(member.three)")
                                .frame(height: 8, alignment: .leading)
    //                        Text("\(String(format: "%.1f",member.index)) \(member.three) \(member.four) \(member.five) \(member.six)")
    //                            .frame(height: 10, alignment: .leading)
                            
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                        //.background(Color.black)
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
