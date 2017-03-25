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
    puts "(a) Add a profile (s) Search for a profile (d) Delete a profile (e) View employee report "
    initial = gets.chomp
  end

  def add_person
    puts "What is your name?"
    name = gets.chomp
    if @profiles.find {|person| person.name == name}
      puts "This profile already exists"
    else
      puts "What is your phone number?"
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
  end

  def search_person
    puts "Please type in persons name. "
    search_person = gets.chomp
    found_account = @profiles.find { |person| person.name.include?(search_person) || person.slack_account == search_person || person.github_account == search_person }
    if found_account
      puts "This is #{found_account.name}'s information.
       \nName: #{found_account.name}
       \nPhone: #{found_account.phone}
       \nAddress: #{found_account.address}
       \nPosition: #{found_account.position}
       \nSalary: #{found_account.salary}
       \nSlack Account: #{found_account.slack}
       \nGitHub Account: #{found_account.github}"
    else
      puts "#{search_person} is not in our system.\n"
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

  def employee_report
    employee_accounts = @profiles.sort_by {|person| person.name }
    employee_accounts.each do |person|
    end
    puts "The Iron Yard Database Reports: "
    puts "The total salary for the Instructors is #{instructor_salary}"
    puts "The total salary for the Campus Director is #{director_salary}"
    puts "The total number of students at the Iron Yard is #{total_students}"
    puts "The total number of Instructor at the Iron Yard is #{total_instructor}"
    puts "The total number of Campus Directors at the Iron Yard is #{total_director}"

  end

  def instructor_salary
    @profiles.select { |person| person.position.include?("Instructor")}.map { |person| person.salary }.sum
  end

  def director_salary
    @profiles.select { |person| person.position.include?("Campus Director") }.map {|person| person.salary }.sum
  end

  def total_instructor
    @profiles.select { |person| person.position.include?("Intructor")}.count
  end

  def total_director
    @profiles.select { |person| person.position.include?("Campus Director")}.count
  end

  def total_students
    @profiles.select { |person| person.position.include?("Student")}.count
  end

  def start
    choice = ()
    while choice "!="
      choice = initial_question
      if choice == "a"
        add_person
      elsif choice == "s"
        search_person
      elsif choice == "d"
        delete_person
      elsif choice == "e"
        employee_report
      else
        puts "program closing, information saved 👋🏼"
      end
    end
  end
end

DataBase.new.start
