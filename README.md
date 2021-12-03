# SanTa🏔🎅🏻

<div align="center">
    
<img alt="icon" width=250 src="https://i.imgur.com/EXaJv8j.png">

📆 **2021.10.25 ~ 2021.12.03**
    
[Wiki Documentation](https://github.com/boostcampwm-2021/iOS02-SanTa/wiki)&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;[Issue](https://github.com/boostcampwm-2021/iOS02-SanTa/issues)
    
<br>
    
[![Swift](https://img.shields.io/badge/swift-v5.5-orange?logo=swift)](https://developer.apple.com/kr/swift/)
[![Xcode](https://img.shields.io/badge/xcode-v13.0-blue?logo=xcode)](https://developer.apple.com/kr/xcode/)
    
[![GitHub Open Issues](https://img.shields.io/github/issues-raw/boostcampwm-2021/iOS02-SanTa?color=green)](https://github.com/boostcampwm-2021/iOS02-SanTa/issues)
[![GitHub Closed Issues](https://img.shields.io/github/issues-closed-raw/boostcampwm-2021/iOS02-SanTa?color=red)](https://github.com/boostcampwm-2021/iOS02-SanTa/issues?q=is%3Aissue+is%3Aclosed)
[![GitHub Open PR](https://img.shields.io/github/issues-pr-raw/boostcampwm-2021/iOS02-SanTa?color=green)](https://github.com/boostcampwm-2021/iOS02-SanTa/pulls)
[![GitHub Closed PR](https://img.shields.io/github/issues-pr-closed-raw/boostcampwm-2021/iOS02-SanTa?color=red)](https://github.com/boostcampwm-2021/iOS02-SanTa/pulls?q=is%3Apr+is%3Aclosed)


[[배포주소]](https://appho.st/d/UE8O6Cui) [[데모영상]](https://www.youtube.com/watch?v=Y6Lspfrv8Rw)
    
</div>

# 🧑🏻‍💻 개발자

<div align="center">

|S009 | S026 | S030 | S035 |
|:-:|:-:|:-:|:-:|
|<img width=120 src="https://i.imgur.com/dmEpnrI.jpg">|<img width=120 src="https://i.imgur.com/U79BYAq.jpg">|<img width=120 src="https://i.imgur.com/QuUEEB7.jpg">|<img width=120 src="https://user-images.githubusercontent.com/87363980/144178853-20c2e38e-7979-4e4d-83e6-e2f34186b8d5.png">|
|[김민창](https://github.com/MINRYUL)|[신재웅](https://github.com/sustainable-git)|[오창민](https://github.com/lou0124)|[윤지원](https://github.com/yjwyjwyjw)|
    
</div>
<br>   
    
# 🎯 개발 환경

- Xcode 13.0+
- Swift 5.5+
- iOS 15.0+
 
<br> 

# 📝 프로젝트 목표

```
1. 올라 앱보다 더 많은 산 데이터를 제공
2. 뛰어난 접근성 제공
3. Apple FrameWork를 활용하여 개발
4. 스토리보드를 사용하지 않고 개발
```

<br>

# 💬 프로젝트 소개 

### ✅ 대한민국 산의 정보를 확인해 보세요

지도, 산 목록 화면을 통해 산을 확인할 수 있으며 각각의 산에 대한 세부 정보도 확인할 수 있습니다.

### ✅ 등산 기록을 측정해 보세요

등산 측정을 시작하면 등산에 대한 여러 정보를 측정할 수 있습니다. 또한 등산 중에 찍은 사진기록도 저장이 되며 1km를 걸을 때마다 음성 안내도 지원하고 있습니다.

### ✅ 기록된 데이터를 확인해 보세요

등산 기록들을 한눈에 파악할 수 있습니다. 또한 기록된 등산 기록을 클릭하여 훨씬 더 세부적인 정보를 확인할 수 있습니다.

### ✅ 손쉬운 사용을 경험해 보세요

손쉬운 사용에서 더 큰 텍스트와 VoiceOver를 지원합니다.


<br>

# 👀 미리 보기 

<div align="left">

|<img width=240 src="https://user-images.githubusercontent.com/81242125/144183471-18e390e1-3978-4b62-9429-9b66da1bb931.gif">|<img width=240 src="https://i.imgur.com/xM53TsN.png">|<img width=240 src="https://i.imgur.com/Yvl3g1W.png">|
|:-:|:-:|:-:|
|`지도화면`|`측정화면`|`기록화면`|
|<img width=240 src="https://user-images.githubusercontent.com/81242125/144184332-1d5516cc-3502-48a9-9bc4-4d9655d1bcb4.gif">|<img width=240 src="https://i.imgur.com/wXFhKRY.gif">|<img width=240 src="https://i.imgur.com/048efRN.png">|
|`개별기록화면`|`산 목록화면`|`설정화면`| 

</div>
<br>


# ⚙️ 기능

```
- 지도에서 산 위치 확인
- 목록에서 산 이름으로 검색
- 산 상세 정보 확인
- 이동 기록 측정
- 측정중 촬영한 사진 경로에 표시
- 측정한 기록 상세 정보 확인
- 보이스오버, 다이나믹 타입 적용으로 접근성 증가
- 사용자가 임의로 장소(산) 추가 가능
- 1km 마다 음성안내 기능
```

<br>

# 🏛 아키텍처 

![](https://i.imgur.com/cWt3FUh.png)

<br>

# 📂 폴더구조

```swift 
 SanTa
    ﾤ Resources
    ﾤ Application
    ﾤ Persistences
    ﾤ Entities
    ﾤ Utility
    ﾤ Scenes
        ﾤ MapScene
        ﾤ MountainAddingScene
        ﾤ RecordingScene
        ﾤ RecordingTitleScene
        ﾤ RecordingPhotoScene
        ﾤ ResultScene
        ﾤ ResultDetailScene
        ﾤ ResultDetailImagesScene
        ﾤ ResultDetailThumbnailScene
        ﾤ MountainListScene
        ﾤ MountainDetailScene
        ﾤ SettingsScene
```

<br>

# 🖼 프레임워크

<img width=720 src="https://i.imgur.com/PtGeSr0.jpg">

<br>

# 🎖 도전 사항

```
- StoryBoard 없이 코드로만 뷰 구성
- MVVM-C 패턴 도입
- Clean Architecture
- MapKit, CoreLocation, CoreMotion 
- Combine
- DiffableDataSource, Compositional Layout
- CoreData
- GeoCoding
```


# ➕ 기타

<details>
    <summary> 위키 </summary>
    
- [기획서](https://github.com/boostcampwm-2021/iOS02-SanTa/wiki/%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-%EA%B8%B0%ED%9A%8D%EC%84%9C)
- [백로그 v1.0](https://docs.google.com/spreadsheets/d/1knT2-uQZDPz_AqpKvzfX5WR0OSWgWKeMTkDxKiYlCSQ/edit#gid=0)
- [백로그 v2.0](https://docs.google.com/spreadsheets/d/1dg-yESySimbF7rKb7PhkNopBnSWy8--Ss5LfAvjjDHk/edit#gid=0)
- [그라운드 룰](https://github.com/boostcampwm-2021/iOS02/wiki/%EA%B7%B8%EB%9D%BC%EC%9A%B4%EB%93%9C-%EB%A3%B0)
- [컨벤션](https://github.com/boostcampwm-2021/iOS02/wiki/%EA%B7%9C%EC%B9%99)
    
</details>
    
<br>
    
<details>
    <summary> 트러블 슈팅 </summary>

- [트러블 슈팅](https://github.com/boostcampwm-2021/iOS02-SanTa/wiki/트러블-슈팅)
- [Controller 메모리 해제 문제](https://github.com/boostcampwm-2021/iOS02-SanTa/wiki/RecordingViewController-%EB%A9%94%EB%AA%A8%EB%A6%AC-%ED%95%B4%EC%A0%9C-%EB%AC%B8%EC%A0%9C)
- [Pull Request Strategy](https://github.com/boostcampwm-2021/iOS02-SanTa/wiki/Pull-Request-Strategy)
- [산 목록 검색 문제](https://github.com/boostcampwm-2021/iOS02-SanTa/wiki/%EC%82%B0-%EB%AA%A9%EB%A1%9D-%EA%B2%80%EC%83%89)
- [권한 유도 중 Controller 오류](https://github.com/boostcampwm-2021/iOS02-SanTa/wiki/%EC%95%B1-%EA%B6%8C%ED%95%9C-%EC%9C%A0%EB%8F%84-%EC%A4%91-Controller-%EC%98%A4%EB%A5%98)
- [Sticky Header 버그 해결과정](https://github.com/boostcampwm-2021/iOS02-SanTa/wiki/Navigation-Bar와-Sticky-Header)
- [Git으로 Bug 찾기](https://github.com/boostcampwm-2021/iOS02-SanTa/wiki/Git으로-Bug-찾기)
- [Delegate와 순환참조](https://github.com/boostcampwm-2021/iOS02-SanTa/wiki/Delegate와-순환참조)
</details>

<br>

<details>
    <summary> 학습 </summary>
    
- [위치 정보 요청](https://github.com/boostcampwm-2021/iOS02-SanTa/wiki/위치-정보-요청하기)
- [GeoCoding](https://github.com/boostcampwm-2021/iOS02-SanTa/wiki/Google-GeoCoding을-이용하여-산-이름으로-(위도,경도)-찾기)
- [Custom Push/Pop Transition](https://github.com/boostcampwm-2021/iOS02-SanTa/wiki/Custom-Push-Pop-Transition)
- [CoreData](https://github.com/boostcampwm-2021/iOS02-SanTa/wiki/CoreData)
- [UIFeedbackGenerator](https://github.com/boostcampwm-2021/iOS02-SanTa/wiki/UIFeedbackGenerator)
- [VoiceOver](https://github.com/boostcampwm-2021/iOS02-SanTa/wiki/VoiceOver)
</details>
