# AssignmentTimeline 

## 構成
- TCA + Layered Architecture (3 layers)
  - TCAは経験ないがReduxに近いため、キャッチアップしながら導入
  - LayerはPresentation, Domain, Dataで分けた
- SwiftUI + UIKit
  - ハイブリッドにした際に破綻しないか試すため
  - 実務ではUIKit onlyなので、そちらの方がスピードが出るため併用
  - RootとLoginがSwiftUI、TimelineがUIKit
  - UIKitではViewStoreをVMのように扱った
- Combine
  - TCAと相性が良いため
  - URLSessionを利用するため
- SPM
  - 今回は全てSPMで入れられたのでSPM only
- Bitrise
  - 途中でテストが壊れていないか確認のため利用

## ライブラリ
- ComposableArchitecture
  - 上記の理由
- SDWebImage
  - 今回Alamofireを利用しなかったので、AlamofireImageではなくこちらにした
- KeychainAccess
  - Keychainのコードを省略するため
- SwiftLint
  - フォーマットミスの軽減
  - autoformatを活用するため

## 動作確認方法

- Xcode 12.5.1で確認
- AssignmentTimeline.xcodeprojを開いてビルド
