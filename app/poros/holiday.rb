class Holiday
  attr_reader :date, :name

  def initialize(repo_data)
    @date = repo_data[:date]
    @name = repo_data[:name]
  end
end