def stub_env(**envs)
  before = ENV.to_h
  ENV.update envs.stringify_keys
  begin
    yield
  ensure
    ENV.replace before
  end
end
