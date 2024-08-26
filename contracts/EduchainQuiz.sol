// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./QuestProvider.sol";

contract EduchainQuiz {

    QuestProvider public questProvider;

    struct User {
        uint correctAnswers;
        bool hasCompletedQuiz;
        bool hasLiked;
    }

    mapping(address => User) public users;

    // 생성자를 수정하여 QuestProvider 주소를 매개변수로 받습니다.
    constructor(address _questProviderAddress) {
        questProvider = QuestProvider(_questProviderAddress);
    }

    function submitQuizResult(uint _questId, uint _correctAnswers, bool _hasCompletedQuiz, bool _like) public {
        users[msg.sender].correctAnswers = _correctAnswers;
        users[msg.sender].hasCompletedQuiz = _hasCompletedQuiz;
        users[msg.sender].hasLiked = _like;

        questProvider.updateQuestStatus(msg.sender, _questId, _like);
    }

    function getUserInfo(address _user) public view returns (uint, bool, bool) {
        User memory user = users[_user];
        return (user.correctAnswers, user.hasCompletedQuiz, user.hasLiked);
    }

    function hasLikedQuest(uint _questId) public view returns (bool) {
        return questProvider.hasLikedQuest(msg.sender, _questId);
    }

    function getQuestStats(uint _questId) public view returns (bool, bool) {
        bool isSubmitted = questProvider.isQuestSubmitted(msg.sender, _questId);
        bool hasLiked = questProvider.hasLikedQuest(msg.sender, _questId);
        return (isSubmitted, hasLiked);
    }

    function getQuestProviderAddress(uint _questId) public view returns (address) {
        return questProvider.getProvider(msg.sender, _questId);
    }
}