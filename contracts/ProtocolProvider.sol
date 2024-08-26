// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ERC-20 인터페이스를 가져옵니다.
interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract ProtocolProvider {
    
    // Edu 토큰 공급량을 관리하는 구조체
    struct UserStatus {
        uint createdQuests;
        uint solvedQuests;
        uint balance;
    }

    // 사용자 주소를 기준으로 상태를 저장
    mapping(address => UserStatus) public userStatuses;
    address public eduContract;  // Edu ERC-20 토큰 컨트랙트 주소

    // 이벤트 정의
    event EduSupplied(address indexed user, uint amount);
    event QuestCreated(address indexed user, uint createdQuests);
    event QuestSolved(address indexed user, uint solvedQuests);

    // Edu 컨트랙트 주소 설정 (초기 설정 또는 이후 변경 가능)
    constructor(address _eduContract) {
        eduContract = _eduContract;
    }

    // 사용자 퀘스트 생성 시 호출되는 함수
    function createQuest(address _user) external {
        userStatuses[_user].createdQuests += 1;
        emit QuestCreated(_user, userStatuses[_user].createdQuests);
    }

    // 사용자 퀘스트 해결 시 호출되는 함수
    function solveQuest(address _user) external {
        userStatuses[_user].solvedQuests += 1;
        emit QuestSolved(_user, userStatuses[_user].solvedQuests);
    }

    // 유저에게 Edu를 공급하는 함수 (풀에서 보상 지급)
    function supplyEdu(address _user, uint _amount) external {
        require(_amount > 0, "Supply amount must be greater than 0");

        // Edu 토큰 컨트랙트 인스턴스
        IERC20 eduToken = IERC20(eduContract);

        // 컨트랙트에 충분한 Edu 토큰이 있는지 확인
        require(eduToken.balanceOf(address(this)) >= _amount, "Insufficient Edu tokens in contract");

        // 유저에게 Edu 토큰을 전송
        require(eduToken.transfer(_user, _amount), "Edu token transfer failed");

        userStatuses[_user].balance += _amount;

        emit EduSupplied(_user, _amount);
    }

    // 유저의 Edu 잔고를 조회하는 함수
    function getBalance(address _user) external view returns (uint) {
        return userStatuses[_user].balance;
    }

    // 유저가 생성한 퀘스트 수를 조회하는 함수
    function getCreatedQuests(address _user) external view returns (uint) {
        return userStatuses[_user].createdQuests;
    }

    // 유저가 해결한 퀘스트 수를 조회하는 함수
    function getSolvedQuests(address _user) external view returns (uint) {
        return userStatuses[_user].solvedQuests;
    }
}
