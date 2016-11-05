require 'active_model'

class RepoConfig
  CACHE_KEY_PREFIX = 'repo_config'

  include ActiveModel::Model

  attr_accessor :app_prefix, :repo_name, :max_entries
  attr_reader :store

  validates :app_prefix, presence: true
  validates :repo_name, presence: true
  validates :max_entries,
    presence: true,
    numericality: {only_integer: true, greater_than_or_equal_to: 0}

  def self.find_by_repo_name(repo_name)
    config = Rails.cache.read("#{CACHE_KEY_PREFIX}-#{repo_name}")
    config ? self.new(config) : nil
  end

  def initialize(attrs)
    @store = attrs.delete(:store) || Rails.cache
    super(attrs)
  end

  def save
    store.write name, attributes
  end

  def name
    "#{CACHE_KEY_PREFIX}-#{repo_name}"
  end

  def attributes
    {
      app_prefix: app_prefix,
      max_entries: max_entries,
    }
  end
end
