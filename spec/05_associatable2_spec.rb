require 'active_record_lite/05_associatable2'

describe "Associatable" do
  before(:each) { DBConnection.reset }
  after(:each) { DBConnection.reset }

  before(:all) do
    class Cat < SQLObject
      my_attr_accessible :id, :name, :owner_id
      my_attr_accessor :id, :name, :owner_id

      belongs_to :human, :foreign_key => :owner_id
    end

    class Human < SQLObject
      self.table_name = "humans"

      my_attr_accessible :id, :fname, :lname, :house_id
      my_attr_accessor :id, :fname, :lname, :house_id

      has_many :cats, :foreign_key => :owner_id
      belongs_to :house
    end

    class House < SQLObject
      my_attr_accessible :id, :address, :house_id
      my_attr_accessor :id, :address, :house_id

      has_many :humans
    end
  end

  describe "::assoc_options" do
    it "defaults to empty hash" do
      class TempClass < SQLObject
      end

      expect(TempClass.assoc_options).to eq({})
    end

    it "stores `belongs_to` options" do
      cat_assoc_options = Cat.assoc_options
      human_options = cat_assoc_options[:human]

      expect(human_options).to be_instance_of(BelongsToOptions)
      expect(human_options.foreign_key).to eq(:owner_id)
      expect(human_options.class_name).to eq("Human")
      expect(human_options.primary_key).to eq(:id)
    end

    it "stores options separately for each class" do
      expect(Cat.assoc_options).to have_key(:human)
      expect(Human.assoc_options).to_not have_key(:human)

      expect(Human.assoc_options).to have_key(:house)
      expect(Cat.assoc_options).to_not have_key(:house)
    end
  end

  describe "#has_one_through" do
    before(:all) do
      class Cat

        has_one_through :home, :human, :house
      end
    end

    let(:cat) { Cat.find(1) }

    it "adds getter method" do
      expect(cat).to respond_to(:home)
    end

    it "fetches associated `home` for a `Cat`" do
      house = cat.home

      expect(house).to be_instance_of(House)
      expect(house.address).to eq("26th and Guerrero")
    end
  end
end
