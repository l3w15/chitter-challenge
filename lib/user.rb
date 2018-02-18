require 'pg'
require 'bcrypt'

class User

  attr_reader :id, :email, :password, :name, :handle

  def initialize(id, email, password, name, handle)
    @id = id
    @email = email
    @password = password
    @name = name
    @handle = handle
  end

  def self.all
    result = DatabaseConnection.query("SELECT * FROM users")
    result.map { |user| User.new(user['id'], user['email'], user['name'],
      user['handle'], user['password']) }
  end

  def self.create(user)
    # encrypt the plantext password, options[:password]
    password = BCrypt::Password.create(user[:password])
    result = DatabaseConnection.query("INSERT INTO users (email, name, handle, password)
                              VALUES ('#{user[:email]}',
                                      '#{user[:name]}',
                                      '#{user[:handle]}',
                                      '#{password}')
                              RETURNING id, email, name, handle, password;")
    User.new(result[0]['id'], result[0]['email'], result[0]['name'], result[0]['handle'], result[0]['password'])
  end

  def self.find(id)
    return nil unless id
    result = DatabaseConnection.query("SELECT * FROM users WHERE id = '#{id}'")
    User.new(result[0]['id'], result[0]['email'], result[0]['name'], result[0]['handle'], result[0]['password'])
  end

end