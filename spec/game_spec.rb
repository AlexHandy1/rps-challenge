require 'game'

describe Game do
  let (:player){double :player}
  let (:playerClass){double :Player, new: player }

  subject { Game.new playerClass }

  it 'can create a single player' do
    expect(subject.player_1).to be player
  end

  it 'can create a second player' do
    expect(subject.player_2).to be player
  end

  it 'can access the turn of player 1' do
    allow(subject.player_1).to receive(:take_a_turn).and_return("Rock")
    allow(subject.player_1).to receive(:check_turn).and_return("Rock")
    subject.player_1.take_a_turn "Rock"
    expect(subject.player_1.check_turn).to eq "Rock"
  end

  it "can check that there is a winner" do
    allow(player).to receive(:winner?).and_return true
    expect(subject.winner?).to be_truthy
  end

  it "can check for duplicate turns" do
    allow(subject.player_1).to receive(:random_selection).and_return("Rock")
    allow(subject.player_2).to receive(:random_selection).and_return("Rock")
    allow(subject.player_1).to receive(:check_turn).and_return("Rock")
    allow(subject.player_2).to receive(:check_turn).and_return("Rock")
    allow(subject.player_1).to receive(:wins).and_return(nil)
    allow(subject.player_2).to receive(:wins).and_return(nil)
    allow(subject.player_1).to receive(:winner?).and_return(nil)
    allow(subject.player_2).to receive(:winner?).and_return(nil)

    subject.player_1.random_selection
    subject.player_2.random_selection
    expect(subject.process_turn).to eq "Go again"
  end

  xit 'can process the result of multiple turns' do
    allow(subject.player_1).to receive(:random_selection).and_return("Rock")
     allow(subject.player_2).to receive(:random_selection).and_return("Paper")
    allow(subject.player_1).to receive(:check_turn).and_return("Rock")
    allow(subject.player_2).to receive(:check_turn).and_return("Paper")
    allow(subject.player_2).to receive(:add_round_win).and_return(1)
    allow(subject.player_2).to receive(:add_round_win).and_return(1)
    allow(subject.player_1).to receive(:wins).and_call_original
    allow(subject.player_2).to receive(:wins).and_call_original

    subject.player_1.random_selection
    subject.player_2.random_selection
    subject.process_turn
    subject.player_1.random_selection
    subject.player_2.random_selection
    subject.process_turn
    expect(subject.process_turn).to eq "Game already won"
  end
end








