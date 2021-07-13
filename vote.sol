pragma solidity >=0.7.0 <0.9.0;

contract Vote{
    struct Voter{
        uint weight;
        bool voted;
        address delegate;
        uint index; // the index for the proposal
    }

    struct Proposal {
        bytes32 name;
        uint count;
    }

    Proposal[] public Proposals;
    address public Creator;
    mapping(address => Voter) public Voters;

    constructor(bytes32[] memory ProposalNames){
        Creator = msg.sender;
        Voters[msg.sender].weight = 1;
        // todo:
        // remove the duplicate item from ProposalNames
        for(uint i=0; i<ProposalNames.length; i++){
            Proposals.push(Proposal({
                name: ProposalNames[i],
                count: 0
            }));
        }
    }

    function authorizeTo(address voter) public {
        require(
            msg.sender == Creator,
            'Only the contract creator can authorize some people to vote'
        );
        require(Voters[voter].weight == 0, 'the current voter had been authorized');
        Voters[voter].weight = 1;
    }

    function delegate(address to) public {
        Voter storage sender = Voters[msg.sender];
        require(!sender.voted, 'You have voted');
        require(to != msg.sender, 'Self-delegate is not supported');

        while(Voters[to].delegate != address(0)){
            to = Voters[to].delegate;
            
        }
    }
}