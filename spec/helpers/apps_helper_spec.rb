require 'spec_helper'

describe AppsHelper, type: :helper do
  describe '#staging_url_for_app' do
    context 'when DEPLOY_SUPPORT_TOOL_STAGING_URL_FORMAT is not given' do
      it 'returns without formatting' do
        expect(staging_url_for_app('foo', 1)).to eq 'foo:1'
      end
    end

    context 'when DEPLOY_SUPPORT_TOOL_STAGING_URL_FORMAT is given' do
      around do |e|
        stub_env(DEPLOY_SUPPORT_TOOL_STAGING_URL_FORMAT: 'https://%s-staging-%d.herokuapp.com/') { e.run }
      end

      context 'when DEPLOY_SUPPORT_TOOL_STAGING_URL_OF_IGNORING_PREFIXES is not given' do
        it 'returns formatted url' do
          expect(staging_url_for_app('foo-tomo', 1)).to eq 'https://foo-tomo-staging-1.herokuapp.com/'
        end
      end

      context 'when DEPLOY_SUPPORT_TOOL_STAGING_URL_OF_IGNORING_PREFIXES is given' do
        around do |e|
          stub_env(DEPLOY_SUPPORT_TOOL_STAGING_URL_OF_IGNORING_PREFIXES: 'foo,bar') { e.run }
        end

        context 'when app is matched with prefix' do
          it 'omits prefix and returns formatted url' do
            expect(staging_url_for_app('foo-tomo', 1)).to eq 'https://tomo-staging-1.herokuapp.com/'
          end
        end

        context 'when app is matched with another prefix' do
          it 'omits prefix and returns formatted url' do
            expect(staging_url_for_app('bar-tomo', 1)).to eq 'https://tomo-staging-1.herokuapp.com/'
          end
        end

        context 'when app is not matched with prefix' do
          it 'does not omit and returns formatted url' do
            expect(staging_url_for_app('baz-tomo', 1)).to eq 'https://baz-tomo-staging-1.herokuapp.com/'
          end
        end
      end
    end
  end
end
