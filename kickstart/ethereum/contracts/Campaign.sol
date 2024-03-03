pragma solidity ^0.4.17;

contract CampaignFactory {
    address[] public deployedCampaigns;

    // 캠페인을 생성하는 함수
    function createCampaign(uint minimum) public {
        // 새 캠페인 생성 및 배열에 추가
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }

    // 생성된 모든 캠페인 주소를 반환하는 함수
    function getDeployedCampaigns() public view returns (address[]) {
        return deployedCampaigns;
    }
}

contract Campaign {
    struct Request {
        string description;         // 요청 설명
        uint value;                 // 전송할 이더량
        address recipient;          // 수취인 주소
        bool complete;              // 요청 완료 여부
        uint approvalCount;         // 승인 횟수
        mapping(address => bool) approvals; // 승인 목록
    }

    Request[] public requests;      // 요청 배열
    address public manager;         // 매니저 주소
    uint public minimumContribution; // 최소 기부액
    mapping(address => bool) public approvers; // 참여자 목록
    uint public approversCount;     // 참여자 수

    modifier restricted() {
        // 매니저만 실행 가능
        require(msg.sender == manager);
        _;
    }

    // 캠페인 생성자
    function Campaign(uint minimum, address creator) public {
        manager = creator;
        minimumContribution = minimum;
    }

    // 기부 함수
    function contribute() public payable {
        // 최소 기부액 이상의 이더를 기부해야 함
        require(msg.value > minimumContribution);

        // 기부자 목록에 추가 및 수량 증가
        approvers[msg.sender] = true;
        approversCount++;
    }

    // 지출 요청 생성 함수
    function createRequest(string description, uint value, address recipient) public restricted {
        // 요청 생성 및 배열에 추가
        Request memory newRequest = Request({
           description: description,
           value: value,
           recipient: recipient,
           complete: false,
           approvalCount: 0
        });

        requests.push(newRequest);
    }

    // 요청 승인 함수
    function approveRequest(uint index) public {
        Request storage request = requests[index];

        // 참여자만 승인 가능하며 이미 승인한 요청은 중복 승인 불가
        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);

        // 승인 처리 및 승인 횟수 증가
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    // 요청 완료 처리 함수
    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];

        // 반대로 투표한 참여자의 수가 참여자의 절반을 초과해야 함
        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);

        // 수령인에게 이더 전송 및 완료 상태로 변경
        request.recipient.transfer(request.value);
        request.complete = true;
    }
}