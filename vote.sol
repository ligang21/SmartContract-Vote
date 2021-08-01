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
        require(Voters[voter].weight == 0, 'The current voter had been authorized');
        Voters[voter].weight = 1;
    }

    function delegate(address to) public {
        Voter memory sender = Voters[msg.sender];
        require(sender.weight == 1, 'You have not been authorized to vote');
        require(!sender.voted, 'You have voted');
        require(to != msg.sender, 'Self-delegate is not supported');
        require(Voters[to].weight == 1, 'The agent is not authorized');

        while(Voters[to].delegate != address(0)){
            to = Voters[to].delegate;
            require(to != msg.sender, "Delegate in loop is not supported");
        }

        sender.voted = true;
        sender.delegate = to;
        if(Voters[to].voted){
            Proposals[Voters[to].index].count += sender.weight;
        } else {
            Voters[to].weight += sender.weight;
        }
    }

    function vote(uint proposal) public {
        Voter memory sender = Voters[msg.sender];
        require(sender.weight == 1, 'You are not permitted to vote');
        require(!sender.voted, 'Already voted');

        sender.voted = true;
        sender.index = proposal;
        Proposals[proposal].count += sender.weight;
    }

    function getWinningProposal() public view returns (uint winningProposal){
        uint winningVoteCount = 0;
        for(uint i=0; i < Proposals.length; i++){
            if(Proposals[i].count > winningVoteCount) {
                winningVoteCount = Proposals[i].count;
                winningProposal = i;
            }
        }
    }
}