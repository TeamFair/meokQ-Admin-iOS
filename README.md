
## DI - Swinject

`AppInject` 클래스 내부에서 `DependencyInjector`를 사용하여 의존성 주입을 관리합니다.(injector 변수로 정의)

1. `AppInject` 클래스의 `init()` 에서 `Container()`를 생성하여 의존성 컨테이너를 초기화합니다.
2.  `injector`에 의존성 컨테이너를 주입하고, `injector`를 통해 각각의 어셈블리를 설정합니다. (데이터, 도메인, 뷰 모델, 뷰 등의 의존성을 주입)

<br>

## Clean Architecture

### 각 레이어의 역할

`Data` 계층 : 서버, 로컬 저장소로부터 데이터를 가져오고, DTO를 VO(Entity)로 변환하는 역할을 합니다.

`Domain` 계층 : 비즈니스 로직을 담당하는 역할을 합니다.

`Presentaion` 계층 : UI를 제공하고 사용자와 시스템 간의 상호작용을 담당하는 역할을 합니다.

<br>

### 구성요소간의 관계

`View` : `ViewModel` =  1:1

`ViewModel` : `UseCase` =  1:N 

`UseCase` : `Repository` =  1:N 

`Repository` : `DataSource` = 1:N

<br>

### 구성요소의 구조

📁 **View, ViewModel**

> MainView
> 
> - Quest
>     - QuestMain
>     - QuestDetail
> - Manage
>     - ManageMain
>     - ManageDetail
      
<br>

📁 **Usecase**

> - GetQuest
> - PostQuest
> - DeleteQuest
> - GetChallenge
> - PatchChallenge
> - DeleteChallenge

<br>

📁 **Repository, Datasource**

> - Quest
> - Challenge
> - Image

