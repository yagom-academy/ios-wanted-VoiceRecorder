## 목차
1. [프로젝트 소개](https://github.com/Kim-Junhwan/ios-wanted-VoiceRecorder/edit/main/README.md#%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-%EC%86%8C%EA%B0%9C)
2. [팀원 소개](https://github.com/Kim-Junhwan/ios-wanted-VoiceRecorder/edit/main/README.md#%ED%8C%80%EC%9B%90-%EC%86%8C%EA%B0%9C)
3. [구현 화면](https://github.com/Kim-Junhwan/ios-wanted-VoiceRecorder/edit/main/README.md#%EA%B5%AC%ED%98%84-%ED%99%94%EB%A9%B4)
4. [담당 파트](https://github.com/Kim-Junhwan/ios-wanted-VoiceRecorder/edit/main/README.md#%EB%8B%B4%EB%8B%B9-%ED%8C%8C%ED%8A%B8)
5. [노션링크](https://broken-redcurrant-2ce.notion.site/dc233bcf874c4ab191fe50244a0bacad)


</br></br>
# 1. 프로젝트 소개
- 녹음파일을 다루는 앱입니다.
    - 녹음 및 재생, 목소리 필터, 녹음 주파수 조절 기능 지원
- 아이폰, 세로 모드만 지원하는 앱입니다.
- `Firebase-FireStorage` 를 활용해 서버에 저장합니다.

</br></br>
# 2. 팀원 소개

| monica | 콩벌레 |
|:---:|:---:|
|![스크린샷 2022-07-05 오후 12 39 28](https://user-images.githubusercontent.com/66169740/177245353-2c07bcd1-ffee-4d2d-923b-f1867aba606d.png)|![스크린샷 2022-07-05 오후 12 39 49](https://user-images.githubusercontent.com/66169740/177245382-ce7471c7-0401-4eb9-97de-1b59bef22d7f.png)|


</br></br>
# 3. 구현 화면

| 첫번째 화면 - 녹음 List View| 두번째 화면 - 녹음 및 확인 뷰 | 세번째 화면 - 재생 뷰 |
|:---:|:---:|:---:|
|![화면_기록_2022-07-09_오후_3_29_25_AdobeExpress](https://user-images.githubusercontent.com/66169740/178095558-90b06648-8589-4dfb-81c5-30dd7df14c61.gif)|![화면_기록_2022-07-09_오후_3_29_25_AdobeExpress (4)](https://user-images.githubusercontent.com/66169740/178095665-01baadd9-7a9d-4675-854b-dce30baf8b0f.gif)|![화면_기록_2022-07-09_오후_3_29_25_AdobeExpress (3)](https://user-images.githubusercontent.com/66169740/178095703-35212a18-6d47-4806-874e-1275ce6d3dd7.gif)|


</br></br>
# 4. 담당 파트
## 첫번째 화면 - 녹음 List View
### monica
- 내비게이션 바 우상단에 + 버튼을 탭하면 녹음 화면(두 번째 화면)으로 이동
- 파일을 탭하면 파일의 재생 화면(세 번째 화면)으로 이동
- 화면을 아래로 드래그해서 새로고침을 하면 녹음 리스트 업데이트
### 콩벌레
- Firebase프로젝트를 생성하고, FireStorage 생성
- 파일명은 “현재 위치 _ 생성된 시간을 초 단위까지” 로 표시
- 새로운 녹음이 종료되면 녹음 리스트가 업데이트
- 리스트에서 스와이프 동작을 통해 파일을 삭제
## 두번째 화면 - 녹음 및 확인 뷰
### monica
- `UIBezierPath`를 이용하여 진행되고 있는 녹음의 파형을 나타내는 UI 구현
- `AVAudioRecorder`를 이용하여 녹음 진행/정지 기능 구현
- 녹음된 전체시간 표시
- `AVAudioSession`의 `sampleRate`를 이용하여 녹음 시 특정 주파수 영역 이하만 통과하도록 cutoff frequency를 설정
### 콩벌레
- 재생시 5초 전, 5초 후의 상태로 이동
- View를 닫는 상황에 대한 예외 처리
- 녹음 종료 시 해당 파일을 같은 화면에서 재생
- 녹음 중, 재생 중, 정지 등 각 상태에 따라 버튼을 숨기거나 비활성화
- 녹음이 종료되면 `FireStorage`로 업로드
## 세번째 화면 - 재생 뷰
### monica
- 재생되는 음원의 파형을 나타내는 UI 구현
- 재생 시 현재 위치를 그래프에 표시
- 현재 재생시간 표시
### 콩벌레
- 5초 전, 후로 이동하는 기능
- 볼륨 조절 슬라이드를 넣어 볼륨을 조절
- 음의 pitch값을 이용해 목소리변형 재생

