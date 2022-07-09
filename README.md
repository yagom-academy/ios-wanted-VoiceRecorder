# Voice Recorder

- 녹음파일을 다루는 앱입니다.
- 아이폰, 세로 모드만 지원하는 앱입니다.
- Firebase-FireStorage 를 활용해 서버에 저장합니다.

## 팀원
우지|Cobugi
:-:|:-:
<img width="300px" src="https://avatars.githubusercontent.com/u/95316662?v=4" alt="우지" />|<img width="300px" src="https://avatars.githubusercontent.com/u/79654264?v=4" alt="Cobugi" />

## 결과
첫 번째 화면|두 번째 화면|세 번째 화면
:-:|:-:|:-:
![]()|![]()|![]()

## 라이브러리
- FirebaseStorage - SPM

## 기능
- ### 첫 번째 화면 `ListViewController`
    - 파일명은 "현재 위치_생성된 시간을 초 단위까지"로 표시
     - 내비게이션 바 우상단에 + 버튼을 탭하면 녹음 화면(두 번째 화면)으로 이동
    - 파일을 탭하면 파일의 재생 화면(세 번째 화면)으로 이동
    - 새로운 녹음이 종료되면 녹음 리스트 업데이트
    - 리스트에서 스와이프 동작으로 파일 삭제

- ### 두 번째 화면 `RecordViewController`
    - 녹음 시간을 표시하고 시작, 종료할 수 있음
    - 진행되고 있는 녹음의 파형
    - 녹음 진행/정지 버튼
    - 완료된 녹음의 재생/일시정지 버튼
    - 녹음된 전체시간 표시
    - 5초 전/후의 상태로 이동하는 버튼
    - 녹음 시 특정 주파수 영역 이하만 통과하도록 cutoff frequency를 설정
    - View를 닫는 상황에 대한 예외 처리
    - 녹음 종료 시 해당 파일을 같은 화면에서 재생
    - 녹음 중, 재생 중, 정지 등 각 상태에 따라 버튼을 숨김 또는 비활성화
    - 녹음 전에는 재생, 정지 등과 관련한 버튼이 없어야 한다.
    - 녹음 후에는 다시 녹음 버튼을 눌러 현재 오디오 파일을 대체
    - 녹음이 종료되면 FireStorage 로 업로드
- ### 세 번째 화면 `PlayViewController`
    - 재생 시 현재 위치를 파형으로 표시
    - 5초 전/후로 이동하는 기능
    - 볼륨 조절 슬라이드를 넣어 볼륨을 조절
    - 음의 pitch값을 이용해 다음과 같은 목소리로 변형해 재생
        - 일반 목소리 (원본)
        - 아기 목소리
        - 할아버지 목소리

## 진행과정
- ### 우지
    - 
    - 
    - 
- ### Cobugi
    - 
    - 
    - 


## 회고
- ### 우지
    - git에 대한 이해도가 부족했었는데 이번 기회에 여러가지를 접해볼 수 있어서 좋았다.
    - 오디오플레이어에서 오디오엔진으로 변경하는 과정을 통해 기능 명세서를 명확하게 파악하고 프로젝트를 진행하는 것이 중요하다고 다시 한번 체감했다.
    - 혼자 프로젝트를 진행한 적만 있어 코드컨벤션, 커밋메세지 등 처음 접하는 부분들이 많았는데 같은 프로젝트를 협업하는데 좋은 가이드가 됐던 프로젝트였다.
    - 공식문서 활용 및 Swift 문법 등 아직까지 부족한 부분이 많다고 느꼈으며 프로젝트 중 부족한 점들은 주어진 시간내 보완해 다음 프로젝트에 적용하는 것이 단기적인 목표이다.
- ### Cobugi
    - 
    - 
    - 
