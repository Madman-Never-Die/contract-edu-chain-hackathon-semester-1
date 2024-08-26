// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract QuestProvider {

    // 퀘스트 제출 상태를 담는 구조체
    struct QuestStatus {
        address provider;  // 퀘스트 제공자의 주소
        bool isSubmitted;  // 퀘스트가 제출되었는지 여부
        bool hasLiked;  // 좋아요를 눌렀는지 여부
    }

    // 사용자 주소 및 퀘스트 ID를 기준으로 퀘스트 상태를 저장
    mapping(address => mapping(uint => QuestStatus)) public questStatuses;

    // 퀘스트 제출 시 발생하는 이벤트
    event QuestSubmitted(address indexed provider, address indexed user, uint indexed questId);

    // 중앙 서버(Nest 서버)에서 퀘스트 검증이 완료된 후 호출될 함수
    function updateQuestStatus(address _user, uint _questId, bool _hasLiked) external {
        QuestStatus storage status = questStatuses[_user][_questId];

        // 퀘스트 제공자 주소 저장
        status.provider = msg.sender;

        // 퀘스트 제출 상태를 업데이트
        status.isSubmitted = true;
        status.hasLiked = _hasLiked;

        // 이벤트 발행
        emit QuestSubmitted(msg.sender, _user, _questId);
    }

    // 특정 사용자의 특정 퀘스트 제출 상태를 반환
    function isQuestSubmitted(address _user, uint _questId) external view returns (bool) {
        return questStatuses[_user][_questId].isSubmitted;
    }

    // 특정 사용자가 특정 퀘스트에서 좋아요를 눌렀는지 여부를 반환
    function hasLikedQuest(address _user, uint _questId) external view returns (bool) {
        return questStatuses[_user][_questId].hasLiked;
    }

    // 특정 사용자가 특정 퀘스트의 제공자 주소를 반환
    function getProvider(address _user, uint _questId) external view returns (address) {
        return questStatuses[_user][_questId].provider;
    }

    // 특정 사용자의 특정 퀘스트의 완료 여부와 좋아요 상태를 반환
    function getUserInfo(address _user, uint _questId) external view returns (bool, bool) {
        QuestStatus memory status = questStatuses[_user][_questId];
        return (status.isSubmitted, status.hasLiked);
    }

    // 특정 퀘스트 ID로 접근하여 유저 주소와 제출 여부를 반환하는 함수
    function getQuestSubmissionInfo(uint _questId, address _user) external view returns (address, uint, bool) {
        QuestStatus memory status = questStatuses[_user][_questId];
        return (_user, _questId, status.isSubmitted);
    }
}
