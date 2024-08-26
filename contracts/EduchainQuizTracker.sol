// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./EduchainQuiz.sol";  // EduchainQuiz 컨트랙트를 가져옵니다.

contract EduchainQuizTracker {

    EduchainQuiz public quizContract;  // EduchainQuiz 컨트랙트 인스턴스

    uint public totalViews;  // 퀴즈 조회수
    uint public totalLikes;  // 좋아요 수

    mapping(address => bool) public hasCountedView;  // 조회수를 이미 올렸는지 여부를 추적하는 매핑
    mapping(address => bool) public hasCountedLike;  // 좋아요 수를 이미 올렸는지 여부를 추적하는 매핑

    constructor(address _quizContractAddress) {
        quizContract = EduchainQuiz(_quizContractAddress);  // EduchainQuiz 컨트랙트 주소를 받아서 인스턴스를 생성
    }

    // 퀴즈 조회수와 좋아요 수를 업데이트하는 함수
    function updateStats() public {
        (, bool hasCompletedQuiz, bool hasLiked) = quizContract.getUserInfo(msg.sender);

        // 사용자가 퀴즈를 완료했는지 확인하고 조회수를 올립니다.
        if (hasCompletedQuiz && !hasCountedView[msg.sender]) {
            totalViews++;
            hasCountedView[msg.sender] = true;
        }

        // 사용자가 좋아요를 눌렀는지 확인하고 좋아요 수를 올립니다.
        if (hasLiked && !hasCountedLike[msg.sender]) {
            totalLikes++;
            hasCountedLike[msg.sender] = true;
        }
    }

    // 조회수와 좋아요 수를 반환하는 함수
    function getStats() public view returns (uint, uint) {
        return (totalViews, totalLikes);
    }
}
