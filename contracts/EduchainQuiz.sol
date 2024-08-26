// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./QuestProvider.sol";  // QuestProvider 컨트랙트를 가져옵니다.

contract EduchainQuiz {

    QuestProvider public questProvider;  // QuestProvider 컨트랙트 인스턴스

    // 사용자 정보 구조체
    struct User {
        uint correctAnswers;  // 맞힌 문제의 수
        bool hasCompletedQuiz;  // 문제를 모두 풀었는지 여부
        bool hasLiked;  // 좋아요를 눌렀는지 여부
    }

    mapping(address => User) public users;  // 각 사용자의 정보를 저장하는 매핑

    // 생성자에서 QuestProvider 인스턴스를 생성
    constructor() {
        questProvider = new QuestProvider();
    }

    // 문제를 맞혔다고 기록하고 좋아요 여부를 설정하는 함수
    function submitQuizResult(uint _questId, uint _correctAnswers, bool _hasCompletedQuiz, bool _like) public {
        users[msg.sender].correctAnswers = _correctAnswers;
        users[msg.sender].hasCompletedQuiz = _hasCompletedQuiz;
        users[msg.sender].hasLiked = _like;

        // 퀘스트 상태 업데이트
        questProvider.updateQuestStatus(msg.sender, _questId, _like);
    }

    // 사용자 정보를 가져오는 함수
    function getUserInfo(address _user) public view returns (uint, bool, bool) {
        User memory user = users[_user];
        return (user.correctAnswers, user.hasCompletedQuiz, user.hasLiked);
    }

    // 특정 퀘스트에 대한 좋아요 상태를 반환하는 함수
    function hasLikedQuest(uint _questId) public view returns (bool) {
        return questProvider.hasLikedQuest(msg.sender, _questId);
    }

    // 특정 퀘스트의 조회수 및 좋아요 수를 반환하는 함수
    function getQuestStats(uint _questId) public view returns (bool, bool) {
        bool isSubmitted = questProvider.isQuestSubmitted(msg.sender, _questId);
        bool hasLiked = questProvider.hasLikedQuest(msg.sender, _questId);
        return (isSubmitted, hasLiked);
    }

    // 특정 퀘스트의 제공자 주소를 반환하는 함수
    function getQuestProviderAddress(uint _questId) public view returns (address) {
        return questProvider.getProvider(msg.sender, _questId);
    }
}
