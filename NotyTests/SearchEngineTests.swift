import XCTest
@testable import Noty

final class SearchEngineTests: XCTestCase {
    @MainActor
    func testEmptyQueryHasNoResults() {
        let engine = SearchEngine()
        let notes = [
            Note(title: "Alpha", content: "some content"),
            Note(title: "Beta", content: "other content")
        ]
        engine.query = ""
        engine.setNotes(notes)
        XCTAssertTrue(engine.results.isEmpty)
    }

    @MainActor
    func testTitleMatchBeatsContentMatch() {
        let engine = SearchEngine()
        var n1 = Note(title: "Hello World", content: "nope") // title hit
        var n2 = Note(title: "nothing", content: "Says hello world in body") // content hit
        // Ensure dates don't flip sort order by chance
        n1.date = Date()
        n2.date = Date(timeIntervalSinceNow: -60)
        engine.query = "hello"
        engine.setNotes([n1, n2])
        XCTAssertEqual(engine.results.first?.note.id, n1.id)
    }

    @MainActor
    func testTagMatchScored() {
        let engine = SearchEngine()
        let n = Note(title: "Title", content: "Body", tags: ["swift", "notes"])
        engine.query = "swift"
        engine.setNotes([n])
        XCTAssertEqual(engine.results.count, 1)
        XCTAssertEqual(engine.results.first?.note.id, n.id)
    }

    @MainActor
    func testSetNotesAfterQueryComputesImmediately() {
        let engine = SearchEngine()
        let n = Note(title: "MatchMe", content: "")
        engine.query = "match"
        engine.setNotes([n]) // triggers performSearch immediately
        XCTAssertEqual(engine.results.first?.note.id, n.id)
    }
}

