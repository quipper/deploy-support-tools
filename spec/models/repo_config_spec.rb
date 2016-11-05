require 'spec_helper'

describe RepoConfig do
  let(:store) { ActiveSupport::Cache::MemoryStore.new }

  describe '#name' do
    let(:repo_config) { RepoConfig.new(repo_name: 'quipper/foo', store: store) }

    subject { repo_config.name }

    it { is_expected.to eq 'repo_config-quipper/foo' }
  end

  describe '#save' do
    let(:repo_config) do
      repo_config = RepoConfig.new(
        repo_name: 'quipper/foo',
        app_prefix: 'foo',
        max_entries: 10,
        store: store,
      )
    end

    it 'persists attributes in cache store' do
      expect {
        repo_config.save
      }.to change {
        store.read(repo_config.name)
      }.from(nil).to({app_prefix: 'foo', max_entries: 10})
    end
  end
end
