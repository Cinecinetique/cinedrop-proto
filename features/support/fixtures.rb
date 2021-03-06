module Fixtures
  def load_fixture
  	fixtures_folder = File.join(Rails.root, 'test', 'fixtures')
  	fixtures = Dir[File.join(fixtures_folder, '*.yml')].map {|f| File.basename(f, '.yml') }
  	ActiveRecord::FixtureSet.create_fixtures(fixtures_folder, fixtures)
  end
end
