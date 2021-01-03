import Foundation
import Combine
import SQLite

enum ApplicationAction {
    case setDatabaseConnection(data: Connection?)
    case setCurrentTargetCode(data: Int?)
    case setAutoplay(data: Bool)
}

struct ApplicationState {
    var autoPlay: Bool
    var db: Connection?
    var targetCode: Int?
}

func applicationReducer(
    state: inout ApplicationState,
    action: ApplicationAction
) -> AnyPublisher<ApplicationAction, Never>? {
    switch action {
        case let .setDatabaseConnection(data):
            state.db = data
        case let .setCurrentTargetCode(data):
            state.targetCode = data
        case let .setAutoplay(data):
            state.autoPlay = data
    }
    return nil
}
