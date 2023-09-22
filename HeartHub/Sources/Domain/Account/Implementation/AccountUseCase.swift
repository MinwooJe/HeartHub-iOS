//
//  AccountUseCase.swift
//  HeartHub
//
//  Created by 이태영 on 2023/09/22.
//

import Foundation
import RxSwift

final class AccountUseCase {
    private let accountRepository: AccountRepositoryType
    private let myInformationRepository: MyInformationRepositoryType

    init(
        accountRepository: AccountRepositoryType = AccountRepository(),
        myInformationRepository: MyInformationRepositoryType = MyInformationRepository()
    ) {
        self.accountRepository = accountRepository
        self.myInformationRepository = myInformationRepository
    }
}

// MARK: - Public Interface
extension AccountUseCase: AccountUseCaseType {
    func modifyPassword(current: String, new: String ) -> Completable {
        return accountRepository.modifyPassword(current: current, new: new)
    }
    
    func withdraw() -> Completable {
        myInformationRepository.removeMyInformation()
        return accountRepository.withdraw()
    }
    
    func findId(with email: String) -> Observable<Bool> {
        return accountRepository.findId(with: email)
    }
    
    func findPassword(id: String, email: String) -> Observable<Bool> {
        return accountRepository.findPassword(id: id, email: email)
    }
}
