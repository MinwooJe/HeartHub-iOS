//
//  NicknameEmailInputViewModel.swift
//  HeartHub
//
//  Created by 이태영 on 2023/10/03.
//

import RxCocoa
import RxSwift

final class NicknameEmailInputViewModel: ViewModelType {
    struct Input {
        let nickname: Driver<String>
        let tapCheckNicknameDuplication: Driver<Void>
        let email: Driver<String>
        let tapVerificationCodeSend: Driver<Void>
        let verificationCode: Driver<String>
        let tapVerificationCodeCheck: Driver<Void>
        let tapNext: Driver<Void>
    }
    
    struct Output {
        let verifiedNickname: Driver<String>
        let checkingDuplicationNickname: Driver<Bool>
        let isCheckNicknameDuplicationEnable: Driver<Bool>
        let nicknameDescription: Driver<String>
        let nicknameDescriptionColor: Driver<SignUpColor>
        let isVerificationCodeSendEnable: Driver<Bool>
        let emailDescription: Driver<String>
        let emailDescriptionColor: Driver<SignUpColor>
        let isInputVerificationCodeEnable: Driver<Bool>
        let sendingVerificationCode: Driver<Bool>
        let isCheckVerificationCodeEnable: Driver<Bool>
        let verificationCodeCheckDescription: Driver<String>
        let verificationCodeCheckDescriptionColor: Driver<SignUpColor>
        let isNextEnable: Driver<Bool>
        let toNext: Driver<Void>
    }
    
    private let coordinator: SignUpCoordinatable
    private let myInformationUseCase: MyInformationUseCaseType
    private let accountUseCase: AccountUseCaseType
    private let authenticationUseCase: AuthenticationUseCaseType
    private let signUpUseCase: SignUpUseCaseType
    
    init(
        coordinator: SignUpCoordinatable,
        myInformationUseCase: MyInformationUseCaseType,
        accountUseCase: AccountUseCaseType,
        authenticationUseCase: AuthenticationUseCaseType,
        signUpUseCase: SignUpUseCaseType
    ) {
        self.coordinator = coordinator
        self.myInformationUseCase = myInformationUseCase
        self.accountUseCase = accountUseCase
        self.authenticationUseCase = authenticationUseCase
        self.signUpUseCase = signUpUseCase
    }
}

// MARK: Public Interface
extension NicknameEmailInputViewModel {
    func transform(_ input: Input) -> Output {
        let verifiedNickname = input.nickname
            .distinctUntilChanged()
            .scan("") { (previous, new) in
                return self.myInformationUseCase.verifyNickname(new) ? new : previous
            }
        
        let isAvailableNickname = input.tapCheckNicknameDuplication.withLatestFrom(verifiedNickname)
            .flatMap { nickname in
                return self.myInformationUseCase.checkDuplicationNickname(nickname)
                    .asDriver(onErrorJustReturn: false)
            }
        
        let checkingDuplicationNickname = Driver.from([
            input.tapCheckNicknameDuplication.map { _ in true },
            isAvailableNickname.map { _ in false }
        ])
            .merge()
            .distinctUntilChanged()
        
        let isCheckNicknameDuplicationEnable = Driver.from([
            verifiedNickname.map { !$0.isEmpty },
            checkingDuplicationNickname.map { _ in false }
        ])
            .merge()
            .distinctUntilChanged()
        
        let nicknameDescription = Driver.from([
            isAvailableNickname.map { $0 == true ? "사용 가능한 닉네임입니다." : "중복된 닉네임입니다." },
            verifiedNickname.map { _ in "영문/숫자 구성" }
        ])
            .merge()
            .distinctUntilChanged()
        
        let nicknameDescriptionColor = Driver.from([
            isAvailableNickname.map { $0 == true ? SignUpColor.green : SignUpColor.red },
            verifiedNickname.map { _ in SignUpColor.gray }
        ])
            .merge()
            .distinctUntilChanged()
        
        let isVerifiedEmail = input.email
            .distinctUntilChanged()
            .map { self.accountUseCase.verifyEmailFormat($0) }
        
        let emailDescription = isVerifiedEmail
            .skip(1)
            .map { $0 == true ? "인증요청 후 인증번호를 입력해주세요." : "이메일 형식이 올바르지 않습니다." }
            .distinctUntilChanged()
        
        let emailDescriptionColor = isVerifiedEmail
            .map { $0 == true ? SignUpColor.green : SignUpColor.red }
            .distinctUntilChanged()
        
        let isVerificationCodeSendEnable = Driver.from([
            isVerifiedEmail,
            input.tapVerificationCodeSend.map { _ in false }
        ])
            .merge()
            .distinctUntilChanged()
        
        let isInputVerificationCodeEnable = input.tapVerificationCodeSend.withLatestFrom(input.email)
            .flatMap { email in
                return self.authenticationUseCase.sendVerificationCode(to: email)
                    .asDriver(onErrorJustReturn: false)
            }
            .do { isSuccess in
                let message = isSuccess == true ? "메일로 인증번호가 전송되었습니다." : "실패했습니다."
                self.coordinator.showAlert(message: message)
            }
        
        let sendingVerificationCode = Driver.from([
            input.tapVerificationCodeSend.map { _ in true },
            isInputVerificationCodeEnable.map { _ in false }
        ])
            .merge()
            .distinctUntilChanged()
        
        let isCheckVerificationCodeEnable = Driver.from([
            input.verificationCode.map { !$0.isEmpty }
        ])
            .merge()
            .distinctUntilChanged()
        
        let isVerificationCodeMatched = input.tapVerificationCodeCheck.withLatestFrom(input.verificationCode)
            .map { self.authenticationUseCase.checkVerificationCode(with: $0) }
        
        let verificationCodeCheckDescription = isVerificationCodeMatched
            .map { $0 == true ? "인증 완료" : "번호가 일치하지 않습니다." }
            .distinctUntilChanged()
        
        let verificationCodeCheckDescriptionColor = isVerificationCodeMatched
            .map { $0 == true ? SignUpColor.green : SignUpColor.red }
            .distinctUntilChanged()
        
        let isNextEnable = Driver.combineLatest(
            isAvailableNickname,
            isVerificationCodeMatched) {
                $0 && $1
            }
            .startWith(false)
        
        let nicknameEmail = Driver.combineLatest(input.nickname, input.email) {
            (nickname: $0, email: $1)
        }
            
        let toNext = input.tapNext.withLatestFrom(nicknameEmail)
            .do { self.signUpUseCase.upsertNickname($0.nickname) }
            .do { self.signUpUseCase.upsertEmail($0.email) }
            .do { _ in self.coordinator.toTermAgree() }
            .map { _ in }
        
        return Output(
            verifiedNickname: verifiedNickname,
            checkingDuplicationNickname: checkingDuplicationNickname,
            isCheckNicknameDuplicationEnable: isCheckNicknameDuplicationEnable,
            nicknameDescription: nicknameDescription,
            nicknameDescriptionColor: nicknameDescriptionColor,
            isVerificationCodeSendEnable: isVerificationCodeSendEnable,
            emailDescription: emailDescription,
            emailDescriptionColor: emailDescriptionColor,
            isInputVerificationCodeEnable: isInputVerificationCodeEnable,
            sendingVerificationCode: sendingVerificationCode,
            isCheckVerificationCodeEnable: isCheckVerificationCodeEnable,
            verificationCodeCheckDescription: verificationCodeCheckDescription,
            verificationCodeCheckDescriptionColor: verificationCodeCheckDescriptionColor,
            isNextEnable: isNextEnable,
            toNext: toNext
        )
    }
}