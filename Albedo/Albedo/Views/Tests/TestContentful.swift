import SwiftUI
import Contentful

struct TestContentful : View {

    @ObservedObject var fetcher = ContentfulFetcher()

    var body: some View {
                    HStack(alignment: .bottom, spacing: 30) {
                        ForEach(fetcher.titles, id: \.self) { item in
                            Text(item)
                        }
                    }
        }
}


// MARK: - Model


public class ContentfulFetcher: ObservableObject {

    @Published var titles = [String]()
    

    init() {
        fetch()
    }


        
    }
    func fetch() {
        let contentTypeClasses: [EntryDecodable.Type] = [
            Test.self
        ]
        let client = Client(spaceId: "m9bx0k4x0bj8",
                            accessToken: "hQImfhppVvqnxuVVxJCcY0mPWYLnUsnqm8RYQoieZRg",
                            contentTypeClasses: contentTypeClasses)
        let query = QueryOn<Test>.where(field: .title, .exists(true))

        client.fetchArray(of: Test.self, matching: query) { (result: Result<HomogeneousArrayResponse<Test>, Error>) in
            
            
            
            switch result {
            case .success(let things):
                guard let firstThing = things.items.first else { return }
                print(firstThing.title)
            case .failure(let error):
                print("Oh no something went wrong: \(error)")
            }
        }
}

final class Test: EntryDecodable, FieldKeysQueryable {

    enum FieldKeys: String, CodingKey {
        case title
    }

    static let contentTypeId: String = "test"

    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?

    let title: String

    public required init(from decoder: Decoder) throws {
        let sys = try decoder.sys()

        id = sys.id
        localeCode = sys.locale
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt

        let fields = try decoder.contentfulFieldsContainer(keyedBy: Test.FieldKeys.self)

        self.title  = try! fields.decodeIfPresent(String.self, forKey: .title)!
    }
}

        
