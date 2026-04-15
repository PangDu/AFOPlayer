# AFOPlaylist MVVM 约定（与主工程 P2 装配）

## 分层

- **View**：`AFOPLMainController`、Cell、编辑菜单等，只做布局、目标动作、绑定回调。
- **ViewModel**：`AFOPLMainListViewModel` + `AFOPLMainListViewState`（列表状态）；路由通过 `routePerformBlock` / `AFORoutingPerformWithParameters`。
- **Routing 数据**：协议 `AFOPLPlaylistRoutingDataSource`（由 `AFOPLMainManager` 实现）。
- **Service / Model**：`AFOPLMainManager`、`AFOPLCorresponding`、`AFOPLSQLiteManager` 等。

## 新增模块时

1. 为屏幕新增 `*ViewModel`，输入为 user action / 生命周期钩子，输出为 state 与 `routePerformBlock`。
2. 路由参数勿在 VC 内散落拼字典，统一走 ViewModel 或小型 `*RouterAdapter`。
3. 单测：依赖注入 `routingDataSource` 桩，使用 `routePerformBlock` 断言。

## 主工程装配

- 使用 `AFOAppCompositionRoot`（`AFOPlayer`）创建 `AFOAppTabBarController` 并调用 `AFOAddControllerModel`；新增 Tab 时扩展 `controllerArray` 或后续改为显式工厂注册。
