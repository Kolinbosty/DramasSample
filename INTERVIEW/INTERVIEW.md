## LineTV Interview

#### 需求

(1) 請設計一套基於 OAuth 2 授權機制的 API client 架構，其中「收藏」、「觀看紀錄」等部分 API 會需要會員的授權，並且盡可能的減少使用者需重新登入的機會：

- access token 的有效期限為一個星期
- refresh token 的有效期為一年

(2) 請利用 cache 機制來優化「戲劇列表」以及「個人頁面」的使用者體驗架構與流程，並準備簡圖來解釋 memory/disk cache 的實作架構，包含 control flow & dependency 的關係

- 「戲劇列表」顯示各戲劇簡易相關資料列表的頁面，包含海報圖片、戲劇名稱、戲劇分類等資訊。
- 頁面上有顯示上千個戲劇，並且預計每天有三到五次不定時的更新
- 當戲劇上線時，使用者可以在第一時間更新到最新上線戲劇資訊
- 「個人頁面」顯示收藏與觀看紀錄等資訊
- 收藏與觀看紀錄會依照使用者的操作，而更新回伺服器
- 會員資料可能從其他使用者的裝置上變更

可以簡化成兩個頁面

A. 戲劇列表

- 更新次數不頻繁，資料量龐大
- 當 Server 資料更新使用者要及時更新

B. 個人資料頁面

- 有更改後上傳到 Server
- 不同裝置間，都可以其他裝置的更改 (即時？ 目前想到的是用 slient push，先不考慮即時)


#### Cache 機制 (圖片一樣，不過我個人喜歡交給第三方)

A. Default 機制

- 預設行為 (useProtocolCachePolicy)
- 系統會處理 Last-Modified 與 If-Modified-Since ＆ 304 (Not Modified)
  - 不過這邊實際用 URLSession 在 Client 端會收到 200，無法辨認是否為用 Cache，通常無此需求，真的要用方法 B (or delegate?)
- 如果需要，可以使用 URLSessionConfiguration 設定 URLCache 大小位置，並且可以手動管理清除


B. Cache 自幹

- 預設的 Cache 機制關掉 (reloadIgnoringLocalCacheData)
- 機制同 A 不過都自己做，管 Memory 用 NSCache，Disk 用 CoreDate or FileManager 之類的
