const hre = require("hardhat");

async function deployQuestProvider() {
  const QuestProviderFactory = await hre.ethers.getContractFactory(
    "QuestProvider"
  );
  const QuestProvider = await QuestProviderFactory.deploy();
  await QuestProvider.waitForDeployment();
  console.log(
    `QuestProvider 컨트랙트가 ${await QuestProvider.getAddress()}에 배포되었습니다.`
  );
  return QuestProvider.getAddress();
}

async function deployEduchainQuiz(questProviderAddress) {
  const EduchainQuizFactory = await hre.ethers.getContractFactory(
    "EduchainQuiz"
  );
  const EduchainQuiz = await EduchainQuizFactory.deploy(questProviderAddress);
  await EduchainQuiz.waitForDeployment();
  console.log(
    `EduchainQuiz 컨트랙트가 ${await EduchainQuiz.getAddress()}에 배포되었습니다.`
  );
}

async function main() {
  try {
    const questProviderAddress = await deployQuestProvider();
    if (!questProviderAddress) {
      throw new Error("QuestProvider 주소를 가져오는 데 실패했습니다.");
    }
    await deployEduchainQuiz(questProviderAddress);
  } catch (error) {
    console.error("배포 중 오류 발생:", error);
    process.exitCode = 1;
  }
}

main().catch((error) => {
  console.error("스크립트 실행 중 예기치 않은 오류 발생:", error);
  process.exitCode = 1;
});
