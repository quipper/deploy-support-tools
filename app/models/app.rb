class App
  attr_reader :max_entries, :store

  def initialize(name, max_entries, store=Rails.cache)
    @name = name
    @max_entries = max_entries
    @store = store
  end

  # @return Integer number of app
  def lottery(branch)
    exist_entry = entries.find { |e| e['branch_name'] == branch }
    if exist_entry
      update_entry!(exist_entry, branch)
      return entries.index(exist_entry) + 1
    end

    removed_entry = entries.find { |e| e['removed'] }
    if removed_entry
      update_entry!(removed_entry, branch)
      return entries.index(removed_entry) + 1
    end

    if entries.size == max_entries
      oldest_entry = entries.min_by { |e| e['last_use'] }
      update_entry!(oldest_entry, branch)
      return entries.index(oldest_entry) + 1
    end

    entries.push(new_entry = { 'branch_name' => branch, 'last_use' => Time.now })
    return entries.index(new_entry) + 1
  end

  # Set `removed` flag to an entry with specified branch name
  def remove(branch)
    target_entry = entries.find { |e| e['branch_name'] == branch }
    target_entry['removed'] = true if target_entry
  end

  def save
    store.write name, entries
  end

  def name
    "app-#{@name}"
  end

  def entries
    @entries ||= trim(store.read(name) || [])
  end

  def trim(_entries)
    _entries[0, max_entries]
  end

  private

  def update_entry!(entry, branch_name)
    entry['branch_name'] = branch_name
    entry['last_use'] = Time.now
    entry.delete 'removed'
    entry
  end
end
