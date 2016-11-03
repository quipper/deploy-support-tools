require 'spec_helper'

RSpec.describe WebhookController, type: :controller do
  describe '#receive' do
    context 'when ping event' do
      before do
        request.headers['X-GitHub-Event'] = 'ping'
        post :receive, nil
      end

      it 'returns ok' do
        expect(response.status).to eq 200
        expect(response.body).to eq 'ok'
      end
    end

    context 'when pull_request event' do
      context 'and RepoConfig is found' do
        let(:webhook_params) do
          {
            action: 'closed',
            pull_request: {
              head: {
                ref: 'feature-branch'
              },
              base: {
                repo: {
                  full_name: 'quipper/foo'
                }
              }
            }
          }
        end

        subject do
          request.headers['X-GitHub-Event'] = 'pull_request'
          post :receive, {webhook: webhook_params.to_json}
        end

        before do
          allow(RepoConfig).to receive(:find_by_repo_name)
            .with('quipper/foo')
            .and_return(RepoConfig.new(repo_name: 'quipper/foo', app_prefix: 'foo', max_entries: 10))
        end

        context 'and action is "closed"' do
          it 'removes target branch' do
            expect_any_instance_of(App).to receive(:remove).with('feature-branch')

            subject
          end
        end

        context 'and action is not "closed"' do
          it 'does not remove target branch' do
            webhook_params[:action] = 'opened'
            expect_any_instance_of(App).not_to receive(:remove)

            subject
          end
        end
      end

      context 'and RepoConfig is not found' do
        before do
          allow(RepoConfig).to receive(:find_by_repo_name)
            .with('quipper/foo')
            .and_return(nil)
        end

        it 'does not remove target branch' do
          expect_any_instance_of(App).not_to receive(:remove)

          subject
        end
      end
    end
  end
end
