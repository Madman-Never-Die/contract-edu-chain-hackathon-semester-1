// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EduchainQuiz {

    // 사용자 정보 구조체
    struct User {
        uint correctAnswers;  // 맞힌 문제의 수
        bool hasCompletedQuiz;  // 문제를 모두 풀었는지 여부
        uint likes;  // 좋아요 수
    }

    mapping(address => User) public users;  // 각 사용자의 정보를 저장하는 매핑

    // 문제를 맞혔다고 기록하는 함수
    function submitQuizResult(uint _correctAnswers, bool _hasCompletedQuiz) public {
        users[msg.sender].correctAnswers = _correctAnswers;
        users[msg.sender].hasCompletedQuiz = _hasCompletedQuiz;
    }

    // 좋아요를 추가하는 함수
    function like() public {
        users[msg.sender].likes += 1;
    }

    // 사용자 정보를 가져오는 함수
    function getUserInfo(address _user) public view returns (uint, bool, uint) {
        User memory user = users[_user];
        return (user.correctAnswers, user.hasCompletedQuiz, user.likes);
    }
}
