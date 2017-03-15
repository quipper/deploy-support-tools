require "spec_helper"

describe 'Show apps', type: :feature do
  before do
    Timecop.travel Time.utc(2014, 8, 6)

    apps = YAML.load_file(Rails.root.join('spec', 'fixtures', 'apps.yml'))
    Rails.cache.write 'apps', apps.map { |app| app['name'] }
    apps.each do |app|
      Rails.cache.write "app-#{app['name']}", app['servers']
    end
  end

  after do
    Timecop.return
  end

  describe "GET /" do
    around do |e|
      stub_env(DEPLOY_SUPPORT_TOOL_STAGING_URL_FORMAT: 'https://%s-staging-%d.herokuapp.com/') { e.run }
    end

    before do
      page.driver.browser.authorize(ENV['AUTH_USER'], ENV['AUTH_PASSWORD'])
    end

    it "shows staging apps URL, branch name and last use" do
      visit "/apps"

      expect(page).to have_css("a[name='sunt-perferendis']")
      expect(page).to have_content("https://sunt-perferendis-staging-1.herokuapp.com/")
      expect(page).to have_content("praesentium-quis-et")
      expect(page).to have_content("1 day ago")
    end
  end
end
