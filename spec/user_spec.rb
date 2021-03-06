require 'user.rb'

describe User do
  let(:user) {
    described_class.create(email: 'test@example.com', password: 'password123',
    name: 'testdude', handle: 'testhandle')
  }
  let(:user_params) {
    { email: 'test@example.com', password: 'password123', name: 'testdude',
    handle: 'testhandle' }
  }

  describe '.all' do
    it 'returns an array of all users' do
      expect(described_class.all).to be_an Array
    end
  end

  describe '.create' do
    it 'creates a new user' do
      expect(user.id).not_to be_nil
    end

    it 'hashes the password using BCrypt' do
      expect(BCrypt::Password).to receive(:create).with('password123')
      described_class.create(user_params)
    end
  end

  describe '.find' do
    it 'finds a user by ID' do
      expect(described_class.find(user.id).email).to eq user.email
    end

    it 'returns nil when there is no ID given' do
      expect(described_class.find(nil)).to eq nil
    end
  end

  describe '.email_taken?' do
    it 'returns false if the email is not taken' do
      expect(described_class.email_taken?("unused_email@random.com")).to eq false
    end
    it 'returns true if the email is taken' do
      expect(described_class.email_taken?("doglover@yomail.com")).to eq true
    end
  end

  describe '.handle_taken?' do
    it 'returns false if the handle is not taken' do
      expect(described_class.handle_taken?("enlightened33")).to eq false
    end
    it 'returns true if the handle is taken' do
      expect(described_class.handle_taken?("catman505")).to eq true
    end
  end

  describe '.authenticate' do
    it 'returns a user given a correct email and password' do
      user
      authenticated_user = User.authenticate('test@example.com', 'password123')
      expect(authenticated_user.id).to eq user.id
    end

    it 'returns nil given an incorrect email address' do
      expect(User.authenticate('wrongemail@wrong.com', 'password123')).to be_nil
    end

    it 'returns nil given an incorrect password address' do
      expect(User.authenticate('test@example.com', 'wordpass321')).to be_nil
    end
  end
end
