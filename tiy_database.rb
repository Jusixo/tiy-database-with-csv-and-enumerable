require 'csv'

class Person
  attr_reader "name", "phone", "address", "position", "salary", "slack", "github"

  def initialize(name, phone, address, position, salary, slack, github)
    @name = name
    @phone = phone
    @address = address
    @position = position
    @salary = salary
    @slack = slack
    @github = github
  end
end

class DataBase
  def initialize
    @profiles = []
    CSV.foreach("employees.csv", headers: true) do |row|
      name = row["name"]
      phone = row["phone"]
      address = row["address"]
      position = row["postion"]
      salary = row["salary"]
      slack = row["slack"]
      github = row["github"]

      person = Person.new(name, phone, address, position, salary, slack, github)

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
      phone = gets.chomp

      puts "What is your address?"
      address = gets.chomp

      puts "What is your position?"
      position = gets.chomp

      puts "What is your salary?"
      salary = gets.chomp

      puts "what is your Slack Account?"
      slack = gets.chomp

      puts "what is your Git Account?"
      github = gets.chomp

      account = Person.new(name, phone, address, position, salary, slack, github)

      @profiles << account

      employee_save
    end
  end

  def search_person
    puts "Please type in persons name. "
    search_person = gets.chomp
    found_account = @profiles.find { |person| person.name.include?(search_person) || person.slack == search_person || person.github == search_person }
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
        csv << [person.name, person.phone, person.address, person.position, person.salary, person.slack, person.github]
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
    @profiles.select { |person| person.position.include?("Instructor") }.map { |person| person.salary }.sum
  end

  def director_salary
    @profiles.select { |person| person.position.include?("Campus Director") }.map { |person| person.salary }.sum
  end

  def total_instructor
    @profiles.select { |person| person.position.include? ("Intructor") }.count
  end

  def total_director
    @profiles.select { |person| person.position.include?("Campus Director") }.count
  end

  def total_students
    @profiles.select { |person| person.position.include?("Student") }.count
  end

  data = DataBase.new

  loop do
    puts 'Would you like to Add (A), Search (S) or Delete (D) a person or view the Report (E) from the Iron Yard Database?'
    selected = gets.chomp.upcase

    data.add_person if selected == 'A'

    data.search_person if selected == 'S'

    data.delete_person if selected == 'D'

    data.employee_report if selected == 'E'
  end
end
