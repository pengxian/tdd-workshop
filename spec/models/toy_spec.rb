require 'rails_helper'

RSpec.describe Toy, type: :model do
  before :each do
    @toy = build :toy
  end

  subject { @toy }

  it { should respond_to :title }
  it { should respond_to :price }
  it { should respond_to :published }
  it { should respond_to :user_id }
  it { should be_valid }

  it { should validate_presence_of :title }
  it { should validate_presence_of :price }
  it { should validate_presence_of :user_id }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }

  it { should belong_to :user }

  describe '#filter_by_title to search toys match title keywords' do
    before :each do
      @toy1 = create :toy, title: 'haha'
      @toy2 = create :toy, title: 'hehe'
      @toy3 = create :toy, title: 'heihei'
      @toy4 = create :toy, title: 'Ruby On Rails'
    end

    it 'search toys with keyword' do
      expect(Toy.filter_by_title('Ruby')).to match_array([@toy4])
    end
  end

  describe '#above_or_equal_to_price' do
    before :each do
      @toy1 = create :toy, price: 1.0
      @toy2 = create :toy, price: 2.0
      @toy3 = create :toy, price: 2.01
      @toy4 = create :toy, price: 100
    end

    it 'search toys above or equal price' do
      expect(Toy.above_or_equal_to_price(2.0)).to match_array([@toy2, @toy3, @toy4])
    end
  end

  describe '#below_or_equal_to_price' do
    before :each do
      @toy1 = create :toy, price: 1.0
      @toy2 = create :toy, price: 2.0
      @toy3 = create :toy, price: 2.01
      @toy4 = create :toy, price: 100
    end

    it 'search toys below or equal price' do
      expect(Toy.below_or_equal_to_price(2.1)).to match_array([@toy1, @toy2, @toy3])
    end
  end

  describe '#recent' do
    before :each do
      @toy1 = create :toy, price: 1.0
      @toy2 = create :toy, price: 2.0
      @toy3 = create :toy, price: 2.01
      @toy4 = create :toy, price: 100
    end

    it 'search toys order by recent create' do
      expect(Toy.recent).to eq [@toy4, @toy3, @toy2, @toy1]
    end
  end

  describe '#param search' do
    before :each do
      @toy1 = create :toy, title: 'haha', price: 1.0
      @toy2 = create :toy, title: 'hehe', price: 2.0
      @toy3 = create :toy, title: 'heihei', price: 2.5
      @toy4 = create :toy, title: 'xixi', price: 100
    end

    it 'param keyword,minprice,order ' do
      expect(Toy.search(title: 'he', min_price: 1.9, order: 'desc')).to eq [@toy3, @toy2]
    end

    it 'param maxprice,keyword' do
      expect(Toy.search(title: 'h', max_price: 2.0)).to eq [@toy1, @toy2]
    end

    it 'param empty' do
      expect(Toy.search).to eq [@toy1, @toy2, @toy3, @toy4]
    end

    it 'no search result' do
      expect(Toy.search(title: 'ruby')).to eq []
    end

  end
end
