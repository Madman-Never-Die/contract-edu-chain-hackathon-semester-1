// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./QuestProvider.sol";  // QuestProvider 컨트랙트를 가져옵니다.

contract QuestTracker {

    QuestProvider public questContract;  // QuestProvider 컨트랙트 인스턴스

    uint public totalViews;  // 퀘스트 조회수
    uint public totalLikes;  // 좋아요 수

    // 퀘스트 제공자별로 사용자의 조회수 및 좋아요 수를 관리하는 매핑
    mapping(address => mapping(uint => bool)) public hasCountedView;  // 조회수를 이미 올렸는지 여부를 추적하는 매핑
    mapping(address => mapping(uint => bool)) public hasCountedLike;  // 좋아요 수를 이미 올렸는지 여부를 추적하는 매핑

    constructor(address _questContractAddress) {
        questContract = QuestProvider(_questContractAddress);  // QuestProvider 컨트랙트 주소를 받아서 인스턴스를 생성
    }

    // 퀘스트 조회수와 좋아요 수를 업데이트하는 함수
    function updateStats(uint _questId) public {
        address provider = questContract.getProvider(msg.sender, _questId); // 퀘스트 제공자의 주소를 가져옴
        (bool hasCompletedQuest, bool hasLiked) = questContract.getUserInfo(msg.sender, _questId);

        // 사용자가 퀘스트를 완료했는지 확인하고 조회수를 올립니다.
        if (hasCompletedQuest && !hasCountedView[provider][_questId]) {
            totalViews++;
            hasCountedView[provider][_questId] = true;
        }

        // 사용자가 좋아요를 눌렀는지 확인하고 좋아요 수를 올립니다.
        if (hasLiked && !hasCountedLike[provider][_questId]) {
            totalLikes++;
            hasCountedLike[provider][_questId] = true;
        }
    }

    // 조회수와 좋아요 수를 반환하는 함수
    function getStats() public view returns (uint, uint) {
        return (totalViews, totalLikes);
    }
}
