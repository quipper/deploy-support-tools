require 'spec_helper'

describe App do
  let(:store) { ActiveSupport::Cache::MemoryStore.new }
  let(:name) { 'awesome-application' }
  let(:max_entries) { 3 }
  let(:app) { App.new name, max_entries, store }

  describe '#lottery' do
    it '1st' do
      expect(app.lottery 'foo').to eq 1
    end

    it '2nd' do
      app.lottery 'foo'
      expect(app.lottery 'foo').to eq 1
    end

    it 'alt' do
      app.lottery 'foo'
      expect(app.lottery 'bar').to eq 2
    end

    it 'alt' do
      app.lottery 'foo'
      app.lottery 'bar'
      expect(app.lottery 'foo').to eq 1
    end

    it 'overflow' do
      app.lottery 'foo' # => 1
      app.lottery 'bar' # => 2
      app.lottery 'baz' # => 3
      expect(app.lottery 'yah').to eq 1
    end

    it 'rollover' do
      app.lottery 'foo' # => 1
      app.lottery 'bar' # => 2
      app.lottery 'baz' # => 3
      app.lottery 'yah' # => 1
      expect(app.lottery 'foo').to eq 2
    end

    context 'trimmed' do
      let(:dec) { App.new name, max_entries - 1, store }

      before do
        app.lottery 'foo' # => 1
        app.lottery 'bar' # => 2
        app.lottery 'baz' # => 3
        app.save
      end

      it '1st' do
        expect(dec.lottery 'foo').to eq 1
      end

      it '2nd' do
        expect(dec.lottery 'bar').to eq 2
      end

      it 'trimmed' do
        expect(dec.lottery 'baz').to eq 1
      end
    end

    context 'increase' do
      let(:inc) { App.new name, max_entries + 1, store }

      before do
        app.lottery 'foo' # => 1
        app.lottery 'bar' # => 2
        app.lottery 'baz' # => 3
        app.save
      end

      it 'old' do
        expect(inc.lottery 'foo').to eq 1
        expect(inc.lottery 'bar').to eq 2
        expect(inc.lottery 'baz').to eq 3
      end

      it 'new' do
        expect(inc.lottery 'woo').to eq 4
      end

      it 'new and old' do
        expect(inc.lottery 'woo').to eq 4
        expect(inc.lottery 'foo').to eq 1
        expect(inc.lottery 'yah').to eq 2
      end
    end

    context 'when there are some removed entries' do
      before do
        app.lottery 'foo' # => 1
        app.lottery 'bar' # => 2
        app.lottery 'baz' # => 3

        app.remove 'bar'
        app.remove 'baz'
      end

      context 'and pushed a new branch' do
        it 'deletes "removed" flag' do
          expect {
            app.lottery('woo')
          }.to change {
            app.entries[1]['removed']
          }.from(true).to(nil)
        end

        it 'returns number of removed branch' do
          expect(app.lottery('woo')).to eq 2
        end
      end

      context 'and pushed removed branch again' do
        it 'deletes "removed" flag' do
          expect {
            app.lottery('baz')
          }.to change {
            app.entries[2]['removed']
          }.from(true).to(nil)
        end

        it 'returns same number again' do
          expect(app.lottery('baz')).to eq 3
        end
      end
    end
  end

  describe '#remove' do
    context 'when specified branch exists' do
      before do
        app.lottery 'foo'
        app.lottery 'bar'
        app.lottery 'baz'

        app.remove('bar')
      end

      it 'set `removed` flag to target branch' do
        expect(app.entries[0]['removed']).to be_nil
        expect(app.entries[1]['removed']).to be true
        expect(app.entries[2]['removed']).to be_nil
      end
    end

    context 'when specified branch does not exist' do
      before do
        app.lottery 'foo'
        app.lottery 'bar'
        app.lottery 'baz'

        app.remove('foobar')
      end

      it 'does not set `removed` flag to any entries' do
        expect(app.entries[0]['removed']).to be_nil
        expect(app.entries[1]['removed']).to be_nil
        expect(app.entries[2]['removed']).to be_nil
      end
    end

    context 'when no entry exists' do
      before do
        app.remove('foo')
      end

      it 'does not change entries' do
        expect(app.entries).to eq []
      end
    end
  end
end
