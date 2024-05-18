import XCTest
@testable import Kaizen

final class RequesterTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }
    
    override class func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }
    
    func test_request_invalidURL() async throws {
        // Given
        let responseError = BaseRequestErrors.invalidURL
        URLProtocolStub.stub(data: nil, response: nil, error: responseError)
        let infos = InvalidRequest()
        
        let sut = DefaultRequester()
        
        // When
        do {
            let _ = try await sut.request(basedOn: infos)
            XCTFail("We should not reach this scenario")
        } catch {
            XCTAssertEqual(responseError, error as! BaseRequestErrors)
        }
    }
    
    func test_request_validURL_error() async throws {
        // Given
        let responseError = BaseRequestErrors.invalidResponse
        URLProtocolStub.stub(data: nil, response: nil, error: responseError)
        let infos = ValidRequest()
        
        let sut = DefaultRequester()
        
        // When
        do {
            let _ = try await sut.request(basedOn: infos)
            XCTFail("We should not reach this scenario")
        } catch {
            XCTAssertEqual(responseError, error as! BaseRequestErrors)
        }
    }
    
    func test_request_validURL_success() async throws {
        // Given
        let response = URLResponse.init(url: URL.init(string: "https://someurl.com")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        let data = "".data(using: .utf8)
        URLProtocolStub.stub(data: data, response: response, error: nil)
        let infos = ValidRequest()
        
        let sut = DefaultRequester()
        
        // When
        do {
            let result = try await sut.request(basedOn: infos)
            XCTAssertEqual(result.response.url?.absoluteString, "https://someurl.com")
            XCTAssertEqual(result.data, data)
        } catch {
            XCTFail("We should not reach this scenario")
        }
    }
    
    // MARK: - Helpers
    
    private struct InvalidRequest: RequestInfos {
        var endpoint: String = "/someEndpoint"
        
        var method: HTTPMethod = .get
        
        var parameters: [String : Any]? = nil
        
        var baseURL: URL? = nil
    }
    
    private struct ValidRequest: RequestInfos {
        var endpoint: String = "/someEndpoint"
        
        var method: HTTPMethod = .get
        
        var parameters: [String : Any]? = nil
    }
}

