require 'csv'

class Person
  attr_reader "name", "phone_number", "address", "position", "salary", "slack_account", "github_account"

  def initialize(name, phone_number, address, position, salary, slack_account, github_account)
    @name = name
    @phone_number = phone_number
    @address = address
    @position = position
    @salary = salary
    @slack_account = slack_account
    @github_account = github_account
  end
end

class DataBase
  def initialize
    @profiles = []
    CSV.foreach("employees.csv", headers: true) do |row|
      name = row["name"]
      phone_number = row["phone_number"]
      address = row["address"]
      position = row["postion"]
      salary = row["salary"]
      slack_account = row["slack_account"]
      github_account = row["github_account"]

      person = Person.new(name, phone_number, address, position, salary, slack_account, github_account)

      @profiles << person
    end
  end

  def initial_question
    puts "(a) Add a profile (s) Search for a profile (d) Delete a profile "
    initial = gets.chomp
  end

  def add_person
    puts "What is your name?"
    name = gets.chomp

    puts "What is your phone_number?"
    phone_number = gets.chomp

    puts "What is your address?"
    address = gets.chomp

    puts "What is your position?"
    position = gets.chomp

    puts "What is your salary?"
    salary = gets.chomp.to_i

    puts "what is your Slack Account?"
    slack_account = gets.chomp

    puts "what is your Git Account?"
    github_account = gets.chomp

    account = Person.new(name, phone_number, address, position, salary, slack_account, github_account)
    puts "The name for this account is #{account.name} Phone number is #{account.phone_number} you addrress is #{account.address} your current position is #{account.position} your current salary is #{account.salary} yours Slack Account is #{account.slack_account} and your Github Account is #{account.github_account}"

    @profiles << account

    employee_save
  end

  def search_person
    print "Please type in persons name. "
    search_name = gets.chomp
    found_profile = @profiles.find {|person| person.name == search_name}
    if found_profile
      puts "name: #{found_profile.name}, phone number: #{found_profile.phone_number}, address: #{found_profile.address}, position: #{found_profile.position}, current salary: #{found_profile.salary}, slack_account: #{found_profile.slack_account}, github_account: #{found_profile.github_account} "
    else
      puts "Profile not found"
    end
  end

  def delete_person
    print "Please type in persons name. "
    delete_name = gets.chomp
    delete_profile = @profiles.delete_if { |person| person.name == delete_name}
    if delete_profile
      puts "profile deleted"
    else
      puts "profile not found"
    end
  end

  def employee_save
    CSV.open("employees.csv", "w") do |csv|
      csv << ["name", "phone_number", "address", "position", "salary", "slack_account", "github_account"]
      @profiles.each do |person|
        csv << [person.name, person.phone_number, person.address, person.position, person.salary, person.slack_account, person.github_account]
      end
    end
  end

  def start
    choice = ()
    while choice != ""
      choice = initial_question
      if choice == "a"
        add_person
      elsif choice == "s"
        search_person
      elsif choice == "d"
        delete_person
      else
        puts "progam closing, information saved 👋🏼"
      end
    end
  end
end

DataBase.new.start
