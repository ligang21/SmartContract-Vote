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
    address public creator;

    constructor(bytes32[] memory ProposalNames){
        creator = msg.sender;
    }
}