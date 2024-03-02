## 캠페인 스마트 계약
### 변수
| 항목                | 유형      | 설명                                                    |
| ------------------- | --------- | ------------------------------------------------------- |
| manager             | address   | 이 캠페인을 관리하는 사람의 주소                        |
| minimumContribution | uint      | 참여자 또는 '승인자'로 간주되기 위해 필요한 최소 기부액 |
| approver            | address[] | 기부금을 제공한 모든 사람들의 주소 목록                 |
| requests            | Request[] | 관리자가 생성한 요청 목록                               |

### 함수
| 항목            | 설명                                                                                    |
| --------------- | --------------------------------------------------------------------------------------- |
| Campaign        | 최소 기여금과 소유자를 설정하는 생성자 함수                                             |
| contribute      | 누군가 캠페인에 기부하여 '승인자'가 되려고 할 때 호출되는 함수                          |
| createRequest   | 관리자가 새로운 '지출 요청'을 생성하기 위해 호출되는 함수                               |
| approveRequest  | 각 기여자가 지출 요청을 승인하기 위해 호출되는 함수                                     |
| finalizeRequest | 요청에 충분한 승인이 있으면 관리자가 이 함수를 호출하여 돈을 공급 업체에 전송할 수 있음 |

### 요청 구조체
| 항목          | 유형    | 설명                        |
| ------------- | ------- | --------------------------- |
| 설명          | string  | 요청의 목적                 |
| 금액          | uint    | 전송할 이더                |
| 수취인        | address | 돈을 받는 사람             |
| 완료 여부     | bool    | 요청이 완료되었는지 여부   |
| 승인 목록     | mapping | 누가 투표했는지 추적       |
| 승인 수       | uint    | 승인 수를 추적             |