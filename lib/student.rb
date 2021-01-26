class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * from STUDENTS"
    stu = DB[:conn].execute(sql)
    stu.map do |data|
      self.new_from_db(data)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = "SELECT * FROM students WHERE name = ?"
    DB[:conn].execute(sql, name).collect do |row|
      self.new_from_db(row)
    end.first
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9"
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12"
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT 1"
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end.first
  end

  def self.first_X_students_in_grade_10(first_students)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    array = DB[:conn].execute(sql, first_students)
    array[0..first_students].collect do |row|
      self.new_from_db(row)
    end
  end

  def self.all_students_in_grade_X(grade_num)
    sql = "SELECT * FROM students WHERE grade = ?"
    DB[:conn].execute(sql, grade_num)
  end
end
