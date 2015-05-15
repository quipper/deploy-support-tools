require 'spec_helper'

describe StagingUrl do
  let(:text) { "staging <https://github.com/quipper/qlink/pull/3000>" }
  subject { StagingUrl.new(text, github_api_token: 'a', circleci_api_token: 'b') }

  before do
    allow_any_instance_of(StagingUrl).to receive(:get_git_branch_name)
    allow_any_instance_of(StagingUrl).to receive(:get_heroku_url)
  end

  it 'parses input text' do
    expect(subject.instance_variable_get('@user')).to eq('quipper')
    expect(subject.instance_variable_get('@repo')).to eq('qlink')
    expect(subject.instance_variable_get('@number')).to eq('3000')
  end
end
