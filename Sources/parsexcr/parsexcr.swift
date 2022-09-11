import Foundation
import ArgumentParser
import XCResultKit

@main
public struct parsexcr: ParsableCommand {
    public static let configuration = CommandConfiguration(abstract: "Parses tests data from .xcresult file")
    
    @Argument(help: "The path to the .xcresult file")
    private var path: String
    
    @Option(name: .long, help: "The ID for your ")
    private var id: String
    
    public init() {}

    public func run() throws {
        var testCount = 0
        var testsFailed = 0
        let xcresult = XCResultFile(url: URL.init(string: path)!)
        let testSummary = xcresult.getTestPlanRunSummaries(id: id)
        testSummary?.summaries.forEach { summary in
            summary.testableSummaries.forEach { testableSummary in
                testableSummary.tests.forEach { test in
                    test.subtestGroups.forEach { group in
                        group.subtestGroups.forEach {subGroup in
                            subGroup.subtests.forEach { subTest in
                                testCount += 1
                                if subTest.testStatus != "Success" {
                                    testsFailed += 1
                                }
                            }
                        }
                    }
                }
            }
        }
        print("{ \"tests\": \(testCount), \"failed\": \(testsFailed) }")
    }
}
