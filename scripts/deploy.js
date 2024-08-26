const hre = require("hardhat");

async function deployQuestProvider() {
  const QuestProviderFactory = await hre.ethers.getContractFactory(
    "QuestProvider"
  );
  const QuestProvider = await QuestProviderFactory.deploy();
  await QuestProvider.waitForDeployment(); // 트랜잭션이 완료될 때까지 대기
  console.log(
    `QuestProvider 컨트랙트가 ${QuestProvider.address}에 배포되었습니다.`
  ); // address 사용
  return QuestProvider.address; // 올바른 주소 반환
}

async function deployEduchainQuiz(questProviderAddress) {
  const EduchainQuizFactory = await hre.ethers.getContractFactory(
    "EduchainQuiz"
  );

  // questProviderAddress는 생성자 인자로 전달
  const EduchainQuiz = await EduchainQuizFactory.deploy(questProviderAddress);
  await EduchainQuiz.waitForDeployment(); // 트랜잭션이 완료될 때까지 대기
  console.log(
    `EduchainQuiz 컨트랙트가 ${EduchainQuiz.address}에 배포되었습니다.`
  ); // address 사용
}

async function main() {
  const questProviderAddress = await deployQuestProvider(); // QuestProvider 주소 가져오기
  await deployEduchainQuiz(questProviderAddress); // EduchainQuiz 배포 시 주소를 전달
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
