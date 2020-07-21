class Team
  attr_accessor :name
  attr_reader :id

   def self.all
    DBCONN.execute("SELECT * FROM teams").map do |team_hash|
      new(team_hash)
    end
  end

  def self.find_by_id(id)
    new(DBCONN.execute("SELECT * FROM #{table_name} WHERE id=#{id}")[0])
  end

  def initialize(attributes={})
    attributes.each do |k, v|
      send("#{k}=", v)
    end
  end

  def players
    Player.find_by_team_id(id)
  end

  def save
    sql = <<-SQL
    INSERT INTO #{self.class.table_name} (#{column_names_for_insert.join(', ')})
    VALUES (#{column_names_for_insert.map{|n| "'#{send(n)}'" }.join(', ')});
    SQL

    DBCONN.execute(sql)
    id = DBCONN.execute("SELECT last_insert_rowid() FROM #{self.class.table_name}")[0][0]
    self
  end

   def self.create(attributes={})
    t = new(attributes)
    t.save
  end

  def self.column_names
    sql = "pragma table_info(#{self.name.downcase}s)"

    table_info = DBCONN.execute(sql).map do |row|
      row["name"]
    end.compact
  end

  private

  attr_writer :id

  def self.column_names
    sql = "pragma table_info(#{table_name})"

    table_info = DBCONN.execute(sql).map do |row|
      row["name"]
    end.compact
  end

  def column_names_for_insert
    sql = "pragma table_info(#{self.class.table_name})"

    table_info = DBCONN.execute(sql).map do |row|
      row["name"] if send(row["name"]) != nil
    end.compact
  end

  def self.table_name
    "#{name.downcase}s"
  end

end
