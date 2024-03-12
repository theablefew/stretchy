context 'has_one' do
  let(:profile_model) {
    class Profile < Stretchy::Record
      attribute :bio, :string
      attribute :user_id, :keyword

      validates_presence_of :bio
    end
    Profile
  }

  let(:user_model) {
    class User < Stretchy::Record
      attribute :name, :keyword
      attribute :email, :string
      # attribute :profile_id, :keyword

      has_one :profile

      validates_presence_of :name
    end
    User
  }

  let(:user) { user_model.create name: 'John Doe', email: 'johny@doe.com' }

  let(:profile) { profile_model.create bio: 'A user bio', user_id: user.id }

  before(:each) do
    profile_model
  end

  it 'responds_to has_one' do
    expect(user_model).to respond_to(:has_one)
  end

  it 'reflects the association' do
    user = user_model.create name: 'John Doe', email: 'john.doe@example.com'
    expect(user.association_reflection(:profile)).to be_a Stretchy::Relation
  end

  context 'configuration' do
    context 'defaults' do
      let(:options) { user_model.class_variable_get(:@@_association_options) }
      it 'sets the foreign key' do
        expect(options[:profile][:foreign_key]).to eq('user_id')
      end
      it 'sets the primary key' do
        expect(options[:profile][:primary_key]).to eq('id')
      end
      it 'sets the class name' do
        expect(options[:profile][:class_name]).to eq(:profile)
      end
    end
  end

  context 'it assigns the association' do
    it 'with object' do
      user = user_model.create name: 'John Doe', email: 'john.doe@example.com', profile: profile
      expect(user.profile).to eq(profile)
    end

    it 'with association=' do
      user = user_model.create name: 'John Doe', email: 'john.doe@example.com'
      user.profile = profile
      expect(user.profile).to eq(profile)
    end

    context 'saves' do
      it 'updates the association' do
        user = user_model.create name: 'John Doe', email: 'john.doe@example.com'
        user.profile = profile
        user.save
        expect(profile.user_id).to eq(user.id)
      end
    end
  end
end